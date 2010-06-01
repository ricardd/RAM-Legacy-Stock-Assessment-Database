#include <admodel.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <cbdkalman.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  N.allocate("N");
  length1.allocate("length1");
  length2.allocate("length2");
  cutoff.allocate("cutoff");
  years.allocate(1,N,"years");
  y.allocate(1,N,"y");
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  varproc.allocate(1.0e-16,1.0e+7,"varproc");
  varobs.allocate(1.0e-16,1.0e+7,"varobs");
  slope_pre.allocate("slope_pre");
  slope_post.allocate("slope_post");
  nll.allocate("nll");
}

void model_parameters::userfunction(void)
{
  nll=0.0;
  // need to use arrays to keep track of all estimates for smoothing
  // dimensions
  int m = 2;
  int p = 1; 
  int myr = m;
  dvar3_array a(1,N+1,1,m,1,1); 
  dvar3_array P(1,N+1,1,m,1,m); 
  dvar3_array Z(1,N,1,p,1,m); 
  dvar3_array T(1,N,1,m,1,m); 
  dvar3_array v(1,N,1,p,1,1); 
  dvar3_array F(1,N,1,p,1,p); 
  dvar3_array K(1,N,1,m,1,p); 
  dvar3_array L(1,N,1,m,1,m); 
  dvar3_array R(1,N,1,m,1,m); 
  dvar3_array Q(1,N,1,myr,1,myr);
  dvar3_array H(1,N,1,p,1,p); 
  // initialize
  a(2)(1,1)=y(1);
  a(2)(2,1)=slope_pre;
  P(2)(1,1)=varproc+varobs;
  P(2)(2,1)=0.0; P(2)(1,2)=0.0; P(2)(2,2)=0.0;
  for(int i=1; i<=N; ++i){
    Z(i)(1,1)=1.0; 
    Z(i)(1,2)=0.0;
    T(i)(1,1)=1.0;
    T(i)(2,1)=0.0; T(i)(1,2)=1.0; T(i)(2,2)=1.0;
    R(i)(1,1)=1.0;
    R(i)(2,1)=0.0; R(i)(1,2)=0.0; R(i)(2,2)=1.0;
    H(i)(1,1)=varobs;
    Q(i)(1,1)=varproc;
    Q(i)(1,2)=0.0;
    Q(i)(2,1)=0.0;
    Q(i)(2,2)=0.0;
  }
  // Kalman recursions
  for(int t=2; t<=N; ++t){
    v(t) = y(t)-Z(t)*a(t);
    F(t) = Z(t)*P(t)*trans(Z(t))+H(t);
    K(t) = T(t)*P(t)*trans(Z(t))*inv(F(t));
    L(t) = T(t)-K(t)*Z(t);
    // loglikelihood contribution
    dvar_matrix obj1=log(det(F(t)))+trans(v(t))*inv(F(t))*v(t);
    dvariable obj=obj1(1,1);
    nll-=-0.5*log(2*M_PI)-0.5*(obj);
    // notice the switch here
    if(years(t)>=cutoff){
      a(t)(2,1)=slope_post;
    }
    a(t+1) = T(t)*a(t)+K(t)*v(t);
    P(t+1) = T(t)*P(t)*trans(L(t))+R(t)*Q(t)*trans(R(t));
  }
}

void model_parameters::set_runtime(void)
{
  dvector temp("{1.0e-6;}");
  convergence_criteria.allocate(temp.indexmin(),temp.indexmax());
  convergence_criteria=temp;
  dvector temp1("{20000;}");
  maximum_function_evaluations.allocate(temp1.indexmin(),temp1.indexmax());
  maximum_function_evaluations=temp1;
}

void model_parameters::report()
{
 adstring ad_tmp=initial_params::get_reportfile_name();
  ofstream report((char*)(adprogram_name + ad_tmp));
  if (!report)
  {
    cerr << "error trying to open report file"  << adprogram_name << ".rep";
    return;
  }
  int m = 2; 
  int p = 1; 
  int myr = m;
  dvar3_array a(1,N+1,1,m,1,1); 
  dvar3_array P(1,N+1,1,m,1,m); 
  dvar3_array Z(1,N,1,p,1,m); 
  dvar3_array T(1,N,1,m,1,m); 
  dvar3_array v(1,N,1,p,1,1); 
  dvar3_array F(1,N,1,p,1,p); 
  dvar3_array K(1,N,1,m,1,p); 
  dvar3_array L(1,N,1,m,1,m); 
  dvar3_array R(1,N,1,m,1,m); 
  dvar3_array Q(1,N,1,myr,1,myr);
  dvar3_array H(1,N,1,p,1,p); 
  // initialize
  a(2)(1,1)=y(1);
  a(2)(2,1)=0.0;
  P(2)(1,1)=varproc+varobs;
  P(2)(2,1)=0.0; P(2)(1,2)=0.0; P(2)(2,2)=0.0;
  for(int i=1; i<=N; ++i){
    Z(i)(1,1)=1.0; 
    Z(i)(1,2)=0.0;
    T(i)(1,1)=1.0;
    T(i)(2,1)=0.0; T(i)(1,2)=1.0; T(i)(2,2)=1.0;
    R(i)(1,1)=1.0;
    R(i)(2,1)=0.0; R(i)(1,2)=0.0; R(i)(2,2)=1.0;
    H(i)(1,1)=varobs;
    Q(i)(1,1)=varproc;
    Q(i)(1,2)=0.0;
    Q(i)(2,1)=0.0;
    Q(i)(2,2)=0.0;
  }
  // Kalman recursions
  for(int t=2; t<=N; ++t){
    v(t) = y(t)-Z(t)*a(t);
    F(t) = Z(t)*P(t)*trans(Z(t))+H(t);
    K(t) = T(t)*P(t)*trans(Z(t))*inv(F(t));
    L(t) = T(t)-K(t)*Z(t);
    // loglikelihood contribution
    dvar_matrix obj1=log(det(F(t)))+trans(v(t))*inv(F(t))*v(t);
    dvariable obj=obj1(1,1);
    nll-=-0.5*log(2*M_PI)-0.5*(obj);
    a(t+1) = T(t)*a(t)+K(t)*v(t);
    P(t+1) = T(t)*P(t)*trans(L(t))+R(t)*Q(t)*trans(R(t));
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
}

void model_parameters::preliminary_calculations(void){
  admaster_slave_variable_interface(*this);
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{}

void model_parameters::final_calcs(void){}

#ifdef _BORLANDC_
  extern unsigned _stklen=10000U;
#endif


#ifdef __ZTC__
  extern unsigned int _stack=10000U;
#endif

  long int arrmblsize=0;

int main(int argc,char * argv[])
{
    ad_set_new_handler();
  ad_exit=&ad_boundf;
    gradient_structure::set_NO_DERIVATIVES();
    gradient_structure::set_YES_SAVE_VARIABLES_VALUES();
  #if defined(__GNUDOS__) || defined(DOS386) || defined(__DPMI32__)  || \
     defined(__MSVC32__)
      if (!arrmblsize) arrmblsize=150000;
  #else
      if (!arrmblsize) arrmblsize=25000;
  #endif
    model_parameters mp(arrmblsize,argc,argv);
    mp.iprint=10;
    mp.preliminary_calculations();
    mp.computations(argc,argv);
    return 0;
}

extern "C"  {
  void ad_boundf(int i)
  {
    /* so we can stop here */
    exit(i);
  }
}
