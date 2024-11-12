/* $Revision: 1.5 $ */
/* 
 * ics_modellib.h 
 *
 * This header file contains the exported functions from 
 * model dll. 
 * The content is manualy copied from the top of matlab_iface.c which contains EXPORTED_FUNCTION statements
 * and should be updated if those statement is changed.
 *
 * Created by F. Shadpey on Nov. 11, 2010 
 */

#ifndef ICS_MODELLIB_H
#define ICS_MODELLIB_H

#define EXPORT_FCNS 
#include "mex.h"
#ifdef _WIN32
#ifdef EXPORT_FCNS
#define EXPORTED_FUNCTION __declspec(dllexport)
#else
#define EXPORTED_FUNCTION __declspec(dllimport)
#endif
#else
#define EXPORTED_FUNCTION
#endif


   EXPORTED_FUNCTION void sgetmem(const mxArray *addr_struct_mx, const mxArray *val_struct_mx);  
   EXPORTED_FUNCTION void ssetmem(const mxArray *addr_struct_mx, const mxArray *val_struct_mx);   // actually the same as setmem_css but extracts only those fields which are in val_struct...

   EXPORTED_FUNCTION char* revisions_infm(void);
   EXPORTED_FUNCTION char* revisions_tool_infm(void);
   EXPORTED_FUNCTION void reset_task_counter(void);
   EXPORTED_FUNCTION void MODELSTEP(void);
   EXPORTED_FUNCTION void MODELSTEPS(size_t nSteps);
   EXPORTED_FUNCTION mxArray* infm(void);
   EXPORTED_FUNCTION mxArray* sizeof_real_T(void);   
   EXPORTED_FUNCTION mxArray* get_mdlStepSize(void);
   EXPORTED_FUNCTION mxArray* syst_model (mxArray* ServiceInfm);
   EXPORTED_FUNCTION mxArray* syst_model_tf(long model_trimming_flag, mxArray* ServiceInfm);
   
   EXPORTED_FUNCTION mxArray* syst_model_n (mxArray* ServiceInfm, mxArray* NEX, mxArray* NEXX);
   EXPORTED_FUNCTION mxArray* syst_model_tf_n(long model_trimming_flag, mxArray* ServiceInfm, mxArray* NEX, mxArray* NEXX);
   
   
   EXPORTED_FUNCTION void CallInitBlock(void);
   EXPORTED_FUNCTION void mdlInit(void);
   EXPORTED_FUNCTION void mdlInitFunc(bool);
   EXPORTED_FUNCTION void mdlTerminate(void);
   EXPORTED_FUNCTION mxArray* sim(long N_STEPS, mxArray *mx_InputPtrs, mxArray *mx_InputVals, long SaveRefine, mxArray *mx_SavePtrsStruct, mxArray *mx_SaveValsStruct, mxArray *mx_time, mxArray *mx_starttime, long continue_sim, long eventfun_is_used, mxArray *mx_event_times, mxArray *mx_input_infm, mxArray* ServiceInfm);
   
   EXPORTED_FUNCTION void eval(long model_trimming_flag, long nt_enabled, mxArray *mx_VarPtrs, mxArray *mx_VarVals, mxArray *mx_SavePtrsStruct, mxArray *mx_SaveValsStruct, mxArray *mx_ntstates_ptrs,  mxArray* ServiceInfm);
   
   EXPORTED_FUNCTION mxArray* getptrs(mxArray *val_mx);
   EXPORTED_FUNCTION mxArray* getptr0(mxArray *val_mx);
   EXPORTED_FUNCTION mxArray* getmem(mxArray *addr_mx);
   EXPORTED_FUNCTION void     setmem(mxArray *addr_mx, mxArray* val_mx);
   EXPORTED_FUNCTION void     setmem_s(mxArray *addr_mx, mxArray* val_mx, long len);
   EXPORTED_FUNCTION void     setmem_ss(mxArray *addr_mx, mxArray* val_mx);
   EXPORTED_FUNCTION mxArray* getmem_s(mxArray *addr_mx);
   EXPORTED_FUNCTION mxArray* getmem_sr(mxArray *addr_mx); 
   EXPORTED_FUNCTION mxArray* getmem_css(const mxArray *addr_struct_mx);
   EXPORTED_FUNCTION void getptr_css(const mxArray *addr_struct_mx,const mxArray *pval_struct_mx);
   EXPORTED_FUNCTION void setmem_css(const mxArray *addr_struct_mx,const mxArray *val_struct_mx);
   
   EXPORTED_FUNCTION mxArray* mx_DuplicateArray(const mxArray *a);
   
   EXPORTED_FUNCTION mxArray* getptr0_Time(void);

   EXPORTED_FUNCTION mxArray* GetCounterz(void);
   EXPORTED_FUNCTION void SetCounterz(mxArray* Counterz);

   
   EXPORTED_FUNCTION mxArray *dumpAutoStorageData(void);
   EXPORTED_FUNCTION void restoreAutoStorageData(mxArray *mx_p);

#endif

