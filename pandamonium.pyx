from client cimport Game, Cell
from panda cimport Panda
import random

cdef class Pandamonium( Panda ):
	cdef GameLoop( Pandamonium self ):
		print( "Gold: " + str( self.adjacentGoldNum ) )
		print( "Energy: " + str( self.adjacentEnergyNum ) )
		print( "Enemy: " + str( self.adjacentEnemyNum ) )
		print( "Normal: " + str( self.adjacentNormalNum ) )
		print( "" )
		self.FetchInfo()
		self.attackThreshold = 4.0
		cdef Cell target
		cdef int data
		data = 0
		if self.adjacentGoldNum > 0:
			for target in self.adjacentGoldCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target.x, target.y )
					if data:
						erturn
		if self.adjacentEnergyNum > 0:
			for target in self.adjacentEnergyCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target.x, target.y )
					if data:
						return
		"""
		if self.adjacentEnemyNum > 0 and random.randrange( 2 ) == 0:
			self.targetCell = random.choice( self.adjacentEnemyCells )
			if self.FastCell( self.targetCell ):
				self.AttackTarget()
		elif self.adjacentNormalNum > 0:
			self.targetCell = random.choice( self.adjacentNormalCells )
			if self.FastCell( self.targetCell ):
				self.AttackTarget()
		"""

def Run( name ):
	player = Pandamonium()
	player.Start( name )