from client cimport Game, Cell
import random
import sys

cdef class Panda():
	cdef Game game
	cdef Cell lastCell
	cdef int sideLength
	cdef list myCells
	cdef list targetCells
	cdef int targetNum
	cdef Cell cellUp
	cdef Cell cellRight
	cdef Cell cellDown
	cdef Cell cellLeft

	def __init__( self ):
		self.game = Game()
		self.sideLength = 30

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

	cdef AdjacentCells( Panda self, Cell cell ):
		self.cellUp = self.game.GetCell( cell.x, cell.y - 1 )
		self.cellRight = self.game.GetCell( cell.x + 1, cell.y )
		self.cellDown = self.game.GetCell( cell.x, cell.y + 1 )
		self.cellLeft = self.game.GetCell( cell.x - 1, cell.y )

	cdef int OwnCell( Panda self, Cell cell ):
		cdef int data = 0
		if cell.owner == self.game.uid:
			data = 1
		return data

	cdef int EdgeCell( Panda self, Cell cell ):
		self.AdjacentCells( cell )
		cdef int cellIndex = 0
		cdef int data = 0
		cdef Cell adjacent
		for cellIndex in range( 4 ):
			adjacent = self.GetAdjacentCell( cellIndex )
			if adjacent.valid and not self.OwnCell( adjacent ):
				self.targetCells.append( adjacent )
				self.targetNum += 1
				data = 1
		return data

	"""
		Game functions
	"""
	cdef Refresh( Panda self ):
		self.myCells = []
		self.targetCells = []
		self.game.Refresh()
		cdef int x
		cdef int y
		cdef Cell cell
		for x in range( self.sideLength ):
			for y in range( self.sideLength ):
				cell = self.game.GetCell( x, y )
				if self.OwnCell( cell ):
					self.myCells.append( cell )
					if self.EdgeCell( cell ):
						pass

	"""
	cdef GameLoop( Panda self ):
		cdef int x
		cdef int y
		cdef int targetX
		cdef int targetY
		cdef Cell c
		cdef Cell cc
		for x in range( self.sideLength ):
			for y in range( self.sideLength ):
				c = self.game.GetCell( x, y )
				if c.owner == self.game.uid:
					d = random.choice( [ ( 0, 1 ), ( 0, -1 ), ( 1, 0 ), ( -1, 0 ) ] )
					targetX = x + d[ 0 ]
					targetY = y + d[ 1 ]
					cc = self.game.GetCell( targetX, targetY )
					if cc.valid:
						if cc.owner != self.game.uid and cc.takeTime <= 4.0 and not cc.takeTime == -1:
							self.game.AttackCell( x + d[ 0 ], y + d[ 1 ], False )
	"""

	cdef GameLoop( Panda self ):
		cdef Cell cell
		cell = random.choice( self.targetCells )
		self.game.AttackCell( cell.x, cell.y )

def Run( name ):
	player = Panda()
	player.Start( name )