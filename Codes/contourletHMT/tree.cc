//-----------------------------------------------------------------------------
// tree.cc
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <iterator>
#include "tree.hh"
#include "mex.h"

//-----------------------------------------------------------------------------
template <class T>
tree<T>::tree(int nr, int nc, int nl, const T& value)
   : data(nl)
{
   register int J, i, nNode;

   for (J = 0, nNode = nr; J < nl; J++, nNode *= nc)
   {
          data[J].reserve(nNode);
          //data[J] = vector<T> (nNode);
	  std::back_insert_iterator< vector<T> > di(data[J]); // data iterator
 
	  for (i = 0; i < nNode; i++)
		 *di++ = value;
   }
}


//-----------------------------------------------------------------------------
template <class T>
tree<T>::tree(const tree<T>& aTree)
   :data(aTree.data.size())
{
   register int i, nLev = aTree.data.size();
  
   // Copy data

   for (i = 0; i < nLev; i++)
	  data[i] = aTree.data[i];
}


//-----------------------------------------------------------------------------
template <class T>
tree<T>::tree(char *filename)
{
   int nRoots, nChildren, nLevels;
   register int J, i, nNode, k;

   FILE *fp = fopen(filename, "r");
   if (!fp) 
     mexErrMsgTxt("ERROR: can not open for reading ");

   if (fscanf(fp, "nRoots: %d\n", &nRoots) != 1) 
     mexErrMsgTxt("ERROR: problem reading nRoots field");

   if (fscanf(fp, "nChildren: %d\n", &nChildren) != 1) 
     mexErrMsgTxt("ERROR: problem reading nChildren field");

   if (fscanf(fp, "nLevels: %d\n", &nLevels) != 1) 
     mexErrMsgTxt("ERROR: problem reading nLevels field");

   data = vector< vector<T> > (nLevels);	// resize data
   T *buf = new T[nRoots];		   	// buffer for input
   T *pbuf;					// pointer to buffer
   vector<T>::iterator di;	                // data iterator

   for (J = 0, nNode = nRoots; J < nLevels; J++, nNode *= nChildren)
   {
     //data[J].reserve(nNode);
     data[J] = vector<T> (nNode);
     di = data[J].begin();

     for (i = 0; i < nNode; i += nRoots) 
       {
	 fread(buf, sizeof(T), nRoots, fp);
	 pbuf = buf;
	 for (k = 0; k < nRoots; k++)
	   *di++ = *pbuf++;
       }
   }
 
   fclose(fp);
   delete [] buf;
}


//-----------------------------------------------------------------------------
template <class T>
tree<T>& tree<T>::operator = (const tree<T>& aTree)
{
   register int i, nLev = aTree.data.size();

   if (this == &aTree)
	  return *this;

   if (data.size() != nLev)
	  data = vector< vector<T> > (nLev);  // resize data
	
   // Copy data
   for (i = 0; i < nLev; i++)
	  data[i] = aTree.data[i];
  
   return *this;
}


//-----------------------------------------------------------------------------
template <class T>
void tree<T>::dump(char *filename)
{
    int nRoots, nLevels, nChildren;
    register int J, i, nNode, k;

    nRoots = data[0].size();
    nLevels = data.size();
    if (nLevels == 0) nChildren = 0;
    else nChildren = data[1].size() / nRoots;

    FILE *fp = fopen(filename, "w");
    if (!fp) 
      mexErrMsgTxt("ERROR: can not open for writing ");

    fprintf(fp, "nRoots: %d\n", nRoots);
    fprintf(fp, "nChildren: %d\n", nChildren);
    fprintf(fp, "nLevels: %d\n", nLevels);

    T *buf = new T[nRoots];	// buffer for output
    T *pbuf;			// pointer to buffer
    vector<T>::iterator di;	// data iterator

    for (J = 0; J < nLevels; J++)
    {
	di = data[J].begin();

	for (i = 0, nNode = data[J].size(); i < nNode; i += nRoots) 
	{
	    pbuf = buf;
	    for (k = 0; k < nRoots; k++)
	      *pbuf++ = *di++;
	    
	    fwrite(buf, sizeof(T), nRoots, fp);
	}
    }

    fclose(fp);
    delete [] buf;
}
template class tree<double>;
template class tree<int>;
template class vector<double>;
template class vector<vector<double> >;
template class tree<vector<double> >;
template class tree<vector<int> >; 
