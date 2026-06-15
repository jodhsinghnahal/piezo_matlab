#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_obs_il.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_obs_il ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static boolean_T
_cg_const_1 [ 129 ] = { true , true , true , true , true , true , true , true
, true , true , true , true , false , false , false , true , true , true ,
true , true , true , true , true , true , true , true , true , false , true ,
true , true , true , true , true , true , false , true , false , true , false
, true , true , true , true , true , true , true , false , true , false ,
true , true , false , false , true , true , true , true , true , false , true
, false , false , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
false , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , false , true , true , true , true , true , true , true ,
true , true , true } ; int32_T i ; ( void ) t1 ; for ( i = 0 ; i < 129 ; i ++
) { out -> mOBS_IL . mX [ i ] = _cg_const_1 [ i ] ; } ( void ) sys ; ( void )
out ; return 0 ; }
