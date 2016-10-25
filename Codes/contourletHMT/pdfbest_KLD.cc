//-----------------------------------------------------------------------------
// pdfbest_KLD.cc  -  Estimate the Kullback-Liebler distance using the
//                     Monte Carlo method
//
// input arguments: - model1 - the first THMT model
//                  - model2 - the second THMT model
//                  - N - number of trees to generate
//     
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <math.h>
#include "tree.hh"
#include "pdfbthmt.hh"
#include "mex.h"

//-----------------------------------------------------------------------------
double pdfbest_KLD(const mxArray* model1, const mxArray* model2, int* levndir,
		   int N)
{
    // Read initial model
    THMT thmt1(model1, levndir);
    THMT thmt2(model2, levndir);

    return KLD_est(thmt1, thmt2, N);
}

//-----------------------------------------------------------------------------
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )     
{
    double *templevndir, *kldist; 
    int nl, i, *levndir, N; 
    
    /* Check for proper number of arguments */
    
    if (nrhs != 5) { 
	mexErrMsgTxt("Wrong number of input arguments."); 
    } 
    else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
 
    nl = (int)mxGetScalar(prhs[0]);
    N = (int)mxGetScalar(prhs[4]);

    levndir = new int[nl];
    templevndir = mxGetPr(prhs[1]);
    for(i = 0; i<nl; i++)
      levndir[i] = (int)(templevndir[i]);

    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    kldist = mxGetPr(plhs[0]);

    /* Do the actual computations in a subroutine */
    *kldist = pdfbest_KLD(prhs[2], prhs[3] ,levndir, N);

    return;
}
