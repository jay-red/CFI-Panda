cdef class Game:
	cdef data
	cdef token
	cdef int uid
	cdef double endTime
	cdef double joinEndTime
	cdef double currTime
	cdef double lastUpdate
	cdef int gameId
	cdef int cellNum
	cdef int baseNum
	cdef int goldCellNum
	cdef int energyCellNum
	cdef double cdTime
	cdef double buildCdTime
	cdef double energy
	cdef double gold
	cdef int Action( self, subDir, data )
	cdef double GetTakeTimeEq( self, double timeDiff )
	cdef int JoinGame( self, name )
	cdef int AttackCell( self, int x, int y, boost = * )
	cdef int BuildBase( self, int x, int y )
	cdef int Blast( self, int x, int y, direction )
	cdef int MultiAttack( self, int x, int y )
	cdef GetCell( self, int x, int y )
	cdef int Refresh( self )