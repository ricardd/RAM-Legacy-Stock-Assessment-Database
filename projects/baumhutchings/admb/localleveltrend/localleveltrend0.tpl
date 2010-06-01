DATA_SECTION
  init_int T
  init_int length1
  init_int length2
  init_number cutoff
  init_vector years(1,T)
  init_vector y(1,T)

PARAMETER_SECTION
  init_bounded_number sdproc(1e-30,1.0e+2) // process error
  init_bounded_number sdobs(1e-30,1.0e+2) // measurement error
  init_bounded_number slope_pre(-1.0e+2,1.0e+2)
  init_bounded_number slope_post(-1.0e+2,1.0e+2)
  random_effects_vector state(1,T)
  objective_function_value jnll;

PROCEDURE_SECTION
  jnll=0.0;
  jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(1)-state(1))/sdobs);
  // process
  dvar_vector predstate(1,T);
  for(int i=2; i<=T; ++i){
   if(years(i)<=cutoff){
    predstate(i)=state(i-1)+slope_pre; 
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((state(i)-predstate(i))/sdproc);
    jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(i)-state(i))/sdobs);
    }
    if(years(i)>cutoff){
    predstate(i)=state(i-1)+slope_post;
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((state(i)-predstate(i))/sdproc);
    jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(i)-state(i))/sdobs);
    }
  }
  // measurement
  //for(int i=1; i<=T; ++i){
  //jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(i)-state(i))/sdobs);
  //}
  
TOP_OF_MAIN_SECTION
  gradient_structure::set_MAX_NVAR_OFFSET(50000);
  arrmblsize = 2000000;
