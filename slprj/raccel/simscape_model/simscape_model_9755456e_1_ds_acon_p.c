#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_acon_p.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_acon_p ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static int32_T
_cg_const_2 [ 20 ] = { 0 , 6 , 2 , 3 , 13 , 4 , 1 , 13 , 2 , 13 , 6 , 0 , 6 ,
6 , 1 , 13 , 2 , 3 , 13 , 4 } ; static int32_T _cg_const_1 [ 15 ] = { 0 , 2 ,
5 , 6 , 8 , 10 , 11 , 13 , 13 , 14 , 16 , 19 , 19 , 19 , 20 } ; ( void ) t1 ;
out -> mACON_P . mNumCol = 14UL ; out -> mACON_P . mNumRow = 14UL ; out ->
mACON_P . mJc [ 0 ] = _cg_const_1 [ 0 ] ; out -> mACON_P . mJc [ 1 ] =
_cg_const_1 [ 1 ] ; out -> mACON_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out ->
mACON_P . mJc [ 3 ] = _cg_const_1 [ 3 ] ; out -> mACON_P . mJc [ 4 ] =
_cg_const_1 [ 4 ] ; out -> mACON_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out ->
mACON_P . mJc [ 6 ] = _cg_const_1 [ 6 ] ; out -> mACON_P . mJc [ 7 ] =
_cg_const_1 [ 7 ] ; out -> mACON_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out ->
mACON_P . mJc [ 9 ] = _cg_const_1 [ 9 ] ; out -> mACON_P . mJc [ 10 ] =
_cg_const_1 [ 10 ] ; out -> mACON_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out
-> mACON_P . mJc [ 12 ] = _cg_const_1 [ 12 ] ; out -> mACON_P . mJc [ 13 ] =
_cg_const_1 [ 13 ] ; out -> mACON_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out
-> mACON_P . mIr [ 0 ] = _cg_const_2 [ 0 ] ; out -> mACON_P . mIr [ 1 ] =
_cg_const_2 [ 1 ] ; out -> mACON_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out ->
mACON_P . mIr [ 3 ] = _cg_const_2 [ 3 ] ; out -> mACON_P . mIr [ 4 ] =
_cg_const_2 [ 4 ] ; out -> mACON_P . mIr [ 5 ] = _cg_const_2 [ 5 ] ; out ->
mACON_P . mIr [ 6 ] = _cg_const_2 [ 6 ] ; out -> mACON_P . mIr [ 7 ] =
_cg_const_2 [ 7 ] ; out -> mACON_P . mIr [ 8 ] = _cg_const_2 [ 8 ] ; out ->
mACON_P . mIr [ 9 ] = _cg_const_2 [ 9 ] ; out -> mACON_P . mIr [ 10 ] =
_cg_const_2 [ 10 ] ; out -> mACON_P . mIr [ 11 ] = _cg_const_2 [ 11 ] ; out
-> mACON_P . mIr [ 12 ] = _cg_const_2 [ 12 ] ; out -> mACON_P . mIr [ 13 ] =
_cg_const_2 [ 13 ] ; out -> mACON_P . mIr [ 14 ] = _cg_const_2 [ 14 ] ; out
-> mACON_P . mIr [ 15 ] = _cg_const_2 [ 15 ] ; out -> mACON_P . mIr [ 16 ] =
_cg_const_2 [ 16 ] ; out -> mACON_P . mIr [ 17 ] = _cg_const_2 [ 17 ] ; out
-> mACON_P . mIr [ 18 ] = _cg_const_2 [ 18 ] ; out -> mACON_P . mIr [ 19 ] =
_cg_const_2 [ 19 ] ; ( void ) sys ; ( void ) out ; return 0 ; }
