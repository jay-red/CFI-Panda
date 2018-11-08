from client cimport Game, Cell
from panda cimport Panda
import random

cdef class ExampleAI( Panda ):
	def __init__( ExampleAI self ):
		self.attackThreshold = 4.0

	cdef GameLoop( ExampleAI self ):
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
					d = random.choice( self.directions )
					targetX = x + d[ 0 ]
					targetY = y + d[ 1 ]
					cc = self.game.GetCell( targetX, targetY )
					if cc.valid:
						if not self.OwnCell( cc ) and cc.takeTime <= 4.0 and not cc.takeTime == -1:
							self.game.AttackCell( x + d[ 0 ], y + d[ 1 ], False )

def Run( name ):
	player = ExampleAI()
	player.Start( name )