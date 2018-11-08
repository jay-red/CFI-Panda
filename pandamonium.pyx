from client cimport Game, Cell
from panda cimport Panda
import random

cdef class Pandamonium( Panda ):
	cdef GameLoop( Pandamonium self ):
		self.attackThreshold = 4.0
		Cell target
		int data
		data = 0
		if self.adjacentGoldNum > 0:
			for target in self.adjacentGoldCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target )
					if data:
						return
		if self.adjacentEnergyNum > 0:
			for target in self.adjacentEnergyCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target )
					if data:
						return
		if self.adjacentEnemyNum > 0:
			for target in self.adjacentEnemyNum:
				if self.FastCell( target ):
					data = self.game.AttackCell( target )
					if data:
						return
		self.targetCell = random.choice( self.adjacentNormalCells )
		self.AttackTarget()

def Run( name ):
	player = Pandamonium()
	player.Start( name )