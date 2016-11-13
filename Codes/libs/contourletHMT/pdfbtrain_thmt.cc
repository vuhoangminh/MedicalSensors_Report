//-----------------------------------------------------------------------------
// pdfbtrain_thmt.cc  -  Train Tying HMT from a random model
//
// input arguments: - nSt - number of hidden states
//                  - nLev - number of levels
//                  - zm - yes for zeromean, no for nonzero mean
//                  - data - input data file used to train the tree model
//                           (for data file format, refer to tree.hh)
//                  - mod - output file for the trained model
//                          (for model file format, refer to thmt.hh)
//                  - mD - minimum delta to decide convergence
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
void pdfbtrain_thmt(int nSt, int nLev, int* levndir, bool zm, 
		    tree<double>* dataTree, const mxArray* model, double mD, 
		    const mxArray* stateprob)
{
   
    // A random model
    THMT thmt(nSt, nLev, levndir, zm);

    // Training
    thmt.batch_train(dataTree, mD);

    // Saving
    thmt.dump_model_struct(model);
    thmt.dump_state_prob(stateprob);

}

//-----------------------------------------------------------------------------
void pdfbtrain_thmt(int nSt, int nLev, int* levndir, bool zm, 
		    tree<double>* dataTree, const mxArray* model, double mD)
{
   
    // A random model
    THMT thmt(nSt, nLev, levndir, zm);

    // Training
    thmt.batch_train(dataTree, mD);

    // Saving
    thmt.dump_model_struct(model);

}

//-----------------------------------------------------------------------------
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )     
{
    double mD, *data, *templevndir; 
    int ns, nl, status, zeromeanlen, datafilelen, modelfilelen, 
      spfilelen, i, n, rrow, rcol, *levndir;
    char *zeromean, *tempsp;
    tree<double>* dataTree;
    const mxArray *datacell;
    bool zm;
    
    /* Check for proper number of arguments */
    
    if ((nrhs != 7) && (nrhs != 8)) { 
	mexErrMsgTxt("Wrong number of arguments."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 

    ns = (int)mxGetScalar(prhs[0]); 
    nl = (int)mxGetScalar(prhs[1]);

    levndir = new int[nl];
    templevndir = mxGetPr(prhs[2]);
    for(i = 0; i<nl; i++)
      levndir[i] = (int)(templevndir[i]);
    
    zeromeanlen = (mxGetM(prhs[3]) * mxGetN(prhs[3])) + 1;
    zeromean = (char*)mxCalloc(zeromeanlen, sizeof(char)); 

    status = mxGetString(prhs[3], zeromean, zeromeanlen);
    if(status != 0) 
      mexWarnMsgTxt("Not enough space. String is truncated.");

    datacell = mxGetCell(prhs[4],0);
    rrow = mxGetM(datacell);
    rcol = mxGetN(datacell);
    if (rcol!=1)
      mexErrMsgTxt("Error: Data Tree from matlab has incorrect format.");
    dataTree = new tree<double>(rrow, 4, nl, 0);
    for (i = 0; i < nl; i++)
      {
	datacell = mxGetCell(prhs[4], i);
	data = mxGetPr(datacell);
 
	for (n = 0; n < (*dataTree)[i].size(); n++)
	  (*dataTree)[i][n] = *data++;
      }

    if (strcmp(zeromean, "yes") == 0) 
      zm = true;
    else if (strcmp(zeromean, "no") == 0)
      zm = false;
    else
      mexErrMsgTxt("Either yes or no for zeromean");

    mD = mxGetScalar(prhs[5]);

    if (nrhs == 8) {
      /* Do the actual computations in a subroutine */
      pdfbtrain_thmt(ns, nl, levndir, zm, dataTree, prhs[6], mD, prhs[7]);
    }
    else
      /* Do the actual computations in a subroutine */
      pdfbtrain_thmt(ns, nl, levndir, zm, dataTree, prhs[6], mD);

    return;    
}


