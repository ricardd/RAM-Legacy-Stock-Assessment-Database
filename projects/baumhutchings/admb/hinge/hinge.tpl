DATA_SECTION
  init_int T
  init_number cutoff
  init_vector years(1,T)
  init_vector lnssb(1,T)

PARAMETER_SECTION
  init_number a1
  init_number b1
  init_number b2
  init_bounded_number sdobs(1.0e-16,1.0e+4);
  objective_function_value nll;

PROCEDURE_SECTION
  nll=0.0;
  dvariable a2=a1+cutoff*(b1-b2);
  dvar_vector predicted(1,T);

  for(int i=1; i<=T; ++i){
    if(years(i)<cutoff){
      predicted(i)=a1+b1*years(i); 
    }
    if(years(i)>=cutoff){
      predicted(i)=a2+b2*years(i); 
    }
  }
  nll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*sum(square((lnssb-predicted)/sdobs));

