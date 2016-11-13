//-----------------------------------------------------------------------------
// matrix.hh
//-----------------------------------------------------------------------------


#ifndef MATRIX_H
#define MATRIX_H

#include <vector>
using std::vector;

template <class T>
class matrix
{
    public:
	matrix() {}
	matrix(int nrow, int ncol, const T& value = T());
	matrix(const matrix<T>& aMatrix);

	matrix<T>& operator = (const matrix<T>& aMatrix);
	vector<T>& operator[] (int rind) { return data[rind]; }

	int nrow() { return data.size(); }
	int ncol() { return ((nrow() > 0) ? data[0].size() : 0); }

	matrix<T> inv() const;
	T det() const;

    private:
	vector < vector<T> > data;
};

#endif //MATRIX_H
