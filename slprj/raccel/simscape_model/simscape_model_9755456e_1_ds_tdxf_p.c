#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_tdxf_p.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_tdxf_p ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static int32_T
_cg_const_2 [ 61 ] = { 0 , 5 , 6 , 7 , 8 , 2 , 3 , 7 , 8 , 9 , 11 , 13 , 4 ,
8 , 10 , 12 , 1 , 9 , 13 , 2 , 13 , 5 , 6 , 0 , 5 , 6 , 7 , 8 , 5 , 7 , 9 ,
10 , 6 , 8 , 11 , 12 , 1 , 7 , 8 , 9 , 11 , 13 , 2 , 3 , 7 , 8 , 9 , 11 , 13
, 7 , 8 , 10 , 12 , 7 , 8 , 10 , 12 , 4 , 8 , 10 , 12 } ; static int32_T
_cg_const_1 [ 15 ] = { 0 , 5 , 12 , 16 , 19 , 21 , 23 , 28 , 32 , 36 , 42 ,
49 , 53 , 57 , 61 } ; ( void ) t1 ; out -> mTDXF_P . mNumCol = 14UL ; out ->
mTDXF_P . mNumRow = 14UL ; out -> mTDXF_P . mJc [ 0 ] = _cg_const_1 [ 0 ] ;
out -> mTDXF_P . mJc [ 1 ] = _cg_const_1 [ 1 ] ; out -> mTDXF_P . mJc [ 2 ] =
_cg_const_1 [ 2 ] ; out -> mTDXF_P . mJc [ 3 ] = _cg_const_1 [ 3 ] ; out ->
mTDXF_P . mJc [ 4 ] = _cg_const_1 [ 4 ] ; out -> mTDXF_P . mJc [ 5 ] =
_cg_const_1 [ 5 ] ; out -> mTDXF_P . mJc [ 6 ] = _cg_const_1 [ 6 ] ; out ->
mTDXF_P . mJc [ 7 ] = _cg_const_1 [ 7 ] ; out -> mTDXF_P . mJc [ 8 ] =
_cg_const_1 [ 8 ] ; out -> mTDXF_P . mJc [ 9 ] = _cg_const_1 [ 9 ] ; out ->
mTDXF_P . mJc [ 10 ] = _cg_const_1 [ 10 ] ; out -> mTDXF_P . mJc [ 11 ] =
_cg_const_1 [ 11 ] ; out -> mTDXF_P . mJc [ 12 ] = _cg_const_1 [ 12 ] ; out
-> mTDXF_P . mJc [ 13 ] = _cg_const_1 [ 13 ] ; out -> mTDXF_P . mJc [ 14 ] =
_cg_const_1 [ 14 ] ; out -> mTDXF_P . mIr [ 0 ] = _cg_const_2 [ 0 ] ; out ->
mTDXF_P . mIr [ 1 ] = _cg_const_2 [ 1 ] ; out -> mTDXF_P . mIr [ 2 ] =
_cg_const_2 [ 2 ] ; out -> mTDXF_P . mIr [ 3 ] = _cg_const_2 [ 3 ] ; out ->
mTDXF_P . mIr [ 4 ] = _cg_const_2 [ 4 ] ; out -> mTDXF_P . mIr [ 5 ] =
_cg_const_2 [ 5 ] ; out -> mTDXF_P . mIr [ 6 ] = _cg_const_2 [ 6 ] ; out ->
mTDXF_P . mIr [ 7 ] = _cg_const_2 [ 7 ] ; out -> mTDXF_P . mIr [ 8 ] =
_cg_const_2 [ 8 ] ; out -> mTDXF_P . mIr [ 9 ] = _cg_const_2 [ 9 ] ; out ->
mTDXF_P . mIr [ 10 ] = _cg_const_2 [ 10 ] ; out -> mTDXF_P . mIr [ 11 ] =
_cg_const_2 [ 11 ] ; out -> mTDXF_P . mIr [ 12 ] = _cg_const_2 [ 12 ] ; out
-> mTDXF_P . mIr [ 13 ] = _cg_const_2 [ 13 ] ; out -> mTDXF_P . mIr [ 14 ] =
_cg_const_2 [ 14 ] ; out -> mTDXF_P . mIr [ 15 ] = _cg_const_2 [ 15 ] ; out
-> mTDXF_P . mIr [ 16 ] = _cg_const_2 [ 16 ] ; out -> mTDXF_P . mIr [ 17 ] =
_cg_const_2 [ 17 ] ; out -> mTDXF_P . mIr [ 18 ] = _cg_const_2 [ 18 ] ; out
-> mTDXF_P . mIr [ 19 ] = _cg_const_2 [ 19 ] ; out -> mTDXF_P . mIr [ 20 ] =
_cg_const_2 [ 20 ] ; out -> mTDXF_P . mIr [ 21 ] = _cg_const_2 [ 21 ] ; out
-> mTDXF_P . mIr [ 22 ] = _cg_const_2 [ 22 ] ; out -> mTDXF_P . mIr [ 23 ] =
_cg_const_2 [ 23 ] ; out -> mTDXF_P . mIr [ 24 ] = _cg_const_2 [ 24 ] ; out
-> mTDXF_P . mIr [ 25 ] = _cg_const_2 [ 25 ] ; out -> mTDXF_P . mIr [ 26 ] =
_cg_const_2 [ 26 ] ; out -> mTDXF_P . mIr [ 27 ] = _cg_const_2 [ 27 ] ; out
-> mTDXF_P . mIr [ 28 ] = _cg_const_2 [ 28 ] ; out -> mTDXF_P . mIr [ 29 ] =
_cg_const_2 [ 29 ] ; out -> mTDXF_P . mIr [ 30 ] = _cg_const_2 [ 30 ] ; out
-> mTDXF_P . mIr [ 31 ] = _cg_const_2 [ 31 ] ; out -> mTDXF_P . mIr [ 32 ] =
_cg_const_2 [ 32 ] ; out -> mTDXF_P . mIr [ 33 ] = _cg_const_2 [ 33 ] ; out
-> mTDXF_P . mIr [ 34 ] = _cg_const_2 [ 34 ] ; out -> mTDXF_P . mIr [ 35 ] =
_cg_const_2 [ 35 ] ; out -> mTDXF_P . mIr [ 36 ] = _cg_const_2 [ 36 ] ; out
-> mTDXF_P . mIr [ 37 ] = _cg_const_2 [ 37 ] ; out -> mTDXF_P . mIr [ 38 ] =
_cg_const_2 [ 38 ] ; out -> mTDXF_P . mIr [ 39 ] = _cg_const_2 [ 39 ] ; out
-> mTDXF_P . mIr [ 40 ] = _cg_const_2 [ 40 ] ; out -> mTDXF_P . mIr [ 41 ] =
_cg_const_2 [ 41 ] ; out -> mTDXF_P . mIr [ 42 ] = _cg_const_2 [ 42 ] ; out
-> mTDXF_P . mIr [ 43 ] = _cg_const_2 [ 43 ] ; out -> mTDXF_P . mIr [ 44 ] =
_cg_const_2 [ 44 ] ; out -> mTDXF_P . mIr [ 45 ] = _cg_const_2 [ 45 ] ; out
-> mTDXF_P . mIr [ 46 ] = _cg_const_2 [ 46 ] ; out -> mTDXF_P . mIr [ 47 ] =
_cg_const_2 [ 47 ] ; out -> mTDXF_P . mIr [ 48 ] = _cg_const_2 [ 48 ] ; out
-> mTDXF_P . mIr [ 49 ] = _cg_const_2 [ 49 ] ; out -> mTDXF_P . mIr [ 50 ] =
_cg_const_2 [ 50 ] ; out -> mTDXF_P . mIr [ 51 ] = _cg_const_2 [ 51 ] ; out
-> mTDXF_P . mIr [ 52 ] = _cg_const_2 [ 52 ] ; out -> mTDXF_P . mIr [ 53 ] =
_cg_const_2 [ 53 ] ; out -> mTDXF_P . mIr [ 54 ] = _cg_const_2 [ 54 ] ; out
-> mTDXF_P . mIr [ 55 ] = _cg_const_2 [ 55 ] ; out -> mTDXF_P . mIr [ 56 ] =
_cg_const_2 [ 56 ] ; out -> mTDXF_P . mIr [ 57 ] = _cg_const_2 [ 57 ] ; out
-> mTDXF_P . mIr [ 58 ] = _cg_const_2 [ 58 ] ; out -> mTDXF_P . mIr [ 59 ] =
_cg_const_2 [ 59 ] ; out -> mTDXF_P . mIr [ 60 ] = _cg_const_2 [ 60 ] ; ( void
) sys ; ( void ) out ; return 0 ; }
