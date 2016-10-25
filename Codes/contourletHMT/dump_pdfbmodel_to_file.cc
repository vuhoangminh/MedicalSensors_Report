//-----------------------------------------------------------------------------
// dump_pdfbmodel_to_file.cc  -  save the pdfb model structure into a file
//
// input arguments: - model - model to save
//                  - filename - name of the file to save model
//                  - levndir - the number of directions in model
//                  - nl - the number of levels in model
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
    
    /* Check for proper number of arguments */
    
    if (nrhs != 4) { 
	mexErrMsgTxt("Wrong number of arguments."); 
    } else if (nlhs > 0) {
	mexErrMsgTxt("Too many output arguments."); 
    } 

    filenamelen = (mxGetM(prhs[1]) * mxGetN(prhs[1])) + 1;
    filename = (char*)mxCalloc(filenamelen, sizeof(char)); 

    status = mxGetString(prhs[1], filename, filenamelen);
    if(status != 0) 
      mexWarnMsgTxt("Not enough space. String is truncated.");

    nl = (int)mxGetScalar(prhs[3]);

    levndir = new int[nl];
    templevndir = mxGetPr(prhs[2]);
    for(i = 0; i<nl; i++)
      levndir[i] = (int)(templevndir[i]);

    THMT thmt(prhs[0], levndir);

    thmt.dump_model(filename);

    return;    
}
