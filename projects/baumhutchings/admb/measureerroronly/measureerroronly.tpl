DATA_SECTION
  init_int T
  init_int length1
  init_int length2
  init_number cutoff
  init_vector years(1,T)
  init_vector y(1,T)

PARAMETER_SECTION
  init_bounded_number sdobs(1e-12,1.0e+2) // process error
  init_bounded_number slope_pre(-1.0e+2,1.0e+2)
  init_bounded_number slope_post(-1.0e+2,1.0e+2)
  init_number logSSB0
  sdreport_vector predstate(1,T);
  objective_function_value jnll;

PROCEDURE_SECTION
  jnll=0.0;
  dvar_vector state(1,T); 
  state(1)=logSSB0;
  for(int i=2; i<=T; ++i){
   if(years(i)<=cutoff){
    state(i)=state(i-1)+slope_pre; 
    }
    if(years(i)>cutoff){
    state(i)=state(i-1)+slope_post;
    }
  }
  jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*sum(square((y-state)/sdobs));
  if(sd_phase){
    predstate=state;
  }
 