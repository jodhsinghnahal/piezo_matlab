#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_f.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_f ( const NeDynamicSystem * sys , const
NeDynamicSystemInput * t8 , NeDsMethodOutput * out ) { real_T
Ideal_Semiconductor_Switch1_ideal_switch_v ; real_T
Subsystem2_P_SSHI_Resistor_i ; real_T Subsystem2_P_SSHI_Subsystem_Diode11_v ;
real_T Subsystem2_P_SSHI_Subsystem_Diode14_i ; real_T
Subsystem2_P_SSHI_Subsystem_Diode14_v ; real_T
Subsystem2_P_SSHI_Subsystem_Diode15_i ; real_T
Subsystem2_P_SSHI_Subsystem_Diode15_v ; real_T Subsystem2_P_SSHI_Switch_v ;
real_T t2 ; real_T t3 ; real_T t4 ; real_T t6 ; t6 = ( - t8 -> mX . mX [ 9UL
] + t8 -> mX . mX [ 10UL ] * 1.0E-9 ) + t8 -> mX . mX [ 1UL ] ; t4 = ( - t8
-> mX . mX [ 1UL ] + t8 -> mX . mX [ 10UL ] * - 1.0E-9 ) + t8 -> mX . mX [
9UL ] ; Ideal_Semiconductor_Switch1_ideal_switch_v = ( - t8 -> mX . mX [ 3UL
] + t8 -> mX . mX [ 9UL ] * - 1.0E-6 ) + t8 -> mX . mX [ 7UL ] ;
Subsystem2_P_SSHI_Resistor_i = t8 -> mX . mX [ 6UL ] * 1.0E-9 + t8 -> mX . mX
[ 0UL ] ; Subsystem2_P_SSHI_Subsystem_Diode11_v = ( ( - t8 -> mX . mX [ 2UL ]
+ t8 -> mX . mX [ 13UL ] * - 1.0E-6 ) - t8 -> mX . mX [ 7UL ] ) + t8 -> mX .
mX [ 11UL ] ; t2 = ( ( ( ( - t8 -> mX . mX [ 0UL ] + t8 -> mX . mX [ 6UL ] *
- 1.0E-9 ) - t8 -> mX . mX [ 9UL ] ) + t8 -> mX . mX [ 10UL ] * 1.0E-9 ) + t8
-> mX . mX [ 1UL ] ) + t8 -> mX . mX [ 12UL ] ; t3 = - t8 -> mX . mX [ 11UL ]
+ t8 -> mX . mX [ 7UL ] ; Subsystem2_P_SSHI_Subsystem_Diode14_i = ( ( ( ( ( ( t8
-> mX . mX [ 2UL ] * 1.0E-7 - t8 -> mX . mX [ 1UL ] ) + t8 -> mX . mX [ 13UL
] * 1.0000000000001 ) - t8 -> mX . mX [ 12UL ] ) + t8 -> mX . mX [ 6UL ] *
1.0E-9 ) + t8 -> mX . mX [ 10UL ] * - 1.0E-9 ) + t8 -> mX . mX [ 9UL ] ) + t8
-> mX . mX [ 0UL ] ; Subsystem2_P_SSHI_Subsystem_Diode14_v = - t8 -> mX . mX
[ 11UL ] + t8 -> mX . mX [ 8UL ] ; Subsystem2_P_SSHI_Subsystem_Diode15_i = ( t8
-> mX . mX [ 2UL ] * 1.0E-7 + t8 -> mX . mX [ 13UL ] * 1.0000000000001 ) - t8
-> mX . mX [ 12UL ] ; Subsystem2_P_SSHI_Subsystem_Diode15_v = ( ( - t8 -> mX
. mX [ 2UL ] - t8 -> mX . mX [ 8UL ] ) + t8 -> mX . mX [ 13UL ] * - 1.0E-6 )
+ t8 -> mX . mX [ 11UL ] ; Subsystem2_P_SSHI_Switch_v = - t8 -> mX . mX [ 7UL
] + t8 -> mX . mX [ 5UL ] ; if ( t8 -> mM . mX [ 0UL ] != 0 ) { out -> mF .
mX [ 5UL ] = Subsystem2_P_SSHI_Switch_v - Subsystem2_P_SSHI_Resistor_i * -
0.54 ; } else { out -> mF . mX [ 5UL ] = Subsystem2_P_SSHI_Switch_v * 1.0E-8
- ( - Subsystem2_P_SSHI_Resistor_i ) ; } if ( t8 -> mM . mX [ 1UL ] != 0 ) {
out -> mF . mX [ 7UL ] = t2 - t3 * 1.0E-8 ; } else { out -> mF . mX [ 7UL ] =
t3 - ( t2 * 0.3 + 0.4999999985 ) ; } if ( t8 -> mM . mX [ 2UL ] != 0 ) { out
-> mF . mX [ 8UL ] = Subsystem2_P_SSHI_Subsystem_Diode14_i -
Subsystem2_P_SSHI_Subsystem_Diode14_v * 1.0E-8 ; } else { out -> mF . mX [
8UL ] = Subsystem2_P_SSHI_Subsystem_Diode14_v - ( Subsystem2_P_SSHI_Subsystem_Diode14_i * 0.3 + 0.4999999985 ) ; } if ( t8 -> mM . mX [ 3UL ] != 0 ) { out -> mF . mX [ 9UL ] = Ideal_Semiconductor_Switch1_ideal_switch_v - t4 * 0.001 ; } else { out -> mF . mX [ 9UL ] = Ideal_Semiconductor_Switch1_ideal_switch_v * 1.0E-6 - t4 ; } if ( t8 -> mM . mX [ 4UL ] != 0 ) { out -> mF . mX [ 10UL ] = t8 -> mX . mX [ 12UL ] - Subsystem2_P_SSHI_Subsystem_Diode11_v * 1.0E-8 ; } else { out -> mF . mX [ 10UL ] = Subsystem2_P_SSHI_Subsystem_Diode11_v - ( t8 -> mX . mX [ 12UL ] * 0.3 + 0.4999999985 ) ; } if ( t8 -> mM . mX [ 3UL ] != 0 ) { out -> mF . mX [ 11UL ] = t8 -> mX . mX [ 8UL ] - t6 * 0.001 ; } else { out -> mF . mX [ 11UL ] = t8 -> mX . mX [ 8UL ] * 1.0E-6 - t6 ; } if ( t8 -> mM . mX [ 5UL ] != 0 ) { out -> mF . mX [ 12UL ] = Subsystem2_P_SSHI_Subsystem_Diode15_i - Subsystem2_P_SSHI_Subsystem_Diode15_v * 1.0E-8 ; } else { out -> mF . mX [ 12UL ] = Subsystem2_P_SSHI_Subsystem_Diode15_v - ( Subsystem2_P_SSHI_Subsystem_Diode15_i * 0.3 + 0.4999999985 ) ; } out -> mF . mX [ 0UL ] = - 0.0 ; out -> mF . mX [ 1UL ] = - 0.0 ; out -> mF . mX [ 2UL ] = - 0.0 ; out -> mF . mX [ 3UL ] = - 0.0 ; out -> mF . mX [ 4UL ] = - 0.0 ; out -> mF . mX [ 6UL ] = 0.0 ; out -> mF . mX [ 13UL ] = 0.0 ; ( void ) sys ; ( void ) out ; return 0 ; }
