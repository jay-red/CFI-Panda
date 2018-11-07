cimport client
import random
import sys

cdef class Panda():
	cdef client.Game game
	cdef client.Cell lastCell
	cdef int sideLength

	def __init__( self ):
		self.game = client.Game()
		self.sideLength = 30

	cdef ValidCell( Panda self, int x, int y ):
		return ( x >= 0 and x < self.sideLength ) and ( y >= 0 and y < self.sideLength )

	cdef Start( Panda self, name ):
		self.game.JoinGame( name )
		self.game.Refresh()
		while True:
			self.GameLoop()

	cdef GameLoop( Panda self ):
		cdef int x
		cdef int y
		cdef int targetX
		cdef int targetY
		cdef client.Cell c
		cdef client.Cell cc
		for x in range( self.sideLength ):
			for y in range( self.sideLength ):
				c = self.game.GetCell( x, y )
				if c.owner == self.game.uid:
					d = random.choice( [ ( 0, 1 ), ( 0, -1 ), ( 1, 0 ), ( -1, 0 ) ] )
					targetX = x + d[ 0 ]
					targetY = y + d[ 1 ]
					if self.ValidCell( targetX, targetY ):
						cc = self.game.GetCell( targetX, targetY )
						if cc != None:
							if cc.owner != self.game.uid and cc.takeTime <= 4.0 and not cc.takeTime == -1:
								self.game.AttackCell( x + d[ 0 ], y + d[ 1 ], False )
		self.game.Refresh()

def Run( name ):
	player = Panda()
	player.Start( name )