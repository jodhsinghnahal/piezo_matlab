#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_mode.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_mode ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { out -> mMODE .
mX [ 0UL ] = ( int32_T ) ( t1 -> mU . mX [ 2UL ] > 0.5 ) ; out -> mMODE . mX
[ 1UL ] = ( int32_T ) ( ( ( ( ( ( - t1 -> mX . mX [ 0UL ] + t1 -> mX . mX [
6UL ] * - 1.0E-9 ) - t1 -> mX . mX [ 9UL ] ) + t1 -> mX . mX [ 10UL ] *
1.0E-9 ) + t1 -> mX . mX [ 1UL ] ) + t1 -> mX . mX [ 12UL ] ) + ( - t1 -> mX
. mX [ 11UL ] + t1 -> mX . mX [ 7UL ] ) < 0.500000005 ) ; out -> mMODE . mX [
2UL ] = ( int32_T ) ( ( ( ( ( ( ( ( t1 -> mX . mX [ 2UL ] * 1.0E-7 - t1 -> mX
. mX [ 1UL ] ) + t1 -> mX . mX [ 13UL ] * 1.0000000000001 ) - t1 -> mX . mX [
12UL ] ) + t1 -> mX . mX [ 6UL ] * 1.0E-9 ) + t1 -> mX . mX [ 10UL ] * -
1.0E-9 ) + t1 -> mX . mX [ 9UL ] ) + t1 -> mX . mX [ 0UL ] ) + ( - t1 -> mX .
mX [ 11UL ] + t1 -> mX . mX [ 8UL ] ) < 0.500000005 ) ; out -> mMODE . mX [
3UL ] = ( int32_T ) ( t1 -> mU . mX [ 1UL ] > 0.5 ) ; out -> mMODE . mX [ 4UL
] = ( int32_T ) ( t1 -> mX . mX [ 12UL ] + ( ( ( - t1 -> mX . mX [ 2UL ] + t1
-> mX . mX [ 13UL ] * - 1.0E-6 ) - t1 -> mX . mX [ 7UL ] ) + t1 -> mX . mX [
11UL ] ) < 0.500000005 ) ; out -> mMODE . mX [ 5UL ] = ( int32_T ) ( ( ( t1
-> mX . mX [ 2UL ] * 1.0E-7 + t1 -> mX . mX [ 13UL ] * 1.0000000000001 ) - t1
-> mX . mX [ 12UL ] ) + ( ( ( - t1 -> mX . mX [ 2UL ] - t1 -> mX . mX [ 8UL ]
) + t1 -> mX . mX [ 13UL ] * - 1.0E-6 ) + t1 -> mX . mX [ 11UL ] ) <
0.500000005 ) ; ( void ) sys ; ( void ) out ; return 0 ; }
