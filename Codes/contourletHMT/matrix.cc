//-----------------------------------------------------------------------------
// matrix.cc
//-----------------------------------------------------------------------------

#include "matrix.hh"
#include <math.h>
#include <iostream>
#include <stdlib.h>

using std::cerr;
using std::endl;

// Numerical Recipes functions (for matrix inversion and determinant)
template <class T>
void ludcmp(matrix<T>& a, int n, vector<int>& indx, T& d);
template <class T>
void lubksb(matrix<T>& a, int n, vector<int>& indx, vector<T>& b);


//-----------------------------------------------------------------------------
template <class T>
matrix<T>::matrix(int nrow, int ncol, const T& value)
    : data(nrow, vector<T>(ncol, value))
{}


//-----------------------------------------------------------------------------
template <class T>
matrix<T>::matrix(const matrix<T>& aMatrix)
    :data(aMatrix.data.size()) 
{
    register int i, nrow = aMatrix.data.size();

    // Copy data
    for (i = 0; i < nrow; i++)
	data[i] = aMatrix.data[i];
}


//-----------------------------------------------------------------------------
template <class T>
matrix<T>& matrix<T>::operator = (const matrix<T>& aMatrix)
{
    register int i, nrow = aMatrix.data.size();
  
    if (this == &aMatrix)
	return *this;

    if (data.size() != nrow)
	data = vector< vector<T> > (nrow);   // resize data
  
    // Copy data
    for (i = 0; i < nrow; i++)
	data[i] = aMatrix.data[i];
  
    return *this;
}


//-----------------------------------------------------------------------------
template <class T>
matrix<T> matrix<T>::inv() const
{
    int n = data.size();

    if ((n <= 0) || (n != data[0].size()))
    {
	cerr << "Error: Non-square matrix in function matrix::inv()" 
	     << endl;
	exit(1);
    }

    matrix<T> tmp(*this);
    matrix<T> res(n, n);
    vector<T> col(n);
    vector<int> indx(n);
    T d;

    // LU decompose
    ludcmp(tmp, n, indx, d);	

    // Backsubstitution
    for (int j = 0; j < n; j++)
    {
	for (int i = 0; i < n; i++)
	    col[i] = 0.0;
	col[j] = 1.0;

	lubksb(tmp, n, indx, col);

	for (int i = 0; i < n; i++)
	    res[i][j] = col[i];
    }

    return res;
}


//-----------------------------------------------------------------------------
template <class T>
T matrix<T>::det() const
{
    int n = data.size();

    if ((n <= 0) || (n != data[0].size()))
    {
	cerr << "Error: Non-square matrix in function matrix::det()" 
	     << endl;
	exit(1);
    }

    matrix<T> tmp(*this);
    vector<int> indx(n);
    T d;
    
    ludcmp(tmp, n, indx, d);		// LU decompose
    for (int j = 0; j < n; j++)
	d *= tmp[j][j];

    return d;
}


//-----------------------------------------------------------------------------
// Numerical Recipes Routines (modified)
//-----------------------------------------------------------------------------
#define TINY 1.0e-20;

// LU Decomposition
template <class T>
void ludcmp(matrix<T>& a, int n, vector<int>& indx, T& d)
{
    int i, imax, j, k;
    T big, dum, sum, temp;

    vector<T> vv(n); 	// stores the implicit scaling of each row

    d = 1.0;
    for (i = 0; i < n; i++) 
    {
	big = 0.0;
	for (j = 0; j < n; j++)
	    temp = (a[i][j] >= 0) ? a[i][j] : -a[i][j];
	    if (temp > big)
		big = temp;

	if (big == 0.0)
	{
	    cerr << "Error: Singular matrix in routine ludcmp" << endl;
	    return;
	}

	vv[i] = 1.0 / big;
    }

    for (j = 0; j < n; j++) 
    {
	for (i = 0; i < j; i++) 
	{
	    sum = a[i][j];
	    for (k = 0; k < i; k++)
		sum -= a[i][k] * a[k][j];

	    a[i][j] = sum;
	}

	big = 0.0;
	for (i = j; i < n; i++) 
	{
	    sum = a[i][j];
	    for (k = 0; k < j; k++)
		sum -= a[i][k] * a[k][j];

	    a[i][j] = sum;

	    dum = (sum >= 0) ? sum : -sum;
	    dum *= vv[i];
	    if (dum >= big) 
	    {
		big = dum;
		imax = i;
	    }
	}

	if (j != imax) 
	{
	    for (k = 0; k < n; k++) 
	    {
		dum = a[imax][k];
		a[imax][k] = a[j][k];
		a[j][k] = dum;
	    }

	    d = -d;
	    vv[imax] = vv[j];
	}

	indx[j] = imax;
	if (a[j][j] == 0.0) a[j][j]=TINY;

	if (j != (n-1)) 
	{
	    dum = 1.0 / (a[j][j]);
	    for (i = j+1 ; i < n;i++) 
		a[i][j] *= dum;
	}
    }
}


// LU forward substitution and backsubstitution
template <class T>
void lubksb(matrix<T>& a, int n, vector<int>& indx, vector<T>& b)
{
    int i, ii = -1, ip, j;
    T sum;

    for (i = 0; i < n; i++) 
    {
	ip = indx[i];
	sum = b[ip];
	b[ip] = b[i];
	if (ii >= 0)
	    for (j = ii; j < i; j++)
		sum -= a[i][j] * b[j];
	else if (sum) ii = i;
	b[i] = sum;
    }

    for (i = n-1; i >= 0; i--) 
    {
	sum = b[i];
	for (j = i+1; j < n; j++)
	    sum -= a[i][j] * b[j];

	b[i] = sum / a[i][i];
    }
}

#undef TINY

template class matrix<double>;
