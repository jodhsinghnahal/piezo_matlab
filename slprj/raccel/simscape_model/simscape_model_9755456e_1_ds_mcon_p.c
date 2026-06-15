#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_mcon_p.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_mcon_p ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static int32_T
_cg_const_1 [ 15 ] = { 0 , 1 , 2 , 3 , 4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5
, 5 } ; static int32_T _cg_const_2 [ 5 ] = { 0 , 3 , 4 , 1 , 2 } ; ( void )
t1 ; out -> mMCON_P . mNumCol = 14UL ; out -> mMCON_P . mNumRow = 14UL ; out
-> mMCON_P . mJc [ 0 ] = _cg_const_1 [ 0 ] ; out -> mMCON_P . mJc [ 1 ] =
_cg_const_1 [ 1 ] ; out -> mMCON_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out ->
mMCON_P . mJc [ 3 ] = _cg_const_1 [ 3 ] ; out -> mMCON_P . mJc [ 4 ] =
_cg_const_1 [ 4 ] ; out -> mMCON_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out ->
mMCON_P . mJc [ 6 ] = _cg_const_1 [ 6 ] ; out -> mMCON_P . mJc [ 7 ] =
_cg_const_1 [ 7 ] ; out -> mMCON_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out ->
mMCON_P . mJc [ 9 ] = _cg_const_1 [ 9 ] ; out -> mMCON_P . mJc [ 10 ] =
_cg_const_1 [ 10 ] ; out -> mMCON_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out
-> mMCON_P . mJc [ 12 ] = _cg_const_1 [ 12 ] ; out -> mMCON_P . mJc [ 13 ] =
_cg_const_1 [ 13 ] ; out -> mMCON_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out
-> mMCON_P . mIr [ 0 ] = _cg_const_2 [ 0 ] ; out -> mMCON_P . mIr [ 1 ] =
_cg_const_2 [ 1 ] ; out -> mMCON_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out ->
mMCON_P . mIr [ 3 ] = _cg_const_2 [ 3 ] ; out -> mMCON_P . mIr [ 4 ] =
_cg_const_2 [ 4 ] ; ( void ) sys ; ( void ) out ; return 0 ; }
