#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_obs_all.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_obs_all ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t3 , NeDsMethodOutput * out ) { real_T
Capacitor2_v ; real_T Capacitor_p_v ; real_T Current_Sensor1_i1 ; real_T
Ideal_Semiconductor_Switch1_ideal_switch_i ; real_T
Ideal_Semiconductor_Switch1_ideal_switch_v ; real_T
Ideal_Semiconductor_Switch_ideal_switch_i ; real_T Resistor_p_v ; real_T
Subsystem2_P_SSHI_Current_Sensor3_i1 ; real_T Subsystem2_P_SSHI_Resistor_i ;
real_T Subsystem2_P_SSHI_Resistor_p_v ; real_T Subsystem2_P_SSHI_Rload1_i ;
real_T Subsystem2_P_SSHI_Vload1_V ; real_T Subsystem2_P_SSHI_Vload1_n_v ;
Capacitor_p_v = ( ( ( t3 -> mX . mX [ 1UL ] * 1.0E-6 + t3 -> mX . mX [ 9UL ]
* 1.0E-6 ) + t3 -> mX . mX [ 10UL ] * 1.0E-15 ) + t3 -> mX . mX [ 4UL ] ) +
t3 -> mX . mX [ 3UL ] ; Current_Sensor1_i1 = t3 -> mX . mX [ 10UL ] * 1.0E-9
+ t3 -> mX . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 3UL ] = ( t3 -> mX . mX [
1UL ] * 1.0E-6 + t3 -> mX . mX [ 10UL ] * 1.0E-15 ) + t3 -> mX . mX [ 4UL ] ;
Capacitor2_v = t3 -> mX . mX [ 9UL ] * 1.0E-6 + t3 -> mX . mX [ 3UL ] ;
Ideal_Semiconductor_Switch_ideal_switch_i = ( - t3 -> mX . mX [ 9UL ] + t3 ->
mX . mX [ 10UL ] * 1.0E-9 ) + t3 -> mX . mX [ 1UL ] ;
Ideal_Semiconductor_Switch1_ideal_switch_i = ( - t3 -> mX . mX [ 1UL ] + t3
-> mX . mX [ 10UL ] * - 1.0E-9 ) + t3 -> mX . mX [ 9UL ] ;
Ideal_Semiconductor_Switch1_ideal_switch_v = ( - t3 -> mX . mX [ 3UL ] + t3
-> mX . mX [ 9UL ] * - 1.0E-6 ) + t3 -> mX . mX [ 7UL ] ; Resistor_p_v = - t3
-> mX . mX [ 10UL ] + t3 -> mU . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 70UL ] =
t3 -> mX . mX [ 13UL ] * 1.0E-6 + t3 -> mX . mX [ 2UL ] ;
Subsystem2_P_SSHI_Current_Sensor3_i1 = t3 -> mX . mX [ 2UL ] * 1.0E-6 + t3 ->
mX . mX [ 13UL ] * 1.000000000001 ; Subsystem2_P_SSHI_Resistor_i = t3 -> mX .
mX [ 6UL ] * 1.0E-9 + t3 -> mX . mX [ 0UL ] ; Subsystem2_P_SSHI_Resistor_p_v
= - t3 -> mX . mX [ 6UL ] + t3 -> mX . mX [ 5UL ] ;
Subsystem2_P_SSHI_Rload1_i = t3 -> mX . mX [ 2UL ] * 1.0E-6 + t3 -> mX . mX [
13UL ] * 1.0E-12 ; out -> mOBS_ALL . mX [ 101UL ] = ( ( - t3 -> mX . mX [ 2UL
] + t3 -> mX . mX [ 13UL ] * - 1.0E-6 ) - t3 -> mX . mX [ 7UL ] ) + t3 -> mX
. mX [ 11UL ] ; out -> mOBS_ALL . mX [ 102UL ] = ( ( ( ( - t3 -> mX . mX [
0UL ] + t3 -> mX . mX [ 6UL ] * - 1.0E-9 ) - t3 -> mX . mX [ 9UL ] ) + t3 ->
mX . mX [ 10UL ] * 1.0E-9 ) + t3 -> mX . mX [ 1UL ] ) + t3 -> mX . mX [ 12UL
] ; out -> mOBS_ALL . mX [ 105UL ] = - t3 -> mX . mX [ 11UL ] + t3 -> mX . mX
[ 7UL ] ; out -> mOBS_ALL . mX [ 106UL ] = ( ( ( ( ( ( t3 -> mX . mX [ 2UL ]
* 1.0E-6 - t3 -> mX . mX [ 1UL ] ) + t3 -> mX . mX [ 13UL ] * 1.000000000001
) - t3 -> mX . mX [ 12UL ] ) + t3 -> mX . mX [ 6UL ] * 1.0E-9 ) + t3 -> mX .
mX [ 10UL ] * - 1.0E-9 ) + t3 -> mX . mX [ 9UL ] ) + t3 -> mX . mX [ 0UL ] ;
out -> mOBS_ALL . mX [ 109UL ] = - t3 -> mX . mX [ 11UL ] + t3 -> mX . mX [
8UL ] ; out -> mOBS_ALL . mX [ 110UL ] = ( t3 -> mX . mX [ 2UL ] * 1.0E-6 +
t3 -> mX . mX [ 13UL ] * 1.000000000001 ) - t3 -> mX . mX [ 12UL ] ; out ->
mOBS_ALL . mX [ 113UL ] = ( ( - t3 -> mX . mX [ 2UL ] - t3 -> mX . mX [ 8UL ]
) + t3 -> mX . mX [ 13UL ] * - 1.0E-6 ) + t3 -> mX . mX [ 11UL ] ; out ->
mOBS_ALL . mX [ 117UL ] = - t3 -> mX . mX [ 7UL ] + t3 -> mX . mX [ 5UL ] ;
Subsystem2_P_SSHI_Vload1_n_v = ( - t3 -> mX . mX [ 2UL ] + t3 -> mX . mX [
13UL ] * - 1.0E-6 ) + t3 -> mX . mX [ 11UL ] ; Subsystem2_P_SSHI_Vload1_V =
t3 -> mX . mX [ 11UL ] - Subsystem2_P_SSHI_Vload1_n_v ; out -> mOBS_ALL . mX
[ 0UL ] = Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 1UL ] = Capacitor2_v ;
out -> mOBS_ALL . mX [ 2UL ] = Capacitor_p_v ; out -> mOBS_ALL . mX [ 4UL ] =
t3 -> mX . mX [ 4UL ] ; out -> mOBS_ALL . mX [ 5UL ] = t3 -> mX . mX [ 9UL ]
; out -> mOBS_ALL . mX [ 6UL ] = 0.0 ; out -> mOBS_ALL . mX [ 7UL ] =
Capacitor2_v ; out -> mOBS_ALL . mX [ 8UL ] = Capacitor2_v ; out -> mOBS_ALL
. mX [ 9UL ] = t3 -> mX . mX [ 3UL ] ; out -> mOBS_ALL . mX [ 10UL ] = -
Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 11UL ] = 0.0 ; out -> mOBS_ALL .
mX [ 12UL ] = t3 -> mU . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 13UL ] = t3 ->
mU . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 14UL ] = t3 -> mU . mX [ 0UL ] ; out
-> mOBS_ALL . mX [ 15UL ] = Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 16UL
] = Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 17UL ] = Capacitor2_v ; out
-> mOBS_ALL . mX [ 18UL ] = Capacitor2_v ; out -> mOBS_ALL . mX [ 19UL ] =
Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 20UL ] = -
Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mOBS_ALL . mX [ 21UL ] =
- Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mOBS_ALL . mX [ 22UL ]
= Capacitor2_v ; out -> mOBS_ALL . mX [ 23UL ] = Capacitor2_v ; out ->
mOBS_ALL . mX [ 24UL ] = - Ideal_Semiconductor_Switch1_ideal_switch_i ; out
-> mOBS_ALL . mX [ 25UL ] = 0.0 ; out -> mOBS_ALL . mX [ 26UL ] = t3 -> mX .
mX [ 8UL ] ; out -> mOBS_ALL . mX [ 27UL ] = t3 -> mU . mX [ 1UL ] ; out ->
mOBS_ALL . mX [ 28UL ] = 0.0 ; out -> mOBS_ALL . mX [ 29UL ] = 0.0 ; out ->
mOBS_ALL . mX [ 30UL ] = Ideal_Semiconductor_Switch_ideal_switch_i ; out ->
mOBS_ALL . mX [ 31UL ] = Ideal_Semiconductor_Switch_ideal_switch_i ; out ->
mOBS_ALL . mX [ 32UL ] = 0.0 ; out -> mOBS_ALL . mX [ 33UL ] = t3 -> mX . mX
[ 8UL ] ; out -> mOBS_ALL . mX [ 34UL ] = t3 -> mX . mX [ 8UL ] ; out ->
mOBS_ALL . mX [ 35UL ] = t3 -> mU . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 36UL
] = t3 -> mX . mX [ 8UL ] ; out -> mOBS_ALL . mX [ 37UL ] = t3 -> mU . mX [
1UL ] ; out -> mOBS_ALL . mX [ 38UL ] = t3 -> mX . mX [ 7UL ] ; out ->
mOBS_ALL . mX [ 39UL ] = t3 -> mU . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 40UL
] = 0.0 ; out -> mOBS_ALL . mX [ 41UL ] = Capacitor2_v ; out -> mOBS_ALL . mX
[ 42UL ] = Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mOBS_ALL . mX
[ 43UL ] = Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mOBS_ALL . mX
[ 44UL ] = Capacitor2_v ; out -> mOBS_ALL . mX [ 45UL ] = t3 -> mX . mX [ 7UL
] ; out -> mOBS_ALL . mX [ 46UL ] =
Ideal_Semiconductor_Switch1_ideal_switch_v ; out -> mOBS_ALL . mX [ 47UL ] =
t3 -> mU . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 48UL ] =
Ideal_Semiconductor_Switch1_ideal_switch_v ; out -> mOBS_ALL . mX [ 49UL ] =
t3 -> mU . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 50UL ] = 0.0 ; out -> mOBS_ALL
. mX [ 51UL ] = 0.0 ; out -> mOBS_ALL . mX [ 52UL ] = Resistor_p_v ; out ->
mOBS_ALL . mX [ 53UL ] = t3 -> mU . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 54UL
] = t3 -> mX . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 55UL ] =
Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 56UL ] = t3 -> mX . mX [ 10UL ] ;
out -> mOBS_ALL . mX [ 57UL ] = Current_Sensor1_i1 ; out -> mOBS_ALL . mX [
58UL ] = Capacitor_p_v ; out -> mOBS_ALL . mX [ 59UL ] = Resistor_p_v ; out
-> mOBS_ALL . mX [ 60UL ] = Current_Sensor1_i1 * 1.0E+6 ; out -> mOBS_ALL .
mX [ 61UL ] = t3 -> mU . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 62UL ] = t3 ->
mU . mX [ 1UL ] ; out -> mOBS_ALL . mX [ 63UL ] = t3 -> mX . mX [ 7UL ] ; out
-> mOBS_ALL . mX [ 64UL ] = t3 -> mX . mX [ 8UL ] ; out -> mOBS_ALL . mX [
65UL ] = t3 -> mX . mX [ 7UL ] ; out -> mOBS_ALL . mX [ 66UL ] = t3 -> mX .
mX [ 8UL ] ; out -> mOBS_ALL . mX [ 67UL ] = t3 -> mX . mX [ 13UL ] ; out ->
mOBS_ALL . mX [ 68UL ] = Subsystem2_P_SSHI_Vload1_n_v ; out -> mOBS_ALL . mX
[ 69UL ] = t3 -> mX . mX [ 11UL ] ; out -> mOBS_ALL . mX [ 71UL ] = t3 -> mX
. mX [ 2UL ] ; out -> mOBS_ALL . mX [ 72UL ] =
Subsystem2_P_SSHI_Current_Sensor3_i1 ; out -> mOBS_ALL . mX [ 73UL ] =
Subsystem2_P_SSHI_Current_Sensor3_i1 ; out -> mOBS_ALL . mX [ 74UL ] = t3 ->
mX . mX [ 11UL ] ; out -> mOBS_ALL . mX [ 75UL ] = t3 -> mX . mX [ 11UL ] ;
out -> mOBS_ALL . mX [ 76UL ] = Subsystem2_P_SSHI_Current_Sensor3_i1 ; out ->
mOBS_ALL . mX [ 77UL ] = 0.0 ; out -> mOBS_ALL . mX [ 78UL ] = 0.0 ; out ->
mOBS_ALL . mX [ 79UL ] = Subsystem2_P_SSHI_Resistor_p_v ; out -> mOBS_ALL .
mX [ 80UL ] = t3 -> mX . mX [ 5UL ] ; out -> mOBS_ALL . mX [ 81UL ] = t3 ->
mX . mX [ 0UL ] ; out -> mOBS_ALL . mX [ 82UL ] =
Subsystem2_P_SSHI_Resistor_i ; out -> mOBS_ALL . mX [ 83UL ] = t3 -> mX . mX
[ 6UL ] ; out -> mOBS_ALL . mX [ 84UL ] = Current_Sensor1_i1 ; out ->
mOBS_ALL . mX [ 85UL ] = Subsystem2_P_SSHI_Resistor_i ; out -> mOBS_ALL . mX
[ 86UL ] = t3 -> mX . mX [ 8UL ] ; out -> mOBS_ALL . mX [ 87UL ] =
Subsystem2_P_SSHI_Resistor_p_v ; out -> mOBS_ALL . mX [ 88UL ] =
Subsystem2_P_SSHI_Resistor_i * 263.76142439263435 ; out -> mOBS_ALL . mX [
89UL ] = Subsystem2_P_SSHI_Rload1_i ; out -> mOBS_ALL . mX [ 90UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mOBS_ALL . mX [ 91UL ] = t3 -> mX . mX
[ 11UL ] ; out -> mOBS_ALL . mX [ 92UL ] = Subsystem2_P_SSHI_Rload1_i *
1.0E+6 ; out -> mOBS_ALL . mX [ 93UL ] = t3 -> mU . mX [ 2UL ] ; out ->
mOBS_ALL . mX [ 94UL ] = t3 -> mX . mX [ 11UL ] ; out -> mOBS_ALL . mX [ 95UL
] = t3 -> mX . mX [ 7UL ] ; out -> mOBS_ALL . mX [ 96UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mOBS_ALL . mX [ 97UL ] = t3 -> mX . mX
[ 8UL ] ; out -> mOBS_ALL . mX [ 98UL ] = t3 -> mX . mX [ 12UL ] ; out ->
mOBS_ALL . mX [ 99UL ] = t3 -> mX . mX [ 7UL ] ; out -> mOBS_ALL . mX [ 100UL
] = Subsystem2_P_SSHI_Vload1_n_v ; out -> mOBS_ALL . mX [ 103UL ] = t3 -> mX
. mX [ 11UL ] ; out -> mOBS_ALL . mX [ 104UL ] = t3 -> mX . mX [ 7UL ] ; out
-> mOBS_ALL . mX [ 107UL ] = t3 -> mX . mX [ 11UL ] ; out -> mOBS_ALL . mX [
108UL ] = t3 -> mX . mX [ 8UL ] ; out -> mOBS_ALL . mX [ 111UL ] = t3 -> mX .
mX [ 8UL ] ; out -> mOBS_ALL . mX [ 112UL ] = Subsystem2_P_SSHI_Vload1_n_v ;
out -> mOBS_ALL . mX [ 114UL ] = - Subsystem2_P_SSHI_Resistor_i ; out ->
mOBS_ALL . mX [ 115UL ] = t3 -> mX . mX [ 7UL ] ; out -> mOBS_ALL . mX [
116UL ] = t3 -> mX . mX [ 5UL ] ; out -> mOBS_ALL . mX [ 118UL ] = t3 -> mU .
mX [ 2UL ] ; out -> mOBS_ALL . mX [ 119UL ] = Subsystem2_P_SSHI_Vload1_V ;
out -> mOBS_ALL . mX [ 120UL ] = Subsystem2_P_SSHI_Vload1_n_v ; out ->
mOBS_ALL . mX [ 121UL ] = t3 -> mX . mX [ 11UL ] ; out -> mOBS_ALL . mX [
122UL ] = Subsystem2_P_SSHI_Vload1_V ; out -> mOBS_ALL . mX [ 123UL ] =
Current_Sensor1_i1 ; out -> mOBS_ALL . mX [ 124UL ] = Current_Sensor1_i1 ;
out -> mOBS_ALL . mX [ 125UL ] = Capacitor2_v ; out -> mOBS_ALL . mX [ 126UL
] = 0.0 ; out -> mOBS_ALL . mX [ 127UL ] = Capacitor2_v ; out -> mOBS_ALL .
mX [ 128UL ] = Capacitor2_v ; ( void ) sys ; ( void ) out ; return 0 ; }
