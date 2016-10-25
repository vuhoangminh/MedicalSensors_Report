//-----------------------------------------------------------------------------
// pdfbgen_tdata.cc  - Generate data from a Tying HMT Model for PDFB
//
// input arguments: 
// nObs - number of observations (trees) to be generated randomly (nRoots)
// modelfile - input file containing HMT parameters used in random generation
//             (for modelfile format, see thmt.hh)
// datafile - output file containing generated data in tree structures
//            (for datafile format, see tree.hh)
//-----------------------------------------------------------------------------

#include <stdlib.h>
#include <iostream>
#include "pdfbthmt.hh"


tree<double>* pdfbgen_tdata(const mxArray* model, int ntrees, int* levndir, 
			    int nl)
{
   tree<double>* data = new tree<double>(ntrees, 4, nl, 0);

   THMT thmt(model, levndir);

   // Generate data
   thmt.generate_data(*data, ntrees);

   return data;
}

//---------------------------------------------------------------------------  
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )     
{
    double *data, *templevndir; 
    int nObs, nl, i, n, *levndir, *intptr, temp;
    tree<double>* dataTree;
    const mxArray *constdatacell;
    mxArray *initcell, *datacell;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 4){ 
	mexErrMsgTxt("Wrong number of arguments."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 

    nl = (int)mxGetScalar(prhs[1]);
    nObs = (int)mxGetScalar(prhs[2]);

    levndir = new int[nl];
    templevndir = mxGetPr(prhs[3]);
    for(i = 0; i<nl; i++)
      levndir[i] = (int)(templevndir[i]);

    intptr = new int(nl);
    plhs[0] = mxCreateCellArray(1, intptr);
    temp = nObs;

    for (i = 0; i < nl; i++)
    {
      initcell = mxCreateDoubleMatrix(temp, 1, mxREAL);
      mxSetCell(plhs[0], i, initcell);
      temp = temp*4;
    }

    dataTree = pdfbgen_tdata(prhs[0], nObs, levndir, nl);

    for (i = 0; i < nl; i++)
    {
      constdatacell = plhs[0];
      datacell = mxGetCell(constdatacell, i);
      constdatacell = datacell;
      data = mxGetPr(constdatacell);

      for (n = 0; n < (*dataTree)[i].size(); n++)
	*data++ = (*dataTree)[i][n];
    }

    return;    
}


