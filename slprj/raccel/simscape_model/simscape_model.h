#ifndef simscape_model_h_
#define simscape_model_h_
#ifndef simscape_model_COMMON_INCLUDES_
#define simscape_model_COMMON_INCLUDES_
#include <stdlib.h>
#include "sl_AsyncioQueue/AsyncioQueueCAPI.h"
#include "rtwtypes.h"
#include "sigstream_rtw.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging_simtarget.h"
#include "rt_nonfinite.h"
#include "math.h"
#include "dt_info.h"
#include "ext_work.h"
#include "nesl_rtw.h"
#include "simscape_model_9755456e_1_gateway.h"
#include "ssc_rtw_logging.h"
#include "physmod/common/logging2/core/rtw/rtw_log_fcn_manager.h"
#include "stdlib.h"
#include "physmod/common/logging2/core/rtw/SscRTWLogging.h"
#endif
#include "simscape_model_types.h"
#include <stddef.h>
#include "mwmathutil.h"
#include <string.h>
#include "rt_zcfcnRefine.h"
#include "rt_zcfcn.h"
#include "rtGetInf.h"
#include "rtw_modelmap.h"
#include "rtw_modelmap_simtarget.h"
#include "rt_defines.h"
#include "zero_crossing_types.h"
#define MODEL_NAME simscape_model
#define NSAMPLE_TIMES (2) 
#define NINPUTS (0)       
#define NOUTPUTS (0)     
#define NBLOCKIO (12) 
#define NUM_ZC_EVENTS (8) 
#ifndef NCSTATES
#define NCSTATES (5)   
#elif NCSTATES != 5
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T oubxqspwod ; real_T jukrnxvliq ; real_T dc4ls1uyzy [
4 ] ; real_T iqwtgpffb2 [ 4 ] ; real_T fo14nkxzwy ; real_T cgh5hktsjq ;
real_T bywbs50iot [ 4 ] ; real_T jbpkcbmsoh [ 28 ] ; real_T ihxl5wrkqd [ 6 ]
; boolean_T eg2onjjxzy ; boolean_T oehfmw05sg ; boolean_T piz1w4neql ; } B ;
typedef struct { real_T ns3sryrqck [ 2 ] ; real_T b3smama2eu [ 2 ] ; real_T
pl5rsz41nv ; real_T lcbzakxitd [ 2 ] ; real_T gr1tl3jpbw ; real_T fpvjvn3i0x
; real_T jn1vj0hjog ; real_T mscthsnh4c ; real_T kwvh1h53fr ; real_T
pxztrufhtr ; real_T ieoipkasg0 ; real_T kgcp153raj ; real_T fyndzzco0o ;
real_T ocr2fb2htt ; real_T potn2143xj ; real_T nqlucgamt1 ; real_T e3kmgxq2mg
; real_T ijslwcksyt ; real_T c3bez4tbj3 ; real_T pyb1kyt3pn ; real_T
a5ye3yw0eg ; real_T kypwc3cmls [ 17 ] ; real_T hej2ckjb2i ; real_T pfr4ur4ccw
[ 7 ] ; real_T cqmxv4ikm2 ; real_T kmek413xjz ; real_T ccuuuzbrna ; struct {
void * TimePtr ; void * DataPtr ; void * RSimInfoPtr ; } gtoj3t1yxd ; void *
oyiubqed5q ; void * mbloowwnzy ; void * mpsvq1mqtc ; void * br1m5dmrms ; void
* g524oiacv1 ; void * phlhmluwcg ; void * knwdpc1g4s ; void * noo2ygukqs ;
void * jr35zxfzee ; void * pza0u3qsa1 ; struct { void * AQHandles ; }
cdyju4m2i0 ; struct { void * AQHandles ; } pdlawnzz43 ; struct { void *
AQHandles ; } jtc0bcbtj5 ; void * b1qfia0exu ; void * inxwtzgorm ; void *
hh0oyp1f2n ; void * jlzxsfp4ps ; void * euqu5245ne ; struct { void *
AQHandles ; } jm4otpptor ; struct { void * AQHandles ; } jqfng4wcbc ; struct
{ void * AQHandles ; } pdlawnzz43n ; struct { void * AQHandles ; }
jtc0bcbtj5y ; struct { void * AQHandles ; } cdyju4m2i0e ; struct { void *
AQHandles ; } fio5gfihvq ; int32_T lweclmmpe0 ; int32_T ddp1obzjvo ; int32_T
ceom2bmae1 ; int32_T lbsdpz4ihp ; int32_T bdn1ymfo5h ; int32_T ddp1obzjvog ;
int32_T ceom2bmae1z ; int32_T lweclmmpe0z ; int32_T alx0pc0wvg ; struct {
int_T PrevIndex ; } n0zxacxf1l ; int_T n5zb5g2pxc [ 6 ] ; int_T hu1sw1yly1 ;
int_T oohsc251vh ; int_T eizatzn21x ; int_T ekt2heefmx ; boolean_T gzroy3y1us
; boolean_T n3josujmv0 ; boolean_T g4yjw3ibic ; boolean_T cvomrxhs42 ;
boolean_T azflf0jxhk ; uint8_T hyn34tqyhg [ 7 ] ; uint8_T egcop1hidl [ 7 ] ;
uint8_T khtwmdpm1n ; uint8_T afcsqes2su ; boolean_T pg5uo13xab ; boolean_T
jnwrh0mkqe ; boolean_T iqnjz320h2 ; boolean_T h31w2dd5tc ; } DW ; typedef
struct { real_T p21matmfi5 [ 5 ] ; } X ; typedef struct { real_T p21matmfi5 [
5 ] ; } XDot ; typedef struct { boolean_T p21matmfi5 [ 5 ] ; } XDis ; typedef
struct { real_T p21matmfi5 [ 5 ] ; } CStateAbsTol ; typedef struct { real_T
p21matmfi5 [ 5 ] ; } CXPtMin ; typedef struct { real_T p21matmfi5 [ 5 ] ; }
CXPtMax ; typedef struct { real_T jfjrnerl2q ; real_T p5vgsf3cxx ; real_T
l2fltnp4ja ; real_T d0idjibkot ; real_T nxvjgtwqit ; real_T emj4q5wrcl ;
real_T hhixpeafki ; real_T biurxunari ; } ZCV ; typedef struct { ZCSigState
ddtxs3dcvh ; ZCSigState kkimsnnp4b ; ZCSigState krpxp04d3n ; ZCSigState
nuyrkisows ; ZCSigState mjyjglrgas ; ZCSigState bw5f3kot2i ; ZCSigState
enygenw31n ; ZCSigState ptrf3eow1f ; } PrevZCX ; typedef struct {
rtwCAPI_ModelMappingInfo mmi ; } DataMapInfo ; struct P_ {
FrmWksBus_2277297056879121903 FrmWksBus_2277297056879121903_TU ; real_T
VSrc_eq_amp ; real_T w ; real_T ChangeDetector_ChangeType ; boolean_T
MonostableFlipFlop_x0 ; real_T Constant_Value ; real_T SineWave_Bias ; real_T
SineWave_Phase ; real_T Constant_Value_ezxolk4shd ; real_T
UnitDelay_InitialCondition ; real_T Constant1_Value ; real_T
HitCrossing_Offset ; boolean_T UnitDelay1_InitialCondition ; boolean_T
UnitDelay_InitialCondition_ds2jg10wsv ; } ; extern const char_T *
RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern X rtX ; extern DW rtDW ;
extern PrevZCX rtPrevZCX ; extern P rtP ; extern mxArray *
mr_simscape_model_GetDWork ( ) ; extern void mr_simscape_model_SetDWork ( const
mxArray * ssDW ) ; extern mxArray *
mr_simscape_model_GetSimStateDisallowedBlocks ( ) ; extern const
rtwCAPI_ModelMappingStaticInfo * simscape_model_GetCAPIStaticMap ( void ) ;
extern SimStruct * const rtS ; extern DataMapInfo * rt_dataMapInfoPtr ;
extern rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr ; void MdlOutputs ( int_T
tid ) ; void MdlOutputsParameterSampleTime ( int_T tid ) ; void MdlUpdate ( int_T tid ) ; void MdlTerminate ( void ) ; void MdlInitializeSizes ( void ) ; void MdlInitializeSampleTimes ( void ) ; SimStruct * raccel_register_model ( ssExecutionInfo * executionInfo ) ;
#endif
