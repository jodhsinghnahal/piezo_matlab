#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "simscape_model_capi_host.h"
#define sizeof(...) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)
#ifndef SS_UINT64
#define SS_UINT64 21
#endif
#ifndef SS_INT64
#define SS_INT64 22
#endif
#else
#include "builtin_typeid_types.h"
#include "simscape_model.h"
#include "simscape_model_capi.h"
#include "simscape_model_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST
#define TARGET_STRING(s)               ((NULL))
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , TARGET_STRING ( "simscape_model/From Workspace" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 1 , 0 , TARGET_STRING ( "simscape_model/Sine Wave" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 2 , 0 , TARGET_STRING ( "simscape_model/Solver Configuration/EVAL_KEY/INPUT_1_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 3 , 0 , TARGET_STRING ( "simscape_model/Solver Configuration/EVAL_KEY/INPUT_2_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 4 , 0 , TARGET_STRING ( "simscape_model/Solver Configuration/EVAL_KEY/INPUT_3_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 5 , 0 , TARGET_STRING ( "simscape_model/Solver Configuration/EVAL_KEY/OUTPUT_1_0" ) , TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 0 } , { 6 , 0 , TARGET_STRING ( "simscape_model/Solver Configuration/EVAL_KEY/STATE_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0 } , { 7 , 0 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Data Type Conversion" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 8 , 0 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Hit  Crossing" ) , TARGET_STRING ( "" ) , 0 , 1 , 0 , 0 , 1 } , { 9 , 0 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Unit Delay" ) , TARGET_STRING ( "" ) , 0 , 1 , 0 , 0 , 1 } , { 10 , 0 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Sum" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 11 , 0 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Compare To Zero/Compare" ) , TARGET_STRING ( "" ) , 0 , 1 , 0 , 0 , 1 } , { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters rtBlockParameters [ ] = { { 12 , TARGET_STRING ( "simscape_model/Sine Wave" ) , TARGET_STRING ( "Bias" ) , 0 , 0 , 0 } , { 13 , TARGET_STRING ( "simscape_model/Sine Wave" ) , TARGET_STRING ( "Phase" ) , 0 , 0 , 0 } , { 14 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop" ) , TARGET_STRING ( "x0" ) , 1 , 0 , 0 } , { 15 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Hit  Crossing" ) , TARGET_STRING ( "HitCrossingOffset" ) , 0 , 0 , 0 } , { 16 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Unit Delay" ) , TARGET_STRING ( "InitialCondition" ) , 1 , 0 , 0 } , { 17 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Change Detector" ) , TARGET_STRING ( "ChangeType" ) , 0 , 0 , 0 } , { 18 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Constant" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 19 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Constant1" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 20 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Unit Delay" ) , TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 21 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Unit Delay1" ) , TARGET_STRING ( "InitialCondition" ) , 1 , 0 , 0 } , { 22 , TARGET_STRING ( "simscape_model/Subsystem2/P-SSHI/Monostable Flip-Flop/Discrete/Compare To Zero/Constant" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 } } ; static int_T rt_LoggedStateIdxList [ ] = { - 1 } ; static const rtwCAPI_Signals rtRootInputs [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_Signals rtRootOutputs [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_ModelParameters rtModelParameters [ ] = { { 23 , TARGET_STRING ( "FrmWksBus_2277297056879121903_TU" ) , 4 , 0 , 0 } , { 24 , TARGET_STRING ( "VSrc_eq_amp" ) , 0 , 0 , 0 } , { 25 , TARGET_STRING ( "w" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , 0 , 0 , 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . oubxqspwod , & rtB . jukrnxvliq ,
& rtB . dc4ls1uyzy [ 0 ] , & rtB . iqwtgpffb2 [ 0 ] , & rtB . bywbs50iot [ 0
] , & rtB . ihxl5wrkqd [ 0 ] , & rtB . jbpkcbmsoh [ 0 ] , & rtB . cgh5hktsjq
, & rtB . piz1w4neql , & rtB . eg2onjjxzy , & rtB . fo14nkxzwy , & rtB .
oehfmw05sg , & rtP . SineWave_Bias , & rtP . SineWave_Phase , & rtP .
MonostableFlipFlop_x0 , & rtP . HitCrossing_Offset , & rtP .
UnitDelay_InitialCondition_ds2jg10wsv , & rtP . ChangeDetector_ChangeType , &
rtP . Constant_Value_ezxolk4shd , & rtP . Constant1_Value , & rtP .
UnitDelay_InitialCondition , & rtP . UnitDelay1_InitialCondition , & rtP .
Constant_Value , & rtP . FrmWksBus_2277297056879121903_TU , & rtP .
VSrc_eq_amp , & rtP . w , } ; static int32_T * rtVarDimsAddrMap [ ] = { ( NULL
) } ;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , ( uint8_T ) SS_DOUBLE , 0 , 0 , 0 } ,
{ "unsigned char" , "boolean_T" , 0 , 0 , sizeof ( boolean_T ) , ( uint8_T )
SS_BOOLEAN , 0 , 0 , 0 } , { "numeric" , "pointer_T" , 0 , 0 , sizeof ( pointer_T ) , ( uint8_T ) SS_POINTER , 0 , 1 , 0 } , { "unsigned int" , "uint32_T" , 0 , 0 , sizeof ( uint32_T ) , ( uint8_T ) SS_UINT32 , 0 , 0 , 0 } , { "struct" , "FrmWksBus_2277297056879121903" , 3 , 1 , sizeof ( FrmWksBus_2277297056879121903 ) , ( uint8_T ) SS_STRUCT , 0 , 0 , 0 } } ;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , { "time0" , rt_offsetof ( FrmWksBus_2277297056879121903 , time0
) , 2 , 0 , 0 } , { "signals0" , rt_offsetof ( FrmWksBus_2277297056879121903
, signals0 ) , 2 , 0 , 0 } , { "numPoints0" , rt_offsetof ( FrmWksBus_2277297056879121903 , numPoints0 ) , 3 , 0 , 0 } } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { { rtwCAPI_SCALAR , 0 , 2 , 0 } , { rtwCAPI_VECTOR , 2 , 2 , 0 } , { rtwCAPI_VECTOR , 4 , 2 , 0 } , { rtwCAPI_VECTOR , 6 , 2 , 0 } } ; static const uint_T rtDimensionArray [ ] = { 1 , 1 , 4 , 1 , 6 , 1 , 28 , 1 } ; static const real_T rtcapiStoredFloats [ ] = { 0.0 , 2.1142176845551148E-5 } ; static const rtwCAPI_FixPtMap rtFixPtMap [ ] = { { ( NULL ) , ( NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , ( boolean_T ) 0 } , } ; static const rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * ) & rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , ( int8_T ) 0 , ( uint8_T ) 0 } , { ( const void * ) & rtcapiStoredFloats [ 1 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , ( int8_T ) 1 , ( uint8_T ) 0 } } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { { rtBlockSignals , 12 , rtRootInputs , 0 , rtRootOutputs , 0 } , { rtBlockParameters , 11 , rtModelParameters , 3 } , { ( NULL ) , 0 } , { rtDataTypeMap , rtDimensionMap , rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float" , { 2591884068U , 635088960U , 4178623224U , 3725992039U } , ( NULL ) , 0 , ( boolean_T ) 0 , rt_LoggedStateIdxList } ; const rtwCAPI_ModelMappingStaticInfo * simscape_model_GetCAPIStaticMap ( void ) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void simscape_model_InitializeDataMapInfo ( void ) { rtwCAPI_SetVersion ( ( *
rt_dataMapInfoPtr ) . mmi , 1 ) ; rtwCAPI_SetStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ; rtwCAPI_SetLoggingStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ; rtwCAPI_SetDataAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ; rtwCAPI_SetVarDimsAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtVarDimsAddrMap ) ;
rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi , 0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void simscape_model_host_InitializeDataMapInfo ( simscape_model_host_DataMapInfo_T * dataMap , const char * path ) { rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ; rtwCAPI_SetStaticMap ( dataMap -> mmi , & mmiStatic ) ; rtwCAPI_SetDataAddressMap ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetPath ( dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
