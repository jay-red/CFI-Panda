from client cimport Game, Cell

cdef class Panda():
	cdef Game game
	cdef int sideLength
	cdef Cell cellUp
	cdef Cell cellRight
	cdef Cell cellDown
	cdef Cell cellLeft
	cdef Cell targetCell
	cdef tuple directions
	cdef float attackThreshold
	cdef Start( Panda self, name )
	cdef Cell GetAdjacentCell( Panda self, int cellIndex )
	cdef AdjacentCells( Panda self, Cell cell )
	cdef int OwnCell( Panda self, Cell cell )
	cdef int AttackCooldown( Panda self )
	cdef int FastCell( Panda self, Cell cell )
	cdef int AttackTarget( Panda self, boost = * )
	cdef Refresh( Panda self )
	cdef GameLoop( Panda self )