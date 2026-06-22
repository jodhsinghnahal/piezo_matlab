#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_dxf.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_dxf ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t59 , NeDsMethodOutput * out ) { real_T t42 [ 4
] ; real_T t45 [ 4 ] ; real_T t47 [ 4 ] ; real_T t48 [ 4 ] ; real_T t49 [ 4 ]
; real_T t50 [ 4 ] ; real_T intermediate_der10 ; real_T intermediate_der30 ;
real_T t11 ; real_T t12 ; real_T t13 ; real_T t14 ; real_T t19 ; real_T t20 ;
real_T t21 ; real_T t38 ; real_T t39 ; real_T t7 ; real_T t8 ; real_T t9 ;
size_t t58 ; if ( t59 -> mM . mX [ 0UL ] != 0 ) { out -> mDXF . mX [ 0UL ] =
0.54 ; } else { out -> mDXF . mX [ 0UL ] = 1.0 ; } if ( t59 -> mM . mX [ 1UL
] != 0 ) { out -> mDXF . mX [ 1UL ] = - 1.0 ; } else { out -> mDXF . mX [ 1UL
] = 0.3 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { out -> mDXF . mX [ 2UL ] =
1.0 ; } else { out -> mDXF . mX [ 2UL ] = - 0.3 ; } if ( t59 -> mM . mX [ 1UL
] != 0 ) { t42 [ 0UL ] = 1.0 ; } else { t42 [ 0UL ] = - 0.3 ; } if ( t59 ->
mM . mX [ 2UL ] != 0 ) { t42 [ 1UL ] = - 1.0 ; } else { t42 [ 1UL ] = 0.3 ; }
if ( t59 -> mM . mX [ 3UL ] != 0 ) { t42 [ 2UL ] = 0.001 ; } else { t42 [ 2UL
] = 1.0 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t42 [ 3UL ] = - 0.001 ; }
else { t42 [ 3UL ] = - 1.0 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t7 =
1.0E-7 ; } else { t7 = - 3.0E-8 ; } if ( t59 -> mM . mX [ 4UL ] != 0 ) { t8 =
1.0E-8 ; } else { t8 = - 1.0 ; } if ( t59 -> mM . mX [ 5UL ] != 0 ) { t9 =
1.0999999999999999E-7 ; } else { t9 = - 1.00000003 ; } if ( t59 -> mM . mX [
3UL ] != 0 ) { intermediate_der30 = - 1.0 ; } else { intermediate_der30 = -
1.0E-6 ; } if ( t59 -> mM . mX [ 0UL ] != 0 ) { t11 = 1.0 ; } else { t11 =
1.0E-8 ; } if ( t59 -> mM . mX [ 0UL ] != 0 ) { t12 = 5.400000000000001E-10 ;
} else { t12 = 1.0E-9 ; } if ( t59 -> mM . mX [ 1UL ] != 0 ) { t13 = - 1.0E-9
; } else { t13 = 3.0E-10 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t14 =
1.0E-9 ; } else { t14 = - 3.0E-10 ; } if ( t59 -> mM . mX [ 0UL ] != 0 ) {
t45 [ 0UL ] = - 1.0 ; } else { t45 [ 0UL ] = - 1.0E-8 ; } if ( t59 -> mM . mX
[ 1UL ] != 0 ) { t45 [ 1UL ] = - 1.0E-8 ; } else { t45 [ 1UL ] = 1.0 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t45 [ 2UL ] = 1.0 ; } else { t45 [ 2UL ] = 1.0E-6 ; } if ( t59 -> mM . mX [ 4UL ] != 0 ) { t45 [ 3UL ] = 1.0E-8 ; } else { t45 [ 3UL ] = - 1.0 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t19 = - 1.0E-8 ; } else { t19 = 1.0 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t20 = 1.0 ; } else { t20 = 1.0E-6 ; } if ( t59 -> mM . mX [ 5UL ] != 0 ) { t21 = 1.0E-8 ; } else { t21 = - 1.0 ; } if ( t59 -> mM . mX [ 1UL ] != 0 ) { t47 [ 0UL ] = - 1.0 ; } else { t47 [ 0UL ] = 0.3 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t47 [ 1UL ] = 1.0 ; } else { t47 [ 1UL ] = - 0.3 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t47 [ 2UL ] = - 0.001001 ; } else { t47 [ 2UL ] = - 1.000000000001 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t47 [ 3UL ] = 0.001 ; } else { t47 [ 3UL ] = 1.0 ; } if ( t59 -> mM . mX [ 1UL ] != 0 ) { t48 [ 0UL ] = 1.0E-9 ; } else { t48 [ 0UL ] = - 3.0E-10 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t48 [ 1UL ] = - 1.0E-9 ; } else { t48 [ 1UL ] = 3.0E-10 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t48 [ 2UL ] = 1.0000000000000002E-12 ; } else { t48 [ 2UL ] = 1.0E-9 ; } if ( t59 -> mM . mX [ 3UL ] != 0 ) { t48 [ 3UL ] = - 1.0000000000000002E-12 ; } else { t48 [ 3UL ] = - 1.0E-9 ; } if ( t59 -> mM . mX [ 1UL ] != 0 ) { t49 [ 0UL ] = 1.0E-8 ; } else { t49 [ 0UL ] = - 1.0 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t49 [ 1UL ] = 1.0E-8 ; } else { t49 [ 1UL ] = - 1.0 ; } if ( t59 -> mM . mX [ 4UL ] != 0 ) { t49 [ 2UL ] = - 1.0E-8 ; } else { t49 [ 2UL ] = 1.0 ; } if ( t59 -> mM . mX [ 5UL ] != 0 ) { t49 [ 3UL ] = - 1.0E-8 ; } else { t49 [ 3UL ] = 1.0 ; } if ( t59 -> mM . mX [ 1UL ] != 0 ) { t50 [ 0UL ] = 1.0 ; } else { t50 [ 0UL ] = - 0.3 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { t50 [ 1UL ] = - 1.0 ; } else { t50 [ 1UL ] = 0.3 ; } if ( t59 -> mM . mX [ 5UL ] != 0 ) { t50 [ 3UL ] = - 1.0 ; } else { t50 [ 3UL ] = 0.3 ; } if ( t59 -> mM . mX [ 2UL ] != 0 ) { intermediate_der10 = 1.0000000000001 ; } else { intermediate_der10 = - 0.30000000000002996 ; } if ( t59 -> mM . mX [ 4UL ] != 0 ) { t38 = 1.0E-14 ; } else { t38 = - 1.0E-6 ; } if ( t59 -> mM . mX [ 5UL ] != 0 ) { t39 = 1.00000000000011 ; } else { t39 = - 0.30000100000002994 ; } t50 [ 2UL ] = t59 -> mM . mX [ 4UL ] != 0 ? 1.0 : - 0.3 ; for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 3UL ] = t42 [ t58 ] ; } out -> mDXF . mX [ 7UL ] = t7 ; out -> mDXF . mX [ 8UL ] = t8 ; out -> mDXF . mX [ 9UL ] = t9 ; out -> mDXF . mX [ 10UL ] = intermediate_der30 ; out -> mDXF . mX [ 11UL ] = t11 ; out -> mDXF . mX [ 12UL ] = t12 ; out -> mDXF . mX [ 13UL ] = t13 ; out -> mDXF . mX [ 14UL ] = t14 ; for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 15UL ] = t45 [ t58 ] ; } out -> mDXF . mX [ 19UL ] = t19 ; out -> mDXF . mX [ 20UL ] = t20 ; out -> mDXF . mX [ 21UL ] = t21 ; for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 22UL ] = t47 [ t58 ] ; } for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 26UL ] = t48 [ t58 ] ; } for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 30UL ] = t49 [ t58 ] ; } for ( t58 = 0UL ; t58 < 4UL ; t58 ++ ) { out -> mDXF . mX [ t58 + 34UL ] = t50 [ t58 ] ; } out -> mDXF . mX [ 38UL ] = intermediate_der10 ; out -> mDXF . mX [ 39UL ] = t38 ; out -> mDXF . mX [ 40UL ] = t39 ; ( void ) sys ; ( void ) out ; return 0 ; }
