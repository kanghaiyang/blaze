import cython
import numpy as np
cimport numpy as np

from blaze.carray import carrayExtension as carray

np.import_array()
nan = np.nan

# just using this to debug the loops to make sure we only do n
# reads from disk where n = nchunks.
def generic1d_loop(table, label):
    col = table.data.ca[label]

    nchunks = col.nchunks

    for nchunk from 0 <= nchunk < nchunks:
        arr = col.chunks[nchunk][:]
        print arr
        # logic

    if col.leftovers:
        leftover = col.len - nchunks * col.chunklen
        arr = col.leftover_array[:leftover]
        print arr
        # logic

#------------------------------------------------------------------------
# Columwise Standard Deviation
#------------------------------------------------------------------------

# Calculate the sum and sum of squares in one pass
@cython.boundscheck(False)
@cython.wraparound(False)
cdef sqsum(np.ndarray[np.int32_t, ndim=1] a):
    cdef:
        Py_ssize_t length = a.shape[0]

        np.int64_t ai    = 0
        np.int64_t asum  = 0
        np.int64_t assum = 0

    for i from 0 <= i < length:
        ai = a[i]
        asum  += ai
        assum += ai * ai

    return asum, assum

def std(table, label):
    """ Columnwise out of core standard devaiation

    Parameters
    ----------
    table : Table
        A Blaze Table object
    col : str
        String indicating a column name.

    Returns
    -------
    out : float
        standard deviation

    """
    cdef:
        Py_ssize_t nchunk, nchunks

        Py_ssize_t count = 0
        np.float64_t asum   = 0
        np.float64_t asumsq = 0
        np.float64_t amean  = 0

    col = table.data.ca[label]
    nchunks = col.nchunks
    count = col.len

    for nchunk from 0 <= nchunk < nchunks:
        _asum, _assum = sqsum(col.chunks[nchunk][:])
        asum   += _asum
        asumsq += _assum

    if col.leftovers:
        leftover = col.len - nchunks * col.chunklen
        leftover_arr = col.leftover_array[:leftover]

        _asum, _assum = sqsum(leftover_arr)
        asum   += _asum
        asumsq += _assum

    if count > 0:
        amean = cython.cdiv(asum, count)
        # there is probably a more numerically stable version of this
        # but NumPy's implementation is really naive as well so whatever
        return np.float64(np.sqrt((asumsq / count) - (amean * amean)))
    else:
        return np.float64(nan)

#------------------------------------------------------------------------
# Columwise Mean
#------------------------------------------------------------------------

def mean(table, label):
    """ Columnwise out of core mean

    Parameters
    ----------
    table : Table
        A Blaze Table object
    col : str
        String indicating a column name.

    Returns
    -------
    out : float
        mean

    """

    cdef:
        Py_ssize_t nchunk, nchunks

        Py_ssize_t count = 0
        np.float64_t asum   = 0
        np.float64_t amean  = 0


    col = table.data.ca[label]
    nchunks = col.nchunks
    count = col.len

    for nchunk from 0 <= nchunk < nchunks:
        asum += col.chunks[nchunk][:].sum(dtype=col.dtype)

    if col.leftovers:
        leftover = col.len - nchunks * col.chunklen
        asum += col.leftover_array[:leftover].sum(dtype=col.dtype)

    if count > 0:
        return np.float64(asum / count)
    else:
        return np.float64(nan)

#------------------------------------------------------------------------
# Columwise Lstsq
#------------------------------------------------------------------------

def lstsq(table, label):
    pass
