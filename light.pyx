from client cimport Game, Cell
from panda cimport Panda
import random

cdef class Pandamonium( Panda ):
	#def __init__( Pandamonium self ):

	cdef int EdgeCell( Pandamonium self, Cell cell ):
		self.AdjacentCells( cell )
		cdef int cellIndex
		cdef int data = 0
		cdef Cell adjacent
		for cellIndex in range( 4 ):
			adjacent = self.GetAdjacentCell( cellIndex )
			if adjacent.valid and not self.OwnCell( adjacent ):
				data = 1
				if not adjacent.cellType == 0 and self.FastCell( adjacent ):
					self.targetCell = adjacent
		return data

	cdef GameLoop( Pandamonium self ):
		self.attackThreshold = 4.0
		cdef int x
		cdef int y
		cdef int targetX
		cdef int targetY
		cdef Cell c
		cdef Cell target
		cdef tuple d
		#if not self.AttackCooldown():
		for x in range( self.sideLength ):
			for y in range( self.sideLength ):
				c = self.game.GetCell( x, y )
				if self.OwnCell( c ):
					if self.EdgeCell( c ):
						if self.targetCell.valid and not self.targetCell.cellType == 0:
							self.AttackTarget()
							return
						else:
							d = random.choice( self.directions )
							targetX = x + d[ 0 ]
							targetY = y + d[ 1 ]
							target = self.game.GetCell( targetX, targetY )
							if target.valid and self.FastCell( target ) and not self.OwnCell( target ):
								self.targetCell = target
		self.AttackTarget()

def Run( name ):
	player = Pandamonium()
	player.Start( name )