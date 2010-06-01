#include <admodel.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <hinge.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  T.allocate("T");
  cutoff.allocate("cutoff");
  years.allocate(1,T,"years");
  lnssb.allocate(1,T,"lnssb");
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  a1.allocate("a1");
  b1.allocate("b1");
  b2.allocate("b2");
  sdobs.allocate(1.0e-16,1.0e+4,"sdobs");
  nll.allocate("nll");
}

void model_parameters::userfunction(void)
{
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
}

void model_parameters::preliminary_calculations(void){
  admaster_slave_variable_interface(*this);
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{}

void model_parameters::report(void){}

void model_parameters::final_calcs(void){}

void model_parameters::set_runtime(void){}

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
