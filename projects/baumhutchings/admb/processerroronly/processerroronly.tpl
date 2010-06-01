DATA_SECTION
  init_int T
  init_int length1
  init_int length2
  init_number cutoff
  init_vector years(1,T)
  init_vector y(1,T)

PARAMETER_SECTION
  init_bounded_number sdproc(1e-12,1.0e+2) // process error
  init_bounded_number slope_pre(-1.0e+2,1.0e+2)
  init_bounded_number slope_post(-1.0e+2,1.0e+2)
  sdreport_vector state(1,T);
  objective_function_value jnll;

PROCEDURE_SECTION
  jnll=0.0;
  state(1)=y(1);
  for(int i=2; i<=T; ++i){
   if(years(i)<cutoff){
    state(i)=y(i-1)+slope_pre; //PLEASE NOTE: y here not state!!
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((y(i)-state(i))/sdproc);
    }
    if(years(i)>=cutoff){
    state(i)=y(i-1)+slope_post;
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((y(i)-state(i))/sdproc);
    }
  }
  //if(sd_phase){
  //  predstate=state;
  //}
