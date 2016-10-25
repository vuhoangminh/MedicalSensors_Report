//-----------------------------------------------------------------------------
// utils.cc
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "utils.hh"


/*---------------------------------------------------------------------------*/
int ipow(int n, int j)
{
    register int i, res;
  
    res = 1;
    for (i = 0; i < j; i++)
	res *= n;

    return res;
}


/*-----------------------------------------------------------------------*/
// For random generator (Numerical Recipe book)
#define IA 16807
#define IM 2147483647
#define AM (1.0/IM)
#define IQ 127773
#define IR 2836
#define NTAB 32
#define NDIV (1+(IM-1)/NTAB)
#define EPS 1.2e-7
#define RNMX (1.0-EPS)

double ran1(int& idum)
{
    int j;
    int k;
    static int iy=0;
    static int iv[NTAB];
    double temp;

    if (idum <= 0 || !iy) {
	if (-(idum) < 1) idum=1;
	else idum = -(idum);
	for (j=NTAB+7;j>=0;j--) {
	    k=(idum)/IQ;
	    idum=IA*(idum-k*IQ)-IR*k;
	    if (idum < 0) idum += IM;
	    if (j < NTAB) iv[j] = idum;
	}
	iy=iv[0];
    }
    k=(idum)/IQ;
    idum=IA*(idum-k*IQ)-IR*k;
    if (idum < 0) idum += IM;
    j=iy/NDIV;
    iy=iv[j];
    iv[j] = idum;
    if ((temp=AM*iy) > RNMX) return RNMX;
    else return temp;
}


/*-----------------------------------------------------------------------*/
double rangas(int& idum)
{
    static int iset=0;
    static double gset;
    double fac,rsq,v1,v2;

    if  (iset == 0) {
	do {
	    v1=2.0*ran1(idum)-1.0;
	    v2=2.0*ran1(idum)-1.0;
	    rsq=v1*v1+v2*v2;
	} while (rsq >= 1.0 || rsq == 0.0);
	fac=sqrt(-2.0*log(rsq)/rsq);
	gset=v1*fac;
	iset=1;
	return v2*fac;
    } else {
	iset=0;
	return gset;
    }
}


/*---------------------------------------------------------------------------*/
void ranprobs(vector<double>& v, int& idum)
{
    register double sum = 0.0;
    register int i, size = v.size();

    for (i = 0; i < size; i++) {
	v[i] = ran1(idum);
	sum += v[i];
    }

    // Normalize so add to one
    for (i = 0; i < size; i++)
	v[i] = v[i] / sum;
}


/*---------------------------------------------------------------------------*/
int ranind(const vector<double>& vprob, int& idum)
{
    register int k = 0;
    register double cum = 0.0;
    register double rn = ran1(idum);

    while (cum < rn)
	cum += vprob[k++];

    return (k-1);
}