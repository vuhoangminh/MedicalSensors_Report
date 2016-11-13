//-----------------------------------------------------------------------------
// pdfbprotrain_thmt.cc  -  Train Tying HMT from a model provided
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
void pdfbprotrain_thmt(int* levndir, tree<double>* dataTree, 
		       const mxArray* model, double mD, 
		       const mxArray* stateprob)
{
    // Read initial model
    THMT thmt(model, levndir);

    // Training
    thmt.batch_train(dataTree, mD);

    // Output to Struct
    thmt.dump_model_struct(model);
    thmt.dump_state_prob(stateprob);
}


//-----------------------------------------------------------------------------
void pdfbprotrain_thmt(int* levndir, tree<double>* dataTree,
		       const mxArray* model, double mD)
{
    // Read initial model
    THMT thmt(model, levndir);

    // Training
    thmt.batch_train(dataTree, mD);

    // Output to Struct
    thmt.dump_model_struct(model);
}

//-----------------------------------------------------------------------------
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )     
{  
    double mD, *data, *templevndir; 
    int ns, nl, status, i, n, rrow, rcol, *levndir; 
    tree<double>* dataTree;
    const mxArray* datacell;
    
    /* Check for proper number of arguments */
    
    if ((nrhs != 6) && (nrhs != 7)) { 
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

    datacell= mxGetCell(prhs[3], 0);
    rrow = mxGetM(datacell);
    rcol = mxGetN(datacell);
    if (rcol!=1)
      mexErrMsgTxt("Error: Data Tree from matlab has incorrect format.");
    dataTree = new tree<double>(rrow, 4, nl, 0);
    for (i = 0; i < nl; i++)
      {
	datacell = mxGetCell(prhs[3], i);
	data = mxGetPr(datacell);
 
	for (n = 0; n < (*dataTree)[i].size(); n++)
	  (*dataTree)[i][n] = *data++;
      }

    mD = mxGetScalar(prhs[4]);

    /* Do the actual computations in a subroutine */
    if (nrhs == 7)
      pdfbprotrain_thmt(levndir, dataTree, prhs[5], mD, prhs[6]);
    else
      pdfbprotrain_thmt(levndir, dataTree, prhs[5], mD); 
    
    return;
    
}


