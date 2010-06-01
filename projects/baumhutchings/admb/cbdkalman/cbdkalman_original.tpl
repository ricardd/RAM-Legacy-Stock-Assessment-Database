//---------------------------------------------
// Kalman filter for CBD analysis
// CM
// Date: Mon Feb  1 11:50:35 AST 2010
// Time-stamp: <Last modified: 6 FEBRUARY 2010  (srdbadmin)>
// Notes: Diffuse likelihood from Durbin and 
// Koopman. Matrix form used.
//---------------------------------------------

DATA_SECTION
  init_int N
  init_int length1
  init_int length2
  init_number cutoff
  init_vector years(1,N)
  init_vector y(1,N)

PARAMETER_SECTION
  init_bounded_number varproc(1.0e-7,1.0e+7)
  init_bounded_number varobs(1.0e-7,1.0e+7)
  init_bounded_number slope_pre(-1.0e+2,1.0e+2)
  init_bounded_number slope_post(-1.0e+2,1.0e+2)
  objective_function_value nll;

PROCEDURE_SECTION
  nll=0.0;
  // need to use arrays to keep track of all estimates for smoothing
  // dimensions
  int m = 2; 
  int p = 1; 
  dvar3_array a(1,N+1,1,m,1,1); 
  dvar3_array P(1,N+1,1,m,1,m); 
  dvar3_array Z(1,N,1,p,1,m); 
  dvar3_array T(1,N,1,m,1,m); 
  dvar3_array v(1,N,1,p,1,1); 
  dvar3_array F(1,N,1,p,1,p); 
  dvar3_array K(1,N,1,m,1,p); 
  dvar3_array L(1,N,1,m,1,m); 
  // initialize
  a(2)(1,1)=y(1);
  a(2)(2,1)=0.0;
  P(2)(1,1)=varproc+varobs;
  P(2)(2,1)=0.0; P(2)(1,2)=0.0; P(2)(2,2)=0.0;
  for(int i=1; i<=N; ++i){
    Z(i)(1,1)=1.0; 
    Z(i)(1,2)=0.0;
    T(i)(1,1)=1.0;
    T(i)(2,1)=0.0; T(i)(1,2)=0.0; T(i)(2,2)=0.0;
  }
  // Kalman recursions
  for(int t=2; t<=N; ++t){
    v(t) = y(t)-Z(t)*a(t);
    F(t) = Z(t)*P(t)*trans(Z(t))+varobs;
    K(t) = T(t)*P(t)*trans(Z(t))*inv(F(t));
    L(t) = T(t)-K(t)*Z(t);
    // loglikelihood contribution
    dvar_matrix obj1=log(det(F(t)))+trans(v(t))*inv(F(t))*v(t);
    dvariable obj=obj1(1,1);
    nll-=-0.5*log(2*M_PI)-0.5*(obj);
    a(t+1) = T(t)*a(t)+K(t)*v(t);
    P(t+1) = T(t)*P(t)*trans(L(t))+varproc;
  }

REPORT_SECTION
  int m = 2; 
  int p = 1; 
  dvar3_array a(1,N+1,1,m,1,1); 
  dvar3_array P(1,N+1,1,m,1,m); 
  dvar3_array Z(1,N,1,p,1,m); 
  dvar3_array T(1,N,1,m,1,m); 
  dvar3_array v(1,N,1,p,1,1); 
  dvar3_array F(1,N,1,p,1,p); 
  dvar3_array K(1,N,1,m,1,p); 
  dvar3_array L(1,N,1,m,1,m); 
  // initialize
  a(2)(1,1)=y(1);
  a(2)(2,1)=0.0;
  P(2)(1,1)=varproc+varobs;
  P(2)(2,1)=0.0; P(2)(1,2)=0.0; P(2)(2,2)=0.0;
  for(int i=1; i<=N; ++i){
    Z(i)(1,1)=1.0; 
    Z(i)(1,2)=0.0;
    T(i)(1,1)=1.0;
    T(i)(2,1)=0.0; T(i)(1,2)=0.0; T(i)(2,2)=0.0;
  }
  // Filter
  for(int t=2; t<=N; ++t){
    v(t) = y(t)-Z(t)*a(t);
    F(t) = Z(t)*P(t)*trans(Z(t))+varobs;
    K(t) = T(t)*P(t)*trans(Z(t))*inv(F(t));
    L(t) = T(t)-K(t)*Z(t);
    // loglikelihood contribution
    dvar_matrix obj1=log(det(F(t)))+trans(v(t))*inv(F(t))*v(t);
    dvariable obj=obj1(1,1);
    nll-=-0.5*log(2*M_PI)-0.5*(obj);
    a(t+1) = T(t)*a(t)+K(t)*v(t);
    P(t+1) = T(t)*P(t)*trans(L(t))+varproc;
  }
  // Smoother
  dvar3_array r(1,N+1,1,m,1,1);
  dvar3_array alpha(1,N+1,1,m,1,1);
  dvar3_array N1(1,N+1,1,m,1,m);
  dvar3_array V(1,N+1,1,m,1,m);
  // initialize
  r(N+1)(1,1)=0.0;
  r(N+1)(2,1)=0.0;
  N1(N+1)=0.0;
  N1(N+1)(2,1)=0.0; N1(N+1)(1,2)=0.0; N1(N+1)(2,2)=0.0;
  for(int t=N; t>1; --t){
    r(t-1)=trans(Z(t))*inv(F(t))*v(t)+trans(L(t))*r(t);
    N1(t-1)=trans(Z(t))*inv(F(t))*Z(t)+trans(L(t))*N1(t)*L(t);
    alpha(t)=a(t)+P(t)*r(t-1);
    V(t)=P(t)-P(t)*N1(t-1)*P(t);
  }

  dvar_vector ahat(1,N+1);
  dvar_vector Phat(1,N+1);  
  dvar_vector alphahat(1,N+1);
  dvar_vector Vhat(1,N+1);  

  for(int t=1; t<=(N+1); ++t){
    ahat(t)=a(t)(1,1);
    Phat(t)=P(t)(1,1);
    alphahat(t)=alpha(t)(1,1);
    Vhat(t)=V(t)(1,1);
  }
  alphahat(1)=y(1)+varobs*r(1)(1,1);
  Vhat(1)=varobs-square(varobs)*N1(1)(1,1);
  
  report << "Filtered state estimates" << endl;
  report << ahat << endl;
  report << "Variance of the filtered states" << endl;
  report << Phat << endl;
  report << "Smoothed state estimates" << endl;
  report << alphahat << endl;
  report << "Variance of the smoothed states" << endl;
  report << Vhat << endl;
