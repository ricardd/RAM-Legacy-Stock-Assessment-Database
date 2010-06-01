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
  random_effects_vector state1(1,length1)
  random_effects_vector state2(1,length2)
  objective_function_value jnll;

PROCEDURE_SECTION
  jnll=0.0;
  // pre-cutoff
  //first observation
  jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(1)-state1(1))/sdobs);
  dvar_vector predstate1(1,length1);
  for(int i=2; i<=length1; ++i){
      predstate1(i)=state1(i-1)+slope_pre; 
      jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((state1(i)-predstate1(i))/sdproc);
      jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(i)-state1(i))/sdobs);
   } 
  // post cut-off
  // first observation
  jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(length1+1)-state2(1))/sdobs);
  dvar_vector predstate2(1,length2);
  for(int j=2; j<=length2; ++j){
      predstate2(j)=state2(j-1)+slope_post; 
      jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((state2(j)-predstate2(j))/sdproc);
      jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(length1+j)-state2(j))/sdobs);
   } 

TOP_OF_MAIN_SECTION
  gradient_structure::set_MAX_NVAR_OFFSET(50000);
  arrmblsize = 2000000;
