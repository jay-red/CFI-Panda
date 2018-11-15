from client cimport Game, Cell

cdef class Panda():
	cdef Game game
	cdef int sideLength
	cdef Cell cellUp
	cdef Cell cellRight
	cdef Cell cellDown
	cdef Cell cellLeft
	cdef Cell targetCell
	cdef list adjacentNormalCells
	cdef list adjacentGoldCells
	cdef list adjacentEnergyCells
	cdef list adjacentEnemyCells
	cdef int adjacentNormalNum
	cdef int adjacentGoldNum
	cdef int adjacentEnergyNum
	cdef int adjacentEnemyNum
	cdef list playerBases
	cdef list playerCells
	cdef tuple directions
	cdef float attackThreshold
	cdef Start( Panda self, name )
	cdef Cell GetAdjacentCell( Panda self, int cellIndex )
	cdef FetchAdjacentCells( Panda self, Cell cell )
	cdef int OwnCell( Panda self, Cell cell )
	cdef int EnemyCell( Panda self, Cell cell )
	cdef int AttackCooldown( Panda self )
	cdef int FastCell( Panda self, Cell cell )
	cdef int AttackTarget( Panda self, boost = * )
	cdef Refresh( Panda self )
	cdef FetchInfo( Panda self )
	cdef GameLoop( Panda self )