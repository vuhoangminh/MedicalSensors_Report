//-----------------------------------------------------------------------------
// tree.hh
//-----------------------------------------------------------------------------
//
// Specification for perfect balance nChildren-ary tree structure where
//		every node, except the leaves, has exactly nChildren.
// Data is stored in arrays, one for each level.  Levels are indexed
//		from top to bottom.
// Parent-child relationships within the tree are implicitly contained in
//		the array indices.
// More specific, the children for the node level[i][j] are:
//		level[i+1][j*nChildren+k] for k = 0,1,...,nChildren-1
// Note that this allows us to treat multiple trees of same size as
//		one tree of multi roots.
//
//
// Example Tree file format:
// nRoots: 4 (the number of roots, or effectively totally number of trees)
// nChildren: 4 (number of child nodes connected to each parent)
// nLevels: 3 (number of tree levels)
// (tree data from top level down encoded)
//-----------------------------------------------------------------------------

#ifndef TREE_H
#define TREE_H

#include <iostream>
#include <vector>

using std::vector;

template <class T>
class tree 
{
    public:
	tree() {}
	tree(int nr, int nc, int nl, const T& value = T());
	tree(const tree<T>& aTree);		// copy constructor
	tree(char *filename); // tree from file

	tree<T>& operator = (const tree<T>& aTree);
	vector<T>& operator [] (int lind) { return data[lind]; }
	int nlev() { return data.size(); }
	int nrt() { return ((nlev() > 0) ? data[0].size() : 0); }
	int nch() { return ((nlev() > 1) ? data[1].size() / nrt() 
			    : 0); }

	void dump(char *filename);	     	// write to a binary file

    private:
	vector< vector<T> > data;
};

#endif	// TREE_H
