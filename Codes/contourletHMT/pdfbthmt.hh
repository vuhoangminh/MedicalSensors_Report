//-----------------------------------------------------------------------------
// pdfbthmt.hh  -  Tying Hidden Markov Tree Models For PDFB
//-----------------------------------------------------------------------------
// 
// Original by F. Worm, Jan-1999
//
// Modified by M. Do, Feb-1999
//
// Modified by D. Po, June-2002
//
// Description: Tying of HMT models parameters within each scale
//
// example modelfile:
//
// nStates: 2 (number of states)
// nLevels: 4 (number of tree levels)
// zeroMean: no (yes if all states at all levels are zero mean, no otherwise)
//         (empty line must be present)
// 0.6 0.4 (probability of first level to be in each state)
//         (empty line must be present)
// 0.8 0.2 (state transition probability, row number is the parent state,) 
// 0.2 0.8 (column number is the child state, first level to second)
//
// 0.7 0.3 (state transition prob, second level to third)
// 0.3 0.7
//
// 0.7 0.3 (state transition prob, second level to third)
// 0.3 0.7
//
// 0.7 0.3 (state transition prob, third to fourth)
// 0.3 0.7
//         (two empty lines must be present here to separate prob and mean/var)
//
// 0.0 0.0 (means, rows correspond to levels, columns correspond to states)
// 0.0 0.0
// 0.0 0.0 
// 0.0 0.0
//
// 40.0 160.0 (variances, rows correspond to levels, columns correspond to states)
// 20.0 80.0
// 10.0 40.0
// 05.0 20.0
//-----------------------------------------------------------------------------

#ifndef THMT_H
#define THMT_H

#include <vector>
#include "matrix.hh"                         
#include "tree.hh"
#include "mex.h"

// #define DEBUG
using std::vector;

const int    MAX_ITR = 1000;		// max number of iterations

class THMT {
    public:
	THMT(int ns, int nl, int* levndir, bool zm = false); // random model
	THMT(const mxArray* initmodel, int* levndir);		// model from file
        THMT(char *filename, int* levndir, long& startpos);

	// Batch train HMT model using data from a tree or file
	void batch_train(tree<double> *trainTree, 
			 double min_delta = 0.001);

	// Batch test against HMT model using data from a tree or file
	double batch_test(char *filename);
	double batch_test(tree<double> *testTree);

	// Generate random data based on the model
	void generate_one(tree<double> &aTree, int &idum);
	void generate_one(tree<double> &aTree, int &idum, double
	     	  initval);

	// Generate n trees	
	void generate_data(tree<double>& obs,int n);
	void generate_data(char *filename, int n); 

        // Denoise an image
        tree<double>* denoise(double nvar, tree<double>* source,
		     const mxArray* stateprob);
  
	// Save the model to file
	void dump_model(char *filename);

        // Save model into a struct
        void dump_model_struct(const mxArray* model);

        // Save State Prob for denoising
        void dump_state_prob(const mxArray* stateprob);

	// Estimate Kullback-Leibler distance using Monte-Carlo method
	friend double KLD_est(THMT model1, THMT model2, int nObservations);

	// Compute an upper bound of the Kullback-Leibler distance
	friend double KLD_upb(THMT model1, THMT model2);

    private:
	int M;				// number of states
        int nCh;                        // number of children
	int nLev;			// number of levels
	int nObs;			// number of observations

	bool zeromean;

	// model parameters (same for a certain scale - tying)
        vector< vector< matrix<double> > > model_trans;
        vector< vector< vector<double> > > model_mean;
        vector< vector< vector<double> > > model_stdv;

	// training data
	tree<double> *obs;		// pointer to the tree

	// variables for training & testing
	tree< vector<double> > alpha;
	tree< vector<double> > beta;
	tree< vector<double> > beta_par;
        tree< vector<double> > state_prob;  //this is used for denoising
	vector< vector < matrix<double> > > sum_trans;
        vector< vector< vector<double> > > sum_prob;
        vector< vector< vector<double> > > sum_mean;
        vector< vector< vector<double> > > sum_stdv;
	tree<double> scaling;		// scaling factor at each node
        tree<int> subbandtree;              // indicates which subbandtree 
                                        // coefficient belongs to

	// E-step: upward-downward for a single tree
	void compute_beta(int ob_ind);	// compute beta up-tree
	void compute_alpha();		// compute alpha down-tree

	// Rescale beta
	void rescale(int J);		// rescale beta at the given level

	// Compute log-likehood (using beta and scaling)
	double compute_likelihood();

	// M-step for multiple tress.  Return total adj. & likelihood
	void update_model(double& delta, double &avf); 

        // reorder the model so that the first state always has the largest
        // standard deviation
        void reorder_model();

	// Train HMT model from assigned data
	void train_all(double min_delta);

	// Compute average log-likelihood
	double test_all();

	// Random initializes model parameters
	void rnd_init_model();
	  
	// Allocate spaces
	void allocate_training();
	void allocate_testing();
};

#endif	// THMT_H
