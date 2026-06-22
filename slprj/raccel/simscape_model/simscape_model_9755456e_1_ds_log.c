#include "ne_ds.h"
#include "simscape_model_9755456e_1_ds_sys_struct.h"
#include "simscape_model_9755456e_1_ds_log.h"
#include "simscape_model_9755456e_1_ds.h"
#include "simscape_model_9755456e_1_ds_externals.h"
#include "simscape_model_9755456e_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T simscape_model_9755456e_1_ds_log ( const NeDynamicSystem * sys ,
const NeDynamicSystemInput * t3 , NeDsMethodOutput * out ) { real_T
Capacitor2_v ; real_T Capacitor_p_v ; real_T Current_Sensor1_i1 ; real_T
Ideal_Semiconductor_Switch1_ideal_switch_i ; real_T
Ideal_Semiconductor_Switch1_ideal_switch_v ; real_T
Ideal_Semiconductor_Switch_ideal_switch_i ; real_T
Inductor1_xpowerExternalThermal ; real_T Resistor_p_v ; real_T
Subsystem2_P_SSHI_Current_Sensor3_i1 ; real_T
Subsystem2_P_SSHI_Inductor2_xpowerExternalThermal ; real_T
Subsystem2_P_SSHI_Resistor1_i ; real_T Subsystem2_P_SSHI_Resistor_i ; real_T
Subsystem2_P_SSHI_Resistor_p_v ; real_T Subsystem2_P_SSHI_Subsystem_Diode11_v
; real_T Subsystem2_P_SSHI_Subsystem_Diode13_i ; real_T
Subsystem2_P_SSHI_Subsystem_Diode13_v ; real_T
Subsystem2_P_SSHI_Subsystem_Diode14_i ; real_T
Subsystem2_P_SSHI_Subsystem_Diode14_v ; real_T
Subsystem2_P_SSHI_Subsystem_Diode15_i ; real_T
Subsystem2_P_SSHI_Subsystem_Diode15_v ; real_T Subsystem2_P_SSHI_Switch_v ;
real_T Subsystem2_P_SSHI_Vload1_V ; real_T Subsystem2_P_SSHI_Vload1_n_v ;
Capacitor_p_v = ( ( ( t3 -> mX . mX [ 1UL ] * 1.0E-6 + t3 -> mX . mX [ 9UL ]
* 1.0E-6 ) + t3 -> mX . mX [ 10UL ] * 1.0E-15 ) + t3 -> mX . mX [ 4UL ] ) +
t3 -> mX . mX [ 3UL ] ; Current_Sensor1_i1 = t3 -> mX . mX [ 10UL ] * 1.0E-9
+ t3 -> mX . mX [ 1UL ] ; out -> mLOG . mX [ 3UL ] = ( t3 -> mX . mX [ 1UL ]
* 1.0E-6 + t3 -> mX . mX [ 10UL ] * 1.0E-15 ) + t3 -> mX . mX [ 4UL ] ;
Capacitor2_v = t3 -> mX . mX [ 9UL ] * 1.0E-6 + t3 -> mX . mX [ 3UL ] ;
Ideal_Semiconductor_Switch_ideal_switch_i = ( - t3 -> mX . mX [ 9UL ] + t3 ->
mX . mX [ 10UL ] * 1.0E-9 ) + t3 -> mX . mX [ 1UL ] ;
Ideal_Semiconductor_Switch1_ideal_switch_i = ( - t3 -> mX . mX [ 1UL ] + t3
-> mX . mX [ 10UL ] * - 1.0E-9 ) + t3 -> mX . mX [ 9UL ] ;
Ideal_Semiconductor_Switch1_ideal_switch_v = ( - t3 -> mX . mX [ 3UL ] + t3
-> mX . mX [ 9UL ] * - 1.0E-6 ) + t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [
50UL ] = t3 -> mX . mX [ 1UL ] * t3 -> mX . mX [ 1UL ] * 15500.0 ;
Inductor1_xpowerExternalThermal = - ( t3 -> mX . mX [ 10UL ] * t3 -> mX . mX
[ 10UL ] * 1.0000000000000002E-12 ) ; Resistor_p_v = - t3 -> mX . mX [ 10UL ]
+ t3 -> mU . mX [ 0UL ] ; out -> mLOG . mX [ 69UL ] = t3 -> mX . mX [ 13UL ]
* 1.0E-6 + t3 -> mX . mX [ 2UL ] ; Subsystem2_P_SSHI_Current_Sensor3_i1 = t3
-> mX . mX [ 2UL ] * 1.0E-7 + t3 -> mX . mX [ 13UL ] * 1.0000000000001 ; out
-> mLOG . mX [ 80UL ] = t3 -> mX . mX [ 0UL ] * t3 -> mX . mX [ 0UL ] *
0.0235 ; Subsystem2_P_SSHI_Inductor2_xpowerExternalThermal = - ( t3 -> mX .
mX [ 6UL ] * t3 -> mX . mX [ 6UL ] * 1.0000000000000002E-12 ) ;
Subsystem2_P_SSHI_Resistor_i = t3 -> mX . mX [ 6UL ] * 1.0E-9 + t3 -> mX . mX
[ 0UL ] ; Subsystem2_P_SSHI_Resistor_p_v = - t3 -> mX . mX [ 6UL ] + t3 -> mX
. mX [ 5UL ] ; Subsystem2_P_SSHI_Resistor1_i = t3 -> mX . mX [ 2UL ] * 1.0E-7
+ t3 -> mX . mX [ 13UL ] * 9.999999999999999E-14 ;
Subsystem2_P_SSHI_Subsystem_Diode11_v = ( ( - t3 -> mX . mX [ 2UL ] + t3 ->
mX . mX [ 13UL ] * - 1.0E-6 ) - t3 -> mX . mX [ 7UL ] ) + t3 -> mX . mX [
11UL ] ; Subsystem2_P_SSHI_Subsystem_Diode13_i = ( ( ( ( - t3 -> mX . mX [
0UL ] + t3 -> mX . mX [ 6UL ] * - 1.0E-9 ) - t3 -> mX . mX [ 9UL ] ) + t3 ->
mX . mX [ 10UL ] * 1.0E-9 ) + t3 -> mX . mX [ 1UL ] ) + t3 -> mX . mX [ 12UL
] ; Subsystem2_P_SSHI_Subsystem_Diode13_v = - t3 -> mX . mX [ 11UL ] + t3 ->
mX . mX [ 7UL ] ; Subsystem2_P_SSHI_Subsystem_Diode14_i = ( ( ( ( ( ( t3 ->
mX . mX [ 2UL ] * 1.0E-7 - t3 -> mX . mX [ 1UL ] ) + t3 -> mX . mX [ 13UL ] *
1.0000000000001 ) - t3 -> mX . mX [ 12UL ] ) + t3 -> mX . mX [ 6UL ] * 1.0E-9
) + t3 -> mX . mX [ 10UL ] * - 1.0E-9 ) + t3 -> mX . mX [ 9UL ] ) + t3 -> mX
. mX [ 0UL ] ; Subsystem2_P_SSHI_Subsystem_Diode14_v = - t3 -> mX . mX [ 11UL
] + t3 -> mX . mX [ 8UL ] ; Subsystem2_P_SSHI_Subsystem_Diode15_i = ( t3 ->
mX . mX [ 2UL ] * 1.0E-7 + t3 -> mX . mX [ 13UL ] * 1.0000000000001 ) - t3 ->
mX . mX [ 12UL ] ; Subsystem2_P_SSHI_Subsystem_Diode15_v = ( ( - t3 -> mX .
mX [ 2UL ] - t3 -> mX . mX [ 8UL ] ) + t3 -> mX . mX [ 13UL ] * - 1.0E-6 ) +
t3 -> mX . mX [ 11UL ] ; Subsystem2_P_SSHI_Switch_v = - t3 -> mX . mX [ 7UL ]
+ t3 -> mX . mX [ 5UL ] ; Subsystem2_P_SSHI_Vload1_n_v = ( - t3 -> mX . mX [
2UL ] + t3 -> mX . mX [ 13UL ] * - 1.0E-6 ) + t3 -> mX . mX [ 11UL ] ;
Subsystem2_P_SSHI_Vload1_V = t3 -> mX . mX [ 11UL ] -
Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 0UL ] = Current_Sensor1_i1
; out -> mLOG . mX [ 1UL ] = Capacitor2_v ; out -> mLOG . mX [ 2UL ] =
Capacitor_p_v ; out -> mLOG . mX [ 4UL ] = t3 -> mX . mX [ 4UL ] ; out ->
mLOG . mX [ 5UL ] = - ( Current_Sensor1_i1 * Current_Sensor1_i1 * - 1.0E-9 )
; out -> mLOG . mX [ 6UL ] = t3 -> mX . mX [ 9UL ] ; out -> mLOG . mX [ 7UL ]
= Capacitor2_v ; out -> mLOG . mX [ 8UL ] = Capacitor2_v ; out -> mLOG . mX [
9UL ] = t3 -> mX . mX [ 3UL ] ; out -> mLOG . mX [ 10UL ] = - ( t3 -> mX . mX
[ 9UL ] * t3 -> mX . mX [ 9UL ] * - 1.0E-9 ) ; out -> mLOG . mX [ 11UL ] = -
Current_Sensor1_i1 ; out -> mLOG . mX [ 12UL ] = t3 -> mU . mX [ 0UL ] ; out
-> mLOG . mX [ 13UL ] = t3 -> mU . mX [ 0UL ] ; out -> mLOG . mX [ 14UL ] =
t3 -> mU . mX [ 0UL ] ; out -> mLOG . mX [ 15UL ] = Current_Sensor1_i1 ; out
-> mLOG . mX [ 16UL ] = Current_Sensor1_i1 ; out -> mLOG . mX [ 17UL ] =
Capacitor2_v ; out -> mLOG . mX [ 18UL ] = Capacitor2_v ; out -> mLOG . mX [
19UL ] = Current_Sensor1_i1 ; out -> mLOG . mX [ 20UL ] = -
Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mLOG . mX [ 21UL ] = -
Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mLOG . mX [ 22UL ] =
Capacitor2_v ; out -> mLOG . mX [ 23UL ] = Capacitor2_v ; out -> mLOG . mX [
24UL ] = - Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mLOG . mX [
25UL ] = t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 26UL ] = t3 -> mU . mX [
1UL ] ; out -> mLOG . mX [ 27UL ] = Ideal_Semiconductor_Switch_ideal_switch_i
; out -> mLOG . mX [ 28UL ] = Ideal_Semiconductor_Switch_ideal_switch_i ; out
-> mLOG . mX [ 29UL ] = t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 30UL ] =
t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 31UL ] = - ( - t3 -> mX . mX [ 8UL
] * Ideal_Semiconductor_Switch_ideal_switch_i ) ; out -> mLOG . mX [ 32UL ] =
t3 -> mU . mX [ 1UL ] ; out -> mLOG . mX [ 33UL ] = t3 -> mX . mX [ 8UL ] ;
out -> mLOG . mX [ 34UL ] = t3 -> mU . mX [ 1UL ] ; out -> mLOG . mX [ 35UL ]
= t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [ 36UL ] = t3 -> mU . mX [ 1UL ] ;
out -> mLOG . mX [ 37UL ] = Capacitor2_v ; out -> mLOG . mX [ 38UL ] =
Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mLOG . mX [ 39UL ] =
Ideal_Semiconductor_Switch1_ideal_switch_i ; out -> mLOG . mX [ 40UL ] =
Capacitor2_v ; out -> mLOG . mX [ 41UL ] = t3 -> mX . mX [ 7UL ] ; out ->
mLOG . mX [ 42UL ] = Ideal_Semiconductor_Switch1_ideal_switch_v ; out -> mLOG
. mX [ 43UL ] = - ( - Ideal_Semiconductor_Switch1_ideal_switch_v *
Ideal_Semiconductor_Switch1_ideal_switch_i ) ; out -> mLOG . mX [ 44UL ] = t3
-> mU . mX [ 1UL ] ; out -> mLOG . mX [ 45UL ] =
Ideal_Semiconductor_Switch1_ideal_switch_v ; out -> mLOG . mX [ 46UL ] = t3
-> mU . mX [ 1UL ] ; out -> mLOG . mX [ 47UL ] = Resistor_p_v ; out -> mLOG .
mX [ 48UL ] = t3 -> mU . mX [ 0UL ] ; out -> mLOG . mX [ 49UL ] = t3 -> mX .
mX [ 1UL ] ; out -> mLOG . mX [ 51UL ] = Current_Sensor1_i1 ; out -> mLOG .
mX [ 52UL ] = t3 -> mX . mX [ 10UL ] ; out -> mLOG . mX [ 53UL ] =
Inductor1_xpowerExternalThermal ; out -> mLOG . mX [ 54UL ] = -
Inductor1_xpowerExternalThermal ; out -> mLOG . mX [ 55UL ] =
Current_Sensor1_i1 ; out -> mLOG . mX [ 56UL ] = Capacitor_p_v ; out -> mLOG
. mX [ 57UL ] = Resistor_p_v ; out -> mLOG . mX [ 58UL ] = Current_Sensor1_i1
* 1.0E+6 ; out -> mLOG . mX [ 59UL ] = - ( Current_Sensor1_i1 *
Current_Sensor1_i1 * - 1.0E+6 ) ; out -> mLOG . mX [ 60UL ] = t3 -> mU . mX [
0UL ] ; out -> mLOG . mX [ 61UL ] = t3 -> mU . mX [ 1UL ] ; out -> mLOG . mX
[ 62UL ] = t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [ 63UL ] = t3 -> mX . mX
[ 8UL ] ; out -> mLOG . mX [ 64UL ] = t3 -> mX . mX [ 7UL ] ; out -> mLOG .
mX [ 65UL ] = t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 66UL ] = t3 -> mX .
mX [ 13UL ] ; out -> mLOG . mX [ 67UL ] = Subsystem2_P_SSHI_Vload1_n_v ; out
-> mLOG . mX [ 68UL ] = t3 -> mX . mX [ 11UL ] ; out -> mLOG . mX [ 70UL ] =
t3 -> mX . mX [ 2UL ] ; out -> mLOG . mX [ 71UL ] = - ( t3 -> mX . mX [ 13UL
] * t3 -> mX . mX [ 13UL ] * - 1.0E-9 ) ; out -> mLOG . mX [ 72UL ] =
Subsystem2_P_SSHI_Current_Sensor3_i1 ; out -> mLOG . mX [ 73UL ] =
Subsystem2_P_SSHI_Current_Sensor3_i1 ; out -> mLOG . mX [ 74UL ] = t3 -> mX .
mX [ 11UL ] ; out -> mLOG . mX [ 75UL ] = t3 -> mX . mX [ 11UL ] ; out ->
mLOG . mX [ 76UL ] = Subsystem2_P_SSHI_Current_Sensor3_i1 ; out -> mLOG . mX
[ 77UL ] = Subsystem2_P_SSHI_Resistor_p_v ; out -> mLOG . mX [ 78UL ] = t3 ->
mX . mX [ 5UL ] ; out -> mLOG . mX [ 79UL ] = t3 -> mX . mX [ 0UL ] ; out ->
mLOG . mX [ 81UL ] = Subsystem2_P_SSHI_Resistor_i ; out -> mLOG . mX [ 82UL ]
= t3 -> mX . mX [ 6UL ] ; out -> mLOG . mX [ 83UL ] =
Subsystem2_P_SSHI_Inductor2_xpowerExternalThermal ; out -> mLOG . mX [ 84UL ]
= - Subsystem2_P_SSHI_Inductor2_xpowerExternalThermal ; out -> mLOG . mX [
85UL ] = Current_Sensor1_i1 ; out -> mLOG . mX [ 86UL ] =
Subsystem2_P_SSHI_Resistor_i ; out -> mLOG . mX [ 87UL ] = t3 -> mX . mX [
8UL ] ; out -> mLOG . mX [ 88UL ] = Subsystem2_P_SSHI_Resistor_p_v ; out ->
mLOG . mX [ 89UL ] = Subsystem2_P_SSHI_Resistor_i * 263.76142439263435 ; out
-> mLOG . mX [ 90UL ] = - ( Subsystem2_P_SSHI_Resistor_i *
Subsystem2_P_SSHI_Resistor_i * - 263.76142439263435 ) ; out -> mLOG . mX [
91UL ] = Subsystem2_P_SSHI_Resistor1_i ; out -> mLOG . mX [ 92UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 93UL ] = t3 -> mX . mX [
11UL ] ; out -> mLOG . mX [ 94UL ] = Subsystem2_P_SSHI_Resistor1_i * 1.0E+7 ;
out -> mLOG . mX [ 95UL ] = - ( Subsystem2_P_SSHI_Resistor1_i *
Subsystem2_P_SSHI_Resistor1_i * - 1.0E+7 ) ; out -> mLOG . mX [ 96UL ] = t3
-> mU . mX [ 2UL ] ; out -> mLOG . mX [ 97UL ] = t3 -> mX . mX [ 11UL ] ; out
-> mLOG . mX [ 98UL ] = t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [ 99UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 100UL ] = t3 -> mX . mX [
8UL ] ; out -> mLOG . mX [ 101UL ] = t3 -> mX . mX [ 12UL ] ; out -> mLOG .
mX [ 102UL ] = t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [ 103UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 104UL ] =
Subsystem2_P_SSHI_Subsystem_Diode11_v ; out -> mLOG . mX [ 105UL ] = - ( -
Subsystem2_P_SSHI_Subsystem_Diode11_v * t3 -> mX . mX [ 12UL ] ) ; out ->
mLOG . mX [ 106UL ] = Subsystem2_P_SSHI_Subsystem_Diode13_i ; out -> mLOG .
mX [ 107UL ] = t3 -> mX . mX [ 11UL ] ; out -> mLOG . mX [ 108UL ] = t3 -> mX
. mX [ 7UL ] ; out -> mLOG . mX [ 109UL ] =
Subsystem2_P_SSHI_Subsystem_Diode13_v ; out -> mLOG . mX [ 110UL ] = - ( -
Subsystem2_P_SSHI_Subsystem_Diode13_v * Subsystem2_P_SSHI_Subsystem_Diode13_i
) ; out -> mLOG . mX [ 111UL ] = Subsystem2_P_SSHI_Subsystem_Diode14_i ; out
-> mLOG . mX [ 112UL ] = t3 -> mX . mX [ 11UL ] ; out -> mLOG . mX [ 113UL ]
= t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 114UL ] =
Subsystem2_P_SSHI_Subsystem_Diode14_v ; out -> mLOG . mX [ 115UL ] = - ( -
Subsystem2_P_SSHI_Subsystem_Diode14_v * Subsystem2_P_SSHI_Subsystem_Diode14_i
) ; out -> mLOG . mX [ 116UL ] = Subsystem2_P_SSHI_Subsystem_Diode15_i ; out
-> mLOG . mX [ 117UL ] = t3 -> mX . mX [ 8UL ] ; out -> mLOG . mX [ 118UL ] =
Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 119UL ] =
Subsystem2_P_SSHI_Subsystem_Diode15_v ; out -> mLOG . mX [ 120UL ] = - ( -
Subsystem2_P_SSHI_Subsystem_Diode15_v * Subsystem2_P_SSHI_Subsystem_Diode15_i
) ; out -> mLOG . mX [ 121UL ] = - Subsystem2_P_SSHI_Resistor_i ; out -> mLOG
. mX [ 122UL ] = t3 -> mX . mX [ 7UL ] ; out -> mLOG . mX [ 123UL ] = t3 ->
mX . mX [ 5UL ] ; out -> mLOG . mX [ 124UL ] = Subsystem2_P_SSHI_Switch_v ;
out -> mLOG . mX [ 125UL ] = - Subsystem2_P_SSHI_Switch_v *
Subsystem2_P_SSHI_Resistor_i ; out -> mLOG . mX [ 126UL ] = t3 -> mU . mX [
2UL ] ; out -> mLOG . mX [ 127UL ] = Subsystem2_P_SSHI_Vload1_V ; out -> mLOG
. mX [ 128UL ] = Subsystem2_P_SSHI_Vload1_n_v ; out -> mLOG . mX [ 129UL ] =
t3 -> mX . mX [ 11UL ] ; out -> mLOG . mX [ 130UL ] =
Subsystem2_P_SSHI_Vload1_V ; out -> mLOG . mX [ 131UL ] = Current_Sensor1_i1
; out -> mLOG . mX [ 132UL ] = Current_Sensor1_i1 ; out -> mLOG . mX [ 133UL
] = Capacitor2_v ; out -> mLOG . mX [ 134UL ] = Capacitor2_v ; out -> mLOG .
mX [ 135UL ] = Capacitor2_v ; ( void ) sys ; ( void ) out ; return 0 ; }
