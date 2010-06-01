#include <admodel.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <processerroronly.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  T.allocate("T");
  length1.allocate("length1");
  length2.allocate("length2");
  cutoff.allocate("cutoff");
  years.allocate(1,T,"years");
  y.allocate(1,T,"y");
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  sdproc.allocate(1e-12,1.0e+2,"sdproc");
  slope_pre.allocate(-1.0e+2,1.0e+2,"slope_pre");
  slope_post.allocate(-1.0e+2,1.0e+2,"slope_post");
  state.allocate(1,T,"state");
  jnll.allocate("jnll");
}

void model_parameters::userfunction(void)
{
  jnll=0.0;
  state(1)=y(1);
  for(int i=2; i<=T; ++i){
   if(years(i)<=cutoff){
    state(i)=y(i-1)+slope_pre; //PLEASE NOTE: y here not state!!
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((y(i)-state(i))/sdproc);
    }
    if(years(i)>cutoff){
    state(i)=y(i-1)+slope_post;
    jnll-=-log(sqrt(2.0*M_PI))-log(sdproc)-0.5*square((y(i)-state(i))/sdproc);
    }
  }
  //if(sd_phase){
  //  predstate=state;
  //}
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
