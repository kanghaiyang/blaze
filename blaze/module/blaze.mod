# Establishes the mapping between primitive operations and the
# their graph expression. 

# Scalar arithmetic
interface Arith t:
    fun add      :: (t,t) -> t
    fun multiply :: (t,t) -> t
    fun subtract :: (t,t) -> t
    fun divide   :: (t,t) -> t
    fun mod      :: (t,t) -> t
    fun power    :: (t,t) -> t

    # op _+_ = add
    # op _*_ = multiply
    # op _-_ = subtract
    # op _/_ = divide
    # op _%_ = mod
    # op _**_ = power

# Array objects
interface Array A:
    fun map        :: ((a -> b), A a) -> A b
    fun reduce     :: (((a,a) -> b), A a) -> A b
    fun accumulate :: (((a,a) -> b), A a) -> A b
    fun zipwith    :: (((a,b) -> c), A a, A b) -> A c

# Array indexing
interface Ix t:
    fun getitem  :: (t, index) -> t
    fun getslice :: (t, index) -> t

    fun setitem  :: (t, index, val) -> ()
    fun setslice :: (t, index, val) -> ()

    fun delitem  :: (t, index) -> ()
    fun delslice :: (t, index) -> ()

interface Ord t:
    fun cmp_eq  :: (t, t) -> bool
    fun cmp_neq :: (t, t) -> bool
    fun cmp_gt  :: (t, t) -> bool
    fun cmp_gte :: (t, t) -> bool
    fun cmp_lt  :: (t, t) -> bool
    fun cmp_lte :: (t, t) -> bool

    # op _=_  = cmp_eq
    # op _!=_ = cmp_neq
    # op _>_  = cmp_gt
    # op _>=_ = cmp_gte
    # op _<_  = cmp_lt
    # op _<=_ = cmp_lte

interface Bool t:
    fun bit_not :: (t,t) -> t 
    fun bit_and :: (t,t) -> t 
    fun bit_or  :: (t,t) -> t 
    fun bit_xor :: (t,t) -> t 

    # op _!_  = bit_not
    # op _&_  = bit_and
    # op _|_  = bit_or
    # op _^_  = bit_xor