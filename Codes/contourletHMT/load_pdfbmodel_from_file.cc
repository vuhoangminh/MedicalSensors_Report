//-----------------------------------------------------------------------------
// load_pdfbmodel_from_file.cc  -  load the pdfb model structure from a file
//
// input arguments: - model - model to load into
//                  - filename - name of the file to load from
//                  - levndir - the number of directions in model
//                  - nl - the number of levels in model
//                  - startpos - the starting position in the file
//-----------------------------------------------------------------------------

#include <stdlib.h>
#include <string.h>
#include "pdfbthmt.hh"
#include "mex.h"


//-----------------------------------------------------------------------------
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )     
{
    double *templevndir;
    int status, filenamelen, *levndir, nl, i;
    char *filename;
    long startpos;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 5) { 
	mexErrMsgTxt("Wrong number of arguments."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 

    filenamelen = (mxGetM(prhs[1]) * mxGetN(prhs[1])) + 1;
    filename = (char*)mxCalloc(filenamelen, sizeof(char)); 

    status = mxGetString(prhs[1], filename, filenamelen);
    if(status != 0) 
      mexWarnMsgTxt("Not enough space. String is truncated.");

    nl = (int)mxGetScalar(prhs[3]);
    startpos = (long)mxGetScalar(prhs[4]);

    levndir = new int[nl];
    templevndir = mxGetPr(prhs[2]);
    for(i = 0; i<nl; i++)
      levndir[i] = (int)(templevndir[i]);

    THMT thmt(filename, levndir, startpos);

    thmt.dump_model_struct(prhs[0]);

    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    *mxGetPr(plhs[0]) = (double)startpos;

    return;    
}
