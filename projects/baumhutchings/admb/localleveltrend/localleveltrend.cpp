#include <admodel.h>

#include <df1b2fun.h>

#include <adrndeff.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <localleveltrend.htp>

  df1b2_parameters * df1b2_parameters::df1b2_parameters_ptr=0;
  model_parameters * model_parameters::model_parameters_ptr=0;
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
  model_parameters_ptr=this;
  initializationfunction();
  sdproc.allocate(1e-30,1.0e+2,"sdproc");
  sdobs.allocate(1e-30,1.0e+2,"sdobs");
  slope_pre.allocate(-1.0e+2,1.0e+2,"slope_pre");
  slope_post.allocate(-1.0e+2,1.0e+2,"slope_post");
  state.allocate(1,T,"state");
  jnll.allocate("jnll");  /* ADOBJECTIVEFUNCTION */
}
void model_parameters::userfunction(void)
{
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
  
}
  long int arrmblsize=0;

int main(int argc,char * argv[])
{
  ad_set_new_handler();
  ad_exit=&ad_boundf;
  gradient_structure::set_MAX_NVAR_OFFSET(50000);
  arrmblsize = 200000000;
    gradient_structure::set_NO_DERIVATIVES();
    gradient_structure::set_YES_SAVE_VARIABLES_VALUES();
  #if defined(__GNUDOS__) || defined(DOS386) || defined(__DPMI32__)  || \
     defined(__MSVC32__)
      if (!arrmblsize) arrmblsize=150000;
  #else
      if (!arrmblsize) arrmblsize=25000;
  #endif
    df1b2variable::noallocate=1;
    df1b2_parameters mp(arrmblsize,argc,argv);
    mp.iprint=10;

    function_minimizer::random_effects_flag=1;
    df1b2variable::noallocate=0;
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

void df1b2_parameters::user_function(void)
{
  jnll=0.0;
  jnll-=-log(sqrt(2.0*M_PI))-log(sdobs)-0.5*square((y(1)-state(1))/sdobs);
  // process
  df1b2vector predstate(1,T);
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
  
}
   
void df1b2_pre_parameters::setup_quadprior_calcs(void) 
{ 
  df1b2_gradlist::set_no_derivatives(); 
  quadratic_prior::in_qp_calculations=1; 
}  
  
void df1b2_pre_parameters::begin_df1b2_funnel(void) 
{ 
  (*re_objective_function_value::pobjfun)=0; 
  other_separable_stuff_begin(); 
  f1b2gradlist->reset();  
  if (!quadratic_prior::in_qp_calculations) 
  { 
    df1b2_gradlist::set_yes_derivatives();  
  } 
  funnel_init_var::allocate_all();  
}  
 
void df1b2_pre_parameters::end_df1b2_funnel(void) 
{  
  lapprox->do_separable_stuff(); 
  other_separable_stuff_end(); 
} 
  
void model_parameters::begin_df1b2_funnel(void) 
{ 
  if (lapprox)  
  {  
    {  
      begin_funnel_stuff();  
    }  
  }  
}  
 
void model_parameters::end_df1b2_funnel(void) 
{  
  if (lapprox)  
  {  
    end_df1b2_funnel_stuff();  
  }  
} 

void df1b2_parameters::allocate(void) 
{
  sdproc.allocate(1e-30,1.0e+2,"sdproc");
  sdobs.allocate(1e-30,1.0e+2,"sdobs");
  slope_pre.allocate(-1.0e+2,1.0e+2,"slope_pre");
  slope_post.allocate(-1.0e+2,1.0e+2,"slope_post");
  state.allocate(1,T,"state");
  jnll.allocate("jnll");  /* ADOBJECTIVEFUNCTION */
}
