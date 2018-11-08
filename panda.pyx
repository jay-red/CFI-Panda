import sys

cdef class Panda():
	def __init__( self ):
		self.game = Game()
		self.sideLength = 30
		self.targetCell = Cell( {}, 0 )
		self.directions = ( ( 0, 1 ), ( 0, -1 ), ( 1, 0 ), ( -1, 0 ) )

	cdef Start( Panda self, name ):
		self.game.JoinGame( name )
		self.game.Refresh()
		while True:
			self.Refresh()
			self.GameLoop()

	"""
		Convenience functions
	"""
	cdef Cell GetAdjacentCell( Panda self, int cellIndex ):
		if cellIndex == 0:
			return self.cellUp
		elif cellIndex == 1:
			return self.cellRight
		elif cellIndex == 2:
			return self.cellDown
		elif cellIndex == 3:
			return self.cellLeft

	cdef FetchAdjacentCells( Panda self, Cell cell ):
		self.cellUp = self.game.GetCell( cell.x, cell.y - 1 )
		self.cellRight = self.game.GetCell( cell.x + 1, cell.y )
		self.cellDown = self.game.GetCell( cell.x, cell.y + 1 )
		self.cellLeft = self.game.GetCell( cell.x - 1, cell.y )

	cdef int OwnCell( Panda self, Cell cell ):
		cdef int data = 0
		if cell.owner == self.game.uid:
			data = 1
		return data

	cdef int EnemyCell( Panda self, Cell cell ):
		cdef int data = 0
		if not cell.owner == 0 and not self.OwnCell( cell ):
			data = 1
		return data

	cdef int AttackCooldown( Panda self ):
		return self.game.currTime <= self.game.cdTime

	cdef int FastCell( Panda self, Cell cell ):
		cdef int data = 0
		if cell.takeTime <= self.attackThreshold and not cell.takeTime == -1:
			data = 1
		return data

	"""
		Game functions
	"""
	cdef Refresh( Panda self ):
		self.game.Refresh()
		self.targetCell = Cell( {}, 0 )

	cdef FetchInfo( Panda self ):
		self.adjacentNormalCells = []
		self.adjacentGoldCells = []
		self.adjacentEnergyCells = []
		self.adjacentEnemyCells = []
		self.adjacentNormalNum = 0
		self.adjacentGoldNum = 0
		self.adjacentEnergyNum = 0
		self.adjacentEnemyNum = 0
		self.playerBases = []
		self.playerCells = []
		cdef int x
		cdef int y
		cdef cellIndex
		cdef Cell cell
		for x in range( self.sideLength ):
			for y in range( self.sideLength ):
				cell = self.game.GetCell( x, y )
				if self.OwnCell( cell ):
					if cell.isBase:
						self.playerBases.append( cell )
					else:
						self.playerCells.append( cell )
					for cellIndex in range( 4 ):
						adjacent = self.GetAdjacentCell( cellIndex )
						if adjacent.valid and not self.OwnCell( adjacent ):
							if adjacent.cellType == 1:
								adjacentGoldNum += 1
								adjacentGoldCells.append( adjacent )
							elif adjacent.cellType == 2:
								adjacentEnergyNum += 1
								adjacentEnergyCells.append( adjacent )
							elif self.EnemyCell( adjacent ):
								adjacentEnemyNum += 1
								adjacentEnemyCells.append( adjacent )
							else:
								adjacentNormalNum += 1
								adjacentNormalCells.append( adjacent )

	cdef int AttackTarget( Panda self, boost = False ):
		return self.game.AttackCell( self.targetCell.x, self.targetCell.y, boost = boost )

	cdef GameLoop( Panda self ):
		pass