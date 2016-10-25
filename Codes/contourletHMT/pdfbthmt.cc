//-----------------------------------------------------------------------------
// pdfbthmt.cc  -  Tying Hidden Markov Tree Models for PDFB
//-----------------------------------------------------------------------------


#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include "pdfbthmt.hh"
#include "utils.hh"
#include "mex.h"

using std::cerr;
using std::endl;

//-----------------------------------------------------------------------------
THMT::THMT(int ns, int nl, int* levndir, bool zm)
    :M(ns), nCh(4), nLev(nl), zeromean(zm),
     model_trans(nLev, vector<matrix<double> >() ),
     model_mean(nLev, vector< vector<double> >() ), 
     model_stdv(nLev, vector< vector<double> >() )
{
    int i, J, k;
    
    for(i=0; i<nLev; i++){
      model_trans[i] = vector< matrix<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
						matrix<double>(M,M));
      model_mean[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
      model_stdv[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
    }

    rnd_init_model();

    // subbandtree is a tree structure used to keep track of which
    // directional subband does each coefficient in a tree belong to
    subbandtree = tree<int> (1, nCh, nLev, 0);
    // setting up the subbandtree tree
    for(J = 0; J<nLev-1; J++)
      for(i=0; i<subbandtree[J].size(); i++) 
	if(levndir[J+1]==levndir[J])
	  for(k=0; k<nCh; k++)
	    subbandtree[J+1][i*nCh+k] = subbandtree[J][i];
	else
	  for(k=0; k<nCh; k++)
	    if (k<nCh/2)
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2;
	    else
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2+1;
}


//-----------------------------------------------------------------------------
THMT::THMT(const mxArray* initmodel, int* levndir)
{
    register int J, MM, m, mm, n, i, k;   
    double* doubleptr;
    mxArray* pointer, *pointer2, *pointer3;
    int numfields, numels, zmlen;
    char* zm;

    numfields = mxGetNumberOfFields(initmodel);
    numels = mxGetNumberOfElements(initmodel);
    if ((numfields != 6) && (numfields != 7))
      mexErrMsgTxt("ERROR: number of fields in struct model is incorrect");

    if (numels != 1)
      mexErrMsgTxt("ERROR: Too many elements");

    if (strcmp(mxGetFieldNameByNumber(initmodel, 0), "nstates") != 0)
      mexErrMsgTxt("Field 0 has wrong name");

    pointer = mxGetFieldByNumber(initmodel, 0, 0);
    doubleptr = mxGetPr(pointer);
    M = (int)(*doubleptr);

    nCh = 4;

    if (strcmp(mxGetFieldNameByNumber(initmodel, 1), "nlevels") != 0)
      mexErrMsgTxt("Field 1 has wrong name");    

    pointer = mxGetFieldByNumber(initmodel, 0, 1);
    doubleptr = mxGetPr(pointer);
    nLev = (int)*doubleptr;

    if (strcmp(mxGetFieldNameByNumber(initmodel, 2), "zeromean") != 0)
      mexErrMsgTxt("Field 2 has wrong name");
    pointer = mxGetFieldByNumber(initmodel, 0, 2);
    zmlen = mxGetM(pointer) * mxGetN(pointer) + 1; 
    zm = (char*)mxCalloc(zmlen, sizeof(char));
    if (mxGetString(pointer, zm, zmlen) != 0)
      mexErrMsgTxt("Error: cannot get zeromean variable");
    if (strcmp(zm, "yes") == 0)
      zeromean = true;
    else if (strcmp(zm, "no") == 0)
      zeromean = false;
    else
      mexErrMsgTxt("Error: Zeromean can only be yes or no");

    model_trans = vector<vector<matrix<double> > >(nLev, 
						  vector<matrix<double> >() );
    model_mean = vector<vector<vector<double> > >(nLev, 
						 vector< vector<double> >() );
    model_stdv = vector<vector<vector<double> > >(nLev, 
						 vector< vector<double> >() );
    for(i=0; i<nLev; i++){
      model_trans[i] = vector< matrix<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
						matrix<double>(M,M));
      model_mean[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
      model_stdv[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
    }

    if (strcmp(mxGetFieldNameByNumber(initmodel, 3), "rootprob") != 0)
      mexErrMsgTxt("Field 3 has wrong name");
    pointer = mxGetFieldByNumber(initmodel, 0, 3);
    if (pointer == NULL) {
      mexPrintf("%s%d\n",
    		"FIELD:", 3);
      mexErrMsgTxt("Above field is empty!"); 
    }
    doubleptr = mxGetPr(pointer);
    for (m = 0; m < M; m++)
         model_trans[0][0][m][0]= doubleptr[m];
 
    if (strcmp(mxGetFieldNameByNumber(initmodel, 4), "transprob") != 0)
      mexErrMsgTxt("Field 4 has wrong name");
    pointer = mxGetFieldByNumber(initmodel, 0, 4);
    if (pointer == NULL) {
      mexPrintf("%s%d\n",
    		"FIELD:", 4);
      mexErrMsgTxt("Above field is empty!"); 
    }

    // Trans probs
    for (J =  1; J < nLev; J++)
    { 
      pointer2 = mxGetCell(pointer,J-1);
      for (m = 0; m < M; m++){
	for (mm = 0; mm < model_trans[J].size(); mm++) {
	    pointer3 = mxGetCell(pointer2, mm);
	    doubleptr = mxGetPr(pointer3);
	    for (n = 0; n < M; n++)
	       model_trans[J][mm][m][n] = doubleptr[n*M+m];
	}
      }
    }

    // Mean
    if (!zeromean)
    {
        if (strcmp(mxGetFieldNameByNumber(initmodel, 5), "mean") != 0)
	  mexErrMsgTxt("Field 5 has wrong name");
        pointer = mxGetFieldByNumber(initmodel, 0, 5);
	if (pointer == NULL) {
	  mexPrintf("%s%d\n",
		    "FIELD:", 5);
	  mexErrMsgTxt("Above field is empty!");
	}
	for (J = 0; J < nLev; J++)
	{
	  pointer2 = mxGetCell(pointer, J);
	  for (mm=0; mm < model_mean[J].size(); mm++){
	    pointer3 = mxGetCell(pointer2, mm);
	    doubleptr = mxGetPr(pointer3);
	    for (m=0; m<M; m++)
	       model_mean[J][mm][m] = doubleptr[m];
	  }
	}
    }

    if(!zeromean){
      if (strcmp(mxGetFieldNameByNumber(initmodel, 6), "stdv") != 0)
	mexErrMsgTxt("Field 6 has wrong name");
      pointer = mxGetFieldByNumber(initmodel, 0, 6);
      if (pointer == NULL) {
	mexPrintf("%s%d\n",
		  "FIELD:", 6);
	mexErrMsgTxt("Above field is empty!");
      }
    }
    else{
      if (strcmp(mxGetFieldNameByNumber(initmodel, 5), "stdv") != 0)
	mexErrMsgTxt("Field 5 has wrong name");
      pointer = mxGetFieldByNumber(initmodel, 0, 5);
      if (pointer == NULL) {
	mexPrintf("%s%d\n",
		  "FIELD:", 5);
	mexErrMsgTxt("Above field is empty!");
      } 
    }

    // Standard deviation
    for (J =  0; J < nLev; J++)
    {
      pointer2 = mxGetCell(pointer, J);
      for (mm=0; mm < model_stdv[J].size(); mm++){
	pointer3 = mxGetCell(pointer2, mm);
	doubleptr = mxGetPr(pointer3);
	for (m = 0; m < M; m++) 
	    model_stdv[J][mm][m] = doubleptr[m];
      }
    }

    subbandtree = tree<int> (1, nCh, nLev, 0);
    // setting up the subbandtree tree
    for(J = 0; J<nLev-1; J++)
      for(i=0; i<subbandtree[J].size(); i++) 
	if(levndir[J+1]==levndir[J])
	  for(k=0; k<nCh; k++)
	    subbandtree[J+1][i*nCh+k] = subbandtree[J][i];
	else
	  for(k=0; k<nCh; k++)
	    if (k<nCh/2)
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2;
	    else
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2+1;
}


//-----------------------------------------------------------------------------
THMT::THMT(char *filename, int* levndir, long& startpos)
{
    FILE *fp;
    register int J, MM, m, mm, n, i, k;
    char szm[10];
   
    fp = fopen(filename,"a+");
    if (!fp) 
    {
	cerr << "ERROR: can not open for reading " << filename << endl;
	exit(-1);
    }

    fseek(fp, startpos, SEEK_SET);

    if (fscanf(fp, "nStates: %d\n", &M) != 1) 
    {
	cerr << "ERROR: problem reading nStates field of " 
	     << filename << endl;
	exit(-1);
    }

    nCh = 4;

    if (fscanf(fp, "nLevels: %d\n", &nLev) != 1) 
    {
	cerr << "ERROR: problem reading nLevels field of " 
	     << filename << endl;
	exit(-1);
    }

    if (fscanf(fp, "zeroMean: %s\n", &szm) != 1) 
    {
	cerr << "ERROR: problem reading zeroMean field of " 
	     << filename << endl;
	exit(-1);
    }

    if (strcmp(szm, "yes") == 0)
	zeromean = true;
    else
	zeromean = false;

    // Allocate space for model parameters
    model_trans = vector<vector<matrix<double> > >(nLev, 
						  vector<matrix<double> >() );
    model_mean = vector<vector<vector<double> > >(nLev, 
						 vector< vector<double> >() );
    model_stdv = vector<vector<vector<double> > >(nLev, 
						 vector< vector<double> >() );
    for(i=0; i<nLev; i++){
      model_trans[i] = vector< matrix<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
						matrix<double>(M,M));
      model_mean[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
      model_stdv[i] = vector< vector<double> >((int)pow(2.0,levndir[i]
							 -levndir[0]), 
					       vector<double>(M));
    }

    // Initial probs
    fscanf(fp, "\n");
    for (m = 0; m < M; m++)
	fscanf(fp, "%lf ", &model_trans[0][0][m][0]);  
    fscanf(fp, "\n\n");
  
    // Trans prob
    for (J = 1; J < nLev; J++) 
    {
      for (m = 0; m < M; m++){
	for (mm = 0; mm < model_trans[J].size(); mm++)
	  {
	    for (n = 0; n < M; n++)
	      fscanf(fp, "%lf ", &model_trans[J][mm][m][n]);
	  }

	fscanf(fp, "\n");
      }
    }
    fscanf(fp, "\n");

    // Mean
    if (zeromean)
    {
        for (J = 0; J < nLev; J++){
	  for (mm=0; mm<model_mean[J].size(); mm++)
	    for (m = 0; m < M; m++) 
		model_mean[J][mm][m] = 0.0;
	}
    }
    else
    {
	for (J = 0; J < nLev; J++)
	{
	  for (mm=0; mm<model_mean[J].size(); mm++)
	    for (m = 0; m < M; m++) 
		fscanf(fp, "%lf ", &model_mean[J][mm][m]);
	    
	  fscanf(fp, "\n");
	}
	fscanf(fp, "\n");
    }

    // Standard deviation
    for (J=0; J < nLev; J++)
    {
      for (mm=0; mm<model_stdv[J].size(); mm++)
	for (m = 0; m < M; m++) 
	    fscanf(fp, "%lf ", &model_stdv[J][mm][m]);
	  
      fscanf(fp, "\n");
    }
    fscanf(fp, "\n");

    startpos = ftell(fp);
   
    fclose(fp);

    subbandtree = tree<int> (1, nCh, nLev, 0);
    // setting up the subbandtree tree
    for(J = 1; J<nLev-1; J++)
      for(i=0; i<subbandtree[J].size(); i++) 
	if(J%2==0)
	  for(k=0; k<nCh; k++)
	    subbandtree[J+1][i*nCh+k] = subbandtree[J][i];
	else
	  for(k=0; k<nCh; k++)
	    if (k<nCh/2)
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2;
	    else
	      subbandtree[J+1][i*nCh+k] = subbandtree[J][i]*2+1;
}


//-----------------------------------------------------------------------------
void THMT::allocate_training()
{
    int i, J, k;

    if (alpha.nlev() == 0)		// avoid re-allocate
      {
	alpha = 
	    tree< vector<double> > (1, nCh, nLev, vector<double>(M));
	beta = beta_par = 
	    tree< vector<double> > (1, nCh, nLev, vector<double>(M));
	state_prob = tree< vector<double> > (nObs, nCh, nLev, 
					     vector<double>(M));
	scaling = tree<double> (1, nCh, nLev);
	sum_prob = sum_mean = sum_stdv = 
	    vector< vector< vector<double> > >(nLev, vector< vector<double> >());

	sum_trans = 
	  vector< vector< matrix<double> > > 
	  (nLev, vector<matrix<double> >());

	for(i=0; i<nLev; i++) {
	    sum_prob[i] = vector< vector<double> >(model_stdv[i].size(), 
						   vector<double>(M));	
	    sum_mean[i] = vector< vector<double> >(model_stdv[i].size(), 
						   vector<double>(M));
	    sum_stdv[i] = vector< vector<double> >(model_stdv[i].size(), 
						   vector<double>(M));
	    sum_trans[i] = vector< matrix<double> >(model_stdv[i].size(), 
						    matrix<double>(M, M)); 
	}
    }    
}  


//-----------------------------------------------------------------------------
void THMT::allocate_testing()
{
    int i, J, k;

    if (beta.nlev() == 0)		// avoid re-allocate
    {
	beta = beta_par = 
	    tree< vector<double> > (1, nCh, nLev, vector<double>(M));
	scaling = tree<double> (1, nCh, nLev);
    }
}


//-----------------------------------------------------------------------------
void THMT::compute_beta(int ob_ind)
{
    register int J, nNode, i, m, mm, n, c;
    register double o;
    register double sum, prod;
  

    // Initialization of beta down-tree
    J = nLev - 1;				// finest scale

    for (i = 0, nNode = beta[J].size(); i < nNode; i++)
    {
	// o_{J,i}^{ob_ind}
	o = (*obs)[J][ob_ind * ipow(nCh,J) + i];

	mm = subbandtree[J][i];

	for (m = 0; m < M; m++) 
	  beta[J][i][m] = compute_g(o, model_mean[J][mm][m], 
				      model_stdv[J][mm][m]);
    } // end initialization

    // Rescale beta
    rescale(J);

    while (J > 0) 
    {
	// Compute $\beta_{i,p(i)}$
	for (i = 0, nNode = beta_par[J].size(); i < nNode; i++) 
	{   
	  mm = subbandtree[J][i];
	  for (m = 0; m < M; m++) 
	    {
	      sum = 0.0;
		
	      for (n = 0; n < M; n++)
		sum += model_trans[J][mm][n][m] * beta[J][i][n];

	      beta_par[J][i][m] = sum;
	    }
	}

	// Compute $\beta_{p(i)}(m)$
	J--;
	for (i = 0, nNode = beta[J].size(); i < nNode; i++) 
	{
	    // o_{J,i}^{ob_ind}
	    o = (*obs)[J][ob_ind * ipow(nCh,J) + i];
	    mm = subbandtree[J][i];

	    for (m = 0; m < M; m++) 
	    {
		prod = compute_g(o, model_mean[J][mm][m], 
				 model_stdv[J][mm][m]);

		for (c = 0; c < nCh; c++)  // look for child of $p(i)$
		    prod *= beta_par[J+1][i*nCh+c][m];

		beta[J][i][m] = prod;
	    }
	}

	// Rescale $\beta_{p(i)}(m)$
	rescale(J);
    }
}


//-----------------------------------------------------------------------------
void THMT::rescale(int J)
{
    register int i, m, nNode = beta[J].size();
    register double sum;

    // Rescale for each node in this level (J)
    for (i = 0; i < nNode; i++) 
    {
	sum = 0.0;

	for (m = 0; m < M; m++) 
	    sum += beta[J][i][m];
    
	scaling[J][i] = sum;

	for (m = 0; m < M; m++) 
	    beta[J][i][m] /= sum;
    }
}

//-----------------------------------------------------------------------------
void THMT::compute_alpha()
{
    register int J, i, m, mm, n, nNode;
    register double sum;

    // Initialize the coarsest level
    for (m = 0; m < M; m++)
	alpha[0][0][m] = model_trans[0][0][m][0];

    for (J = 1; J < nLev; J++) 
    {
	for (i = 0, nNode = alpha[J].size(); i < nNode; i++) 
	{
	  mm = subbandtree[J][i];
	  for (m = 0; m < M; m++) 
	    {
	      sum = 0.0;

	      for (n = 0; n < M; n++) 
		sum += model_trans[J][mm][m][n] *
		  alpha[J-1][i/nCh][n] *
		  beta[J-1][i/nCh][n] /
		  beta_par[J][i][n];

		alpha[J][i][m] = sum;
	    } // end for m
	} // end for i
    } // end for J
}


//-----------------------------------------------------------------------------
double THMT::compute_likelihood()
{
    register int J, i, nNode, m;
    register double f;
    register double log_scale;

    for (m = 0, f = 0.0; m < M; m++)
	f += beta[0][0][m] * model_trans[0][0][m][0];

    // Re-scale back using saved scaling factors
    for (J = 0, log_scale = 0.0; J < nLev; J++)
	for (i = 0, nNode = scaling[J].size(); i < nNode; i++) 
	    log_scale += log(scaling[J][i]);

    // Final result
    return (log_scale + log(f));
}


//-----------------------------------------------------------------------------
void THMT::update_model(double& delta, double& avf)
{
    register int J, MM, i, m, mm, n, nNode;
    register int ob_ind;           // observation index
    register double o, denom, prob1, prob2, newval;

    // Reinitialize
    delta = avf = 0.0;

    for (J = 0; J < nLev; J++)
      for (mm=0; mm<sum_prob[J].size(); mm++)
	for (m = 0; m < M; m++) 
	{
	    sum_prob[J][mm][m] = 0.0;
	    sum_mean[J][mm][m] = 0.0;
	    sum_stdv[J][mm][m] = 0.0;

	    for (n = 0; n < M; n++)
	      sum_trans[J][mm][m][n] = 0.0;
	}
  
    // For each training tree
    for (ob_ind = 0; ob_ind < nObs; ob_ind++) 
    {
	// Compute $\alpha, \beta$
	compute_beta(ob_ind);
	compute_alpha();

	// Denominator for restimated probs
	denom = 0.0;
	for (m = 0; m < M; m++)
	    denom += beta[0][0][m] * alpha[0][0][m];

	// Compute state probabilities for denoising
	for (J = 0; J < nLev; J++)
	    for (i = 0, nNode = alpha[J].size(); i < nNode; i++)
	      for (m = 0; m < M; m++)
		{
		  state_prob[J][ob_ind*ipow(nCh,J)+i][m] = 
		    alpha[J][i][m]*beta[J][i][m]/denom;
		}

	// Update total log-likelihood
	avf += compute_likelihood();

	for (J = 0; J < nLev; J++)
       	    for (i = 0, nNode = alpha[J].size(); i < nNode; i++) 
      	    {
	        // o_{J,i}^{ob_ind}
       		o = (*obs)[J][ob_ind * ipow(nCh,J) + i];

       		for (m = 0; m < M; m++) 
    		{
		    // Compute $prob(S_i | O)$
       		    prob1 = alpha[J][i][m] * beta[J][i][m]
       			/ denom;

		    mm = subbandtree[J][i];
		    // Summing for all trees
       		    sum_prob[J][mm][m] += prob1;
       		    sum_mean[J][mm][m] += o * prob1;
       		    sum_stdv[J][mm][m] += (o - model_mean[J][mm][m]) *
       			(o - model_mean[J][mm][m]) *
       			prob1;
       		}
      	    }

	for (J = 1; J < nLev; J++)
	    for (i = 0, nNode = alpha[J].size(); i < nNode; i++)
		for (m = 0; m < M; m++)
		    for (n = 0; n < M; n++) 
		    {
		        mm = subbandtree[J][i];
			// Compute $prob(S_i, S_{p(i) | O)$
			prob2 = beta[J][i][m] *
			  model_trans[J][mm][m][n] *
			  alpha[J-1][i/nCh][n] *
			  beta[J-1][i/nCh][n] /
			  beta_par[J][i][n]
			  / denom;
			sum_trans[J][mm][m][n] += prob2;
		    }

    } // end ob_ind

    // Average log-likelihood
    avf = avf / double(nObs);

    // Normalize and update model parameters
    for (J = 0; J < nLev; J++)
      for (mm = 0; mm < model_stdv[J].size(); mm++)
	for (m = 0; m < M; m++) 
	{
	    if (!zeromean)	// Only update means for non-zeromean model
	    {
		newval = sum_mean[J][mm][m] / sum_prob[J][mm][m];
		delta += fabs(newval - model_mean[J][mm][m]);
		model_mean[J][mm][m] = newval;
	    }

	    newval = sqrt(sum_stdv[J][mm][m] / sum_prob[J][mm][m]);
	    delta += fabs(newval - model_stdv[J][mm][m]);
	    model_stdv[J][mm][m] = newval;
	}

    //state probs 
    for (m = 0; m < M; m++) 
    {
	newval = sum_prob[0][0][m] / nObs;
	delta += fabs(newval - model_trans[0][0][m][0]);
	model_trans[0][0][m][0] = newval;
    }

    // And transition probs 
    for (J = 1; J < nLev; J++){
      for (mm=0; mm < model_trans[J].size(); mm++)
	for (m = 0; m < M; m++)
	    for (n = 0; n < M; n++) 
	    {
	      if (sum_prob[J].size()>sum_prob[J-1].size())
		newval = sum_trans[J][mm][m][n] / sum_prob[J-1][mm/2][n]
		  /(nCh/2);
	      else
		newval =sum_trans[J][mm][m][n] / sum_prob[J-1][mm][n]/nCh;
	      delta += fabs(newval - model_trans[J][mm][m][n]);
	      model_trans[J][mm][m][n] = newval;
	    }
    }
}

//-----------------------------------------------------------------------------
void THMT::reorder_model()
{
  int level, dir, state, state2, largeststate, k;
  double largeststdv, tempdouble;

  // for each node
  for(level = 0; level < nLev; level++){
    for(dir = 0; dir < model_stdv[level].size(); dir++) {
      for(state=0; state<M-1; state++) {
	// initialize
	largeststdv = -1;
	largeststate = M;
	for(state2=state; state2<M; state2++){
	  // search for the state with the largest standard deviation
	  if (model_stdv[level][dir][state2]>largeststdv){
	    largeststdv = model_stdv[level][dir][state2];
	    largeststate = state2;
	  }
	}

	// if the current state is not the state with the largest stdv, then
	// need to swap the order
	if(largeststate != state){

	  // swap the order of the stdv
	  model_stdv[level][dir][largeststate] = model_stdv[level][dir][state];
	  model_stdv[level][dir][state] = largeststdv;

	  // swap the order of the mean
	  if (!zeromean) {
	    tempdouble = model_mean[level][dir][largeststate];
	    model_mean[level][dir][largeststate] = model_mean[level][dir]
	      [state];
	    model_mean[level][dir][state] = tempdouble;
	  }

	  // swap the order of the transition matrix with parent
	  for(k=0; k<M; k++){
	    tempdouble = model_trans[level][dir][largeststate][k];
	    model_trans[level][dir][largeststate][k] = model_trans[level][dir]
	      [state][k];
	    model_trans[level][dir][state][k] = tempdouble;
	  }

	  // swap the order of the transition matrix with children if this
	  // is not a leaf node
	  if(level != nLev-1){
	    if(model_trans[level].size()==model_trans[level+1].size())
	      for(k=0; k<M; k++){
		tempdouble = model_trans[level+1][dir][k][largeststate];
		model_trans[level+1][dir][k][largeststate] = 
		  model_trans[level+1][dir][k][state];
		model_trans[level+1][dir][k][state] = tempdouble;
	      }
	    else if (model_trans[level].size()*2==model_trans[level+1].size())
	      for (k=0; k<M; k++){
		tempdouble =model_trans[level+1][2*dir][k][largeststate];
		model_trans[level+1][2*dir][k][largeststate] = 
		  model_trans[level+1][2*dir][k][state];
		model_trans[level+1][2*dir][k][state] = tempdouble;

		tempdouble =model_trans[level+1][2*dir+1][k][largeststate];
		model_trans[level+1][2*dir+1][k][largeststate] = 
		  model_trans[level+1][2*dir+1][k][state];
		model_trans[level+1][2*dir+1][k][state] = tempdouble;
	      } 
	  }
	}
      }
    }   
  }

}

//-----------------------------------------------------------------------------
void THMT::batch_train(tree<double> *trainTree, double min_delta)
{
  
    // Assign data pointer
    obs = trainTree;
    // Train HMT model
    train_all(min_delta);
}


//-----------------------------------------------------------------------------
void THMT::train_all(double min_delta)
{
    register int count = 0, J, i, m, nNode;
    register double delta = min_delta;
    register double avf;
    register double last_avf = -10e6;
 
    if (obs->nlev() == 0)
      mexErrMsgTxt("ERROR in THMT::train_all(): empty training data");
    if ((obs->nlev() != nLev) || (obs->nch() != nCh))
      mexErrMsgTxt("ERROR in THMT::train_all(): incompatible training data");

    nObs = obs->nrt();

    // Allocate space for training
    allocate_training();

    while ((delta >= min_delta) && (count++ <= MAX_ITR)) 
    {
	update_model(delta, avf);

	//if (avf < last_avf){
	//  mexWarnMsgTxt("WARNING: Log-likelihood decreases in training!");
	//  break;
	//}

	last_avf = avf;

	//#ifdef DEBUG
	//mexPrintf("count = %d\ndelta = %f\navf = %f\n", count, delta, avf);
	//#endif
    }

    // change the model so that the state 1 always has the largest variance
    // state 2 the second, and so on.....
    //reorder_model();

    mexPrintf("done batch-train:\ncount = %d\ndelta = %f\navf = %f\n", 
	      count, delta, avf);
}


//-----------------------------------------------------------------------------
double THMT::batch_test(tree<double> *testTree)
{
    // Assign data pointer

  obs = testTree;
 
  // Compute average log-likelihood
  return test_all();
}


//-----------------------------------------------------------------------------
double THMT::batch_test(char *filename)
{
    // Read data from file
    obs = new tree<double> (filename);

    // Compute average log-likelihood
    double avf = test_all();

    // Delete data
    delete obs;

    return avf;
}


//-----------------------------------------------------------------------------
double THMT::test_all()
{
    register int ob_ind;
    register double f, sumf = 0.0;
    
    
    if (obs->nlev() == 0)
    {
      //cerr << "ERROR in THMT::test_all(): empty data"
      //     << endl;
	return 0.0;
    }
    
   
    if ((obs->nlev() != nLev) || (obs->nch() != nCh))
    {
      //cerr << "ERROR in THMT::test_all(): incompatible data"
      //	     << endl;
	return 0.0;
    }
  
    nObs = obs->nrt();
  
    // Allocate space for training
    allocate_testing();

    for (ob_ind = 0; ob_ind < nObs; ob_ind++) 
    {
	compute_beta(ob_ind);
	f = compute_likelihood();

	//#ifdef DEBUG
	//cout << "ob_ind = " << ob_ind << "\tf = " << f << endl;
	//#endif

	sumf += f;
    }

    return (sumf / double(nObs));
}


//-----------------------------------------------------------------------------
void THMT::rnd_init_model()
{
    const double MAX_MEAN = 100.0;
    const double MAX_STDV = 100.0;
    register int J, MM, m, mm, n;
    double temp;
    vector<double> vprob(M);
    int idum = -time(NULL);    // random seed

    for (J = 0; J < nLev; J++){
      for (mm=0; mm<model_mean[J].size(); mm++)
	for (m = 0; m < M; m++) 
	  {
	    if (zeromean)
	      model_mean[J][mm][m] = 0.0;
	    else
	      model_mean[J][mm][m] = (2.0*ran1(idum) - 1.0) * MAX_MEAN;
	    model_stdv[J][mm][m]  = ran1(idum) * MAX_STDV;

	    ranprobs(vprob, idum);
	    for (n = 0; n < M; n++)
	      model_trans[J][mm][n][m] = vprob[n];
	  }
    }
    
}


//-----------------------------------------------------------------------------
void THMT::generate_data(tree<double>&obs, int n)
{
  tree<double> aTree(1, nCh, nLev);
  register int ob_ind, J;
  int idum = -time(NULL);     // random seed

  // Resize output tree if necessary
  if ((obs.nlev() != nLev) || (obs.nch() != nCh) || (obs.nrt() != n))
    obs = tree<double>(n, nCh, nLev);
  
  for (ob_ind = 0; ob_ind < n; ob_ind++) {
    generate_one(aTree, idum);
    
    for (J = 0; J < nLev; J++)
      copy(aTree[J].begin(), aTree[J].end(),
	   obs[J].begin() + ob_ind * ipow(nCh,J));
  }
}


//-----------------------------------------------------------------------------
void THMT::generate_data(char *filename, int n)
{
    tree<double> genTree(n, nCh, nLev);
    tree<double> aTree(1, nCh, nLev);
    register int ob_ind, J;
    int idum = -time(NULL);     // random seed

    for (ob_ind = 0; ob_ind < n; ob_ind++) {
	generate_one(aTree, idum);

	for (J = 0; J < nLev; J++)
	    copy(aTree[J].begin(), aTree[J].end(),
		 genTree[J].begin() + ob_ind * ipow(nCh,J));
    }

    genTree.dump(filename);
}


//-----------------------------------------------------------------------------
void THMT::generate_one(tree<double> &aTree, int& idum)
{
    tree<int> states(1, nCh, nLev);
    vector<double> vprob(M);
    register int J, i, nNode, m, mm;
    register double mean, stdv;

    // Initial state
    for (m = 0; m < M; m++)
	vprob[m] = model_trans[0][0][m][0];
    
    states[0][0] = ranind(vprob, idum);

    mean = model_mean[0][0][states[0][0]];
    stdv = model_stdv[0][0][states[0][0]];
    aTree[0][0] = mean + stdv * rangas(idum);
  
    // All others
    for (J = 1; J < nLev; J++) 
    {
	for (i = 0, nNode = aTree[J].size(); i < nNode; i++) 
	{
	  mm = subbandtree[J][i];

	  // build vector prob
	  for (m = 0; m < M; m++)
	    vprob[m] = model_trans[J][mm][m][states[J-1][i/nCh]];

	  states[J][i] = ranind(vprob, idum);
	  mean = model_mean[J][mm][states[J][i]];
	  stdv = model_stdv[J][mm][states[J][i]];
	  aTree[J][i] = mean + stdv * rangas(idum);
	}
    }
}


//-----------------------------------------------------------------------------
void THMT::generate_one(tree<double> &aTree, int& idum, double initval)
{
    tree<int> states(1, nCh, nLev);
    vector<double> vprob(M);
    register int J, i, nNode, m,mm;
    register double mean, stdv;

    aTree[0][0] = initval;

    /********* WRONG!!!
    // Find initial states from given initial value
    for (m = 0; m < M; m++)
	vprob[m] = model_trans[0][m][0] *
	    compute_g(initval, model_mean[0][m], model_stdv[0][m]);

    // It is the state with highest probability
    states[0][0] = 0;
    double maxprob = vprob[0];

    for (m = 1; m < M; m++)
    {
	if (vprob[m] > maxprob)
	{
	    states[0][0] = m;
	    maxprob = vprob[m];
	}
    }
    **********/

    /***** HACK (before the end of the Millennium!!!) *****/
    if (M != 2)
      mexErrMsgTxt("Only works for 2 states");

    int smallState = (model_stdv[0][0][0] < model_stdv[0][0][1]) ? 0 : 1;

    // Cumunative probability
    double cumprob = 0.0;
    for (m = 0; m < M; m++)
	cumprob += model_trans[0][0][m][0] *
	    Psi(fabs(initval - model_mean[0][0][m]) / model_stdv[0][0][m]);

    if (cumprob > (0.5 + 0.5 * model_trans[0][0][smallState][0]))
	states[0][0] = smallState;
    else
	states[0][0] = 1 - smallState;	// largeState

    /***** END HACK *****/

  
    // All others
    for (J = 1; J < nLev; J++) 
    {
	for (i = 0, nNode = aTree[J].size(); i < nNode; i++) 
	{
	  mm = subbandtree[J][i];

	  // build vector prob
	  for (m = 0; m < M; m++)
	    vprob[m] = model_trans[J][mm][m][states[J-1][i/nCh]];

	  states[J][i] = ranind(vprob, idum);
	  mean = model_mean[J][mm][states[J][i]];
	  stdv = model_stdv[J][mm][states[J][i]];
	  aTree[J][i] = mean + stdv * rangas(idum);
	}
    }

}


//-----------------------------------------------------------------------------
tree<double>* THMT::denoise(double nvar, tree<double>* source, 
			    const mxArray* stateprob)
{
  double temp = 0, *doubleptr;
  int J, i, m, mm, nNode;
  mxArray* stateprobcell;

  // Read data from file
  obs = new tree<double> (*source);
  nObs = obs->nrt();

  state_prob = tree< vector<double> >(nObs, nCh, nLev, 
				      vector<double>(M));
  for (J=0; J<nLev; J++){
    stateprobcell = mxGetCell(stateprob, J);
    doubleptr = mxGetPr(stateprobcell);
    for (i = 0, nNode = state_prob[J].size(); i < nNode; i++) {
      for (m = 0; m < M; m++){
	state_prob[J][i][m] = doubleptr[m*nNode+i];
      }
    }
  }
 
  for (J = 0; J < nLev; J++) {
    for (i = 0, nNode = state_prob[J].size(); i < nNode; i++) {
      mm = subbandtree[J][i%ipow(nCh,J)];
      for (m = 0; m < M; m++){
	temp += state_prob[J][i][m]*model_stdv[J][mm][m]*model_stdv[J][mm][m]
	  /(nvar+model_stdv[J][mm][m]*model_stdv[J][mm][m]);
      }
      (*obs)[J][i] = (*obs)[J][i]*temp;
      temp = 0;
    }
  }

  return obs;
}

//-----------------------------------------------------------------------------
void THMT::dump_model(char *filename)
{
    FILE *fp;
    register int J, MM, m, mm, n;

    fp = fopen(filename,"a");
    if (!fp) 
      mexErrMsgTxt("ERROR: can not open for writing");

    fprintf(fp, "nStates: %d\n", M);

    fprintf(fp, "nLevels: %d\n", nLev);

    if (zeromean)
	fprintf(fp, "zeroMean: yes\n");
    else 
	fprintf(fp, "zeroMean: no\n");

    // Initial probs
    fprintf(fp, "\n");
    for (m = 0; m < M; m++)
	fprintf(fp, "%f ", model_trans[0][0][m][0]);
    fprintf(fp, "\n\n");

    // Trans probs
    for (J =  1; J < nLev; J++)
    { 
      for (m = 0; m < M; m++){
	for (mm = 0; mm < model_trans[J].size(); mm++) 
	    for (n = 0; n < M; n++)
	      fprintf(fp, "%f ", model_trans[J][mm][m][n]);
	fprintf(fp, "\n");
      }
      fprintf(fp, "\n");
    }
    fprintf(fp, "\n");

    // Mean
    if (!zeromean){
	for (J = 0; J < nLev; J++)
	{
	  for (mm=0; mm < model_mean[J].size(); mm++)
	    for (m=0; m<M; m++)
	      fprintf(fp, "%f ", model_mean[J][mm][m]);

	  fprintf(fp, "\n");
	}
	fprintf(fp, "\n");
    }

    // Standard deviation
    for (J =  0; J < nLev; J++)
    {
      for (mm=0; mm < model_stdv[J].size(); mm++)
	for (m = 0; m < M; m++) 
	    fprintf(fp, "%f ", model_stdv[J][mm][m]);
	  
      fprintf(fp, "\n");
    }
    fprintf(fp, "\n");

    fclose(fp);
}

//-----------------------------------------------------------------------------
void THMT::dump_model_struct(const mxArray* model)
{
    double* doubleptr;
    mxArray* pointer, *pointer2, *pointer3, *assignptr;
    int numfields, numels;
    register int J, MM, m, mm, n;

    numfields = mxGetNumberOfFields(model);
    numels = mxGetNumberOfElements(model);
    if (((numfields != 6) && (zeromean)) || 
	((numfields != 7) && (!zeromean)))
      mexErrMsgTxt("ERROR: number of fields in struct model is incorrect");

    if (numels != 1)
      mexErrMsgTxt("ERROR: Too many elements");

    if (strcmp(mxGetFieldNameByNumber(model, 0), "nstates") != 0)
      mexErrMsgTxt("Field 0 has wrong name");

    pointer = mxGetFieldByNumber(model, 0, 0);
    doubleptr = mxGetPr(pointer);
    *doubleptr = (double)M;

    if (strcmp(mxGetFieldNameByNumber(model, 1), "nlevels") != 0)
      mexErrMsgTxt("Field 1 has wrong name");    

    pointer = mxGetFieldByNumber(model, 0, 1);
    doubleptr = mxGetPr(pointer);
    *doubleptr = (double)nLev;

    if (strcmp(mxGetFieldNameByNumber(model, 2), "zeromean") != 0)
      mexErrMsgTxt("Field 2 has wrong name");
    if (zeromean){
        assignptr = mxCreateString("yes");
        mxSetFieldByNumber((mxArray*)model, 0, 2, assignptr);
    }
    else {
        assignptr = mxCreateString("no");
        mxSetFieldByNumber((mxArray*)model, 0, 2, assignptr);
    }

    if (strcmp(mxGetFieldNameByNumber(model, 3), "rootprob") != 0)
      mexErrMsgTxt("Field 3 has wrong name");
    pointer = mxGetFieldByNumber(model, 0, 3);
    if (pointer == NULL) {
      mexPrintf("%s%d\n",
    		"FIELD:", 3);
      mexErrMsgTxt("Above field is empty!"); 
    }
    doubleptr = mxGetPr(pointer);
    for (m = 0; m < M; m++)
        doubleptr[m] = model_trans[0][0][m][0];
 
    if (strcmp(mxGetFieldNameByNumber(model, 4), "transprob") != 0)
      mexErrMsgTxt("Field 4 has wrong name");
    pointer = mxGetFieldByNumber(model, 0, 4);
    if (pointer == NULL) {
      mexPrintf("%s%d\n",
    		"FIELD:", 4);
      mexErrMsgTxt("Above field is empty!"); 
    }

    // Trans probs
    for (J =  1; J < nLev; J++)
    { 
      pointer2 = mxGetCell(pointer,J-1);
      for (m = 0; m < M; m++){
	for (mm = 0; mm < model_trans[J].size(); mm++) {
	    pointer3 = mxGetCell(pointer2, mm);
	    doubleptr = mxGetPr(pointer3);
	    for (n = 0; n < M; n++)
	      doubleptr[n*M+m] = model_trans[J][mm][m][n];
	}
      }
    }

    // Mean
    if (!zeromean)
    {
        if (strcmp(mxGetFieldNameByNumber(model, 5), "mean") != 0)
	  mexErrMsgTxt("Field 5 has wrong name");
        pointer = mxGetFieldByNumber(model, 0, 5);
	if (pointer == NULL) {
	  mexPrintf("%s%d\n",
		    "FIELD:", 5);
	  mexErrMsgTxt("Above field is empty!");
	}
	for (J = 0; J < nLev; J++)
	{
	  pointer2 = mxGetCell(pointer, J);
	  for (mm=0; mm < model_mean[J].size(); mm++){
	    pointer3 = mxGetCell(pointer2, mm);
	    doubleptr = mxGetPr(pointer3);
	    for (m=0; m<M; m++)
	      doubleptr[m] = model_mean[J][mm][m];
	  }
	}
    }

    if(!zeromean){
      if (strcmp(mxGetFieldNameByNumber(model, 6), "stdv") != 0)
	mexErrMsgTxt("Field 6 has wrong name");
      pointer = mxGetFieldByNumber(model, 0, 6);
      if (pointer == NULL) {
	mexPrintf("%s%d\n",
		  "FIELD:", 6);
	mexErrMsgTxt("Above field is empty!");
      }
    }
    else{
      if (strcmp(mxGetFieldNameByNumber(model, 5), "stdv") != 0)
	mexErrMsgTxt("Field 5 has wrong name");
      pointer = mxGetFieldByNumber(model, 0, 5);
      if (pointer == NULL) {
	mexPrintf("%s%d\n",
		  "FIELD:", 5);
	mexErrMsgTxt("Above field is empty!");
      } 
    }

    // Standard deviation
    for (J =  0; J < nLev; J++)
    {
      pointer2 = mxGetCell(pointer, J);
      for (mm=0; mm < model_stdv[J].size(); mm++){
	pointer3 = mxGetCell(pointer2, mm);
	doubleptr = mxGetPr(pointer3);
	for (m = 0; m < M; m++) 
	    doubleptr[m] = model_stdv[J][mm][m];
      }
    }
}

//-----------------------------------------------------------------------------
void THMT::dump_state_prob(const mxArray* stateprob)
{
    int i, J, m, nNode;
    mxArray* tempptr;
    double* dataptr;

    for (J=0; J<nLev; J++){
      tempptr = mxGetCell(stateprob, J);
      dataptr = mxGetPr(tempptr);
      for (i = 0, nNode = state_prob[J].size(); i < nNode; i++) 
	for (m = 0; m < M; m++)
	  dataptr[m*state_prob[J].size()+i] = state_prob[J][i][m];
    }
}  
//-----------------------------------------------------------------------------
double KLD_est(THMT model1, THMT model2, int nObservations)
{
    tree<double> genTree;
    double logden1, logden2;
    
    model1.generate_data(genTree, nObservations);

    logden1 = model1.batch_test(&genTree);
    logden2 = model2.batch_test(&genTree);
    
    return (logden1 - logden2);
}


//-----------------------------------------------------------------------------
// Compute the Kullback-Leibler distance between two discrete 
// probality mass functions
double KLD_disc(const vector<double>& prob1, const vector<double>& prob2)
{
    if (prob1.size() != prob2.size())
	cerr << "KLD_disc: Two probability vectors have different length"
	     << endl;

    double d = 0.0;

    for (int i = 0; i < prob1.size(); i++)
	if ((prob1[i] != 0.0) && (prob2[0] != 0.0))
	    d += prob1[i] * log(prob1[i] / prob2[i]);

    return d;
}


//-----------------------------------------------------------------------------
// Compute the Kullback-Leibler distance between two continuous 
// Gaussian probability desity functions
double KLD_gauss(double mean1, double stdv1, double mean2, double stdv2)
{
    double r1 = stdv1 / stdv2;
    double r2 = (mean1 - mean2) / stdv2;

    return 0.5 * (-2*log(r1) - 1 + r1*r1 + r2*r2); 
}


//-----------------------------------------------------------------------------
double KLD_upb(THMT model1, THMT model2)
{
    int J, m, n, dir, maxdir;
    int M, nCh, nLev;
    double test_sum;
   
    M = model1.M;
    if (model2.M != M)
	mexErrMsgTxt("KLD_upb: Incompatible models.");

    nCh = model1.nCh;
    if (model2.nCh != nCh)
	mexErrMsgTxt("KLD_upb: Incompatible models.");

    nLev = model1.nLev;
    if (model2.nLev != nLev)
	mexErrMsgTxt("KLD_upb: Incompatible models.");

    // assume the lowest level has the largest number of directions
    maxdir = model1.model_stdv[nLev-1].size();


    vector<vector<double> > D(maxdir, vector<double>(M));
    vector<vector<double> > d(maxdir, vector<double>(M));
    vector<double> trans1(M);
    vector<double> trans2(M);
 
    // Initial: lowest level
    J = nLev - 1;
    for (dir = 0; dir < model1.model_stdv[J].size(); dir++){
      for (m = 0; m < M; m++)
	D[dir][m] = KLD_gauss(model1.model_mean[J][dir][m], 
			 model1.model_stdv[J][dir][m],
			 model2.model_mean[J][dir][m], 
			 model2.model_stdv[J][dir][m]);
    } 
      
    // DEBUG
    //mexPrintf("%s\n", "Lowest level: ");
    //for (dir = 0; dir < model1.model_stdv[J].size(); dir++)
    //  for (m = 0; m < M; m++)
    //	mexPrintf("%d %d %f \n", dir, m, D[dir][m]);

    // Induction:
    for (J = nLev-1; J > 0; J--) {
      for (dir = 0; dir < model1.model_stdv[J-1].size(); dir++){
	for (m = 0; m < M; m++) {

	  d[dir][m] = KLD_gauss(model1.model_mean[J-1][dir][m], 
				model1.model_stdv[J-1][dir][m],
				model2.model_mean[J-1][dir][m], 
				model2.model_stdv[J-1][dir][m]);
 
	  if ( model1.model_stdv[J].size() == model1.model_stdv[J-1].size()){
	    for (n=0; n<M; n++){
	      trans1[n] = model1.model_trans[J][dir][n][m];
	      trans2[n] = model2.model_trans[J][dir][n][m];
	    }
	    d[dir][m] += nCh * KLD_disc(trans1,trans2);
	  }
	  else if (model1.model_stdv[J].size() == 
		   2*model1.model_stdv[J-1].size()){
	    for (n=0; n<M; n++){
	      trans1[n] = model1.model_trans[J][dir*2][n][m];
	      trans2[n] = model2.model_trans[J][dir*2][n][m];
	    }

	    d[dir][m] += nCh/2 * KLD_disc(trans1,trans2);
	    for (n=0; n<M; n++){
	      trans1[n] = model1.model_trans[J][dir*2+1][n][m];
	      trans2[n] = model2.model_trans[J][dir*2+1][n][m];
	    }
	    d[dir][m] += nCh/2 * KLD_disc(trans1,trans2);
	  }
	  else
	    mexErrMsgTxt("Error: Multiple parents for one child");


	  for (n = 0; n < M; n++)
	    if ( model1.model_stdv[J].size() == model1.model_stdv[J-1].size())
	      d[dir][m] += nCh * model1.model_trans[J][dir][n][m] 
		* D[dir][n]; 
	    else {
	      d[dir][m] += nCh/2 * model1.model_trans[J][dir*2][n][m] 
		* D[dir*2][n];
	      d[dir][m] += nCh/2 * model1.model_trans[J][dir*2+1][n][m] 
		* D[dir*2+1][n];
	    }
	}
      }
      // DEBUG:

      //for (dir = 0; dir < model1.model_stdv[J-1].size(); dir++)
      //	for (m = 0; m < M; m++)
      //	  mexPrintf("%d %d %f %f\n", dir, m, D[dir][m], d[dir][m]);

      // updating the temporary distance vector D
      D = d;
    }
		 
    // Final:
    double dist;
    for (n=0; n<M; n++){
      trans1[n] = model1.model_trans[0][0][n][0];
      trans2[n] = model2.model_trans[0][0][n][0];
    }

    dist = KLD_disc(trans1, trans2);

    // DEBUG
    //mexPrintf("%s %f", "Final: KLD_disc = ", dist);

    for (m = 0; m < M; m++)
	dist += model1.model_trans[0][0][m][0] * D[0][m];

    return dist;		
}

/*********************************************************************
    TEMPLATES INSTANCIATION !!!
*************************************************************/
/*template class matrix<float>;

template class vector<double>;
template class tree<double>;
template class tree<int>;
template class tree<vector<double> >; */
