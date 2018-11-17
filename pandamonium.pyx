from client cimport Game, Cell
from panda cimport Panda
import random

cdef class Pandamonium( Panda ):
	cdef GameLoop( Pandamonium self ):
		self.FetchInfo()
		self.attackThreshold = 4.0
		cdef Cell target
		cdef int data
		cdef int cellIndex
		cdef boost
		cdef Cell newBase
		boost = False
		data = 0
		if self.game.energy >= 95.0:
			boost = True
		print( self.game.baseNum )
		print( self.game.gold )
		if self.game.gold >= 60.0 and self.game.baseNum < 3:
			newBase = random.choice( self.playerCells )
			if self.FastCell( newBase ):
				self.game.BuildBase( newBase.x, newBase.y )
				self.game.AttackCell( newBase.x, newBase.y, boost = boost )
		if self.adjacentGoldNum > 0:
			for target in self.adjacentGoldCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target.x, target.y, boost = boost )
					if data:
						return
				elif self.game.energy > 60.0:
					if target.isTaking == False or not target.attacker == self.game.uid:
						self.FetchAdjacentCells( target )
						for cellIndex in range( 4 ):
							adjacent = self.GetAdjacentCell( cellIndex )
							if adjacent.valid and self.OwnCell( adjacent ):
								data = self.game.Blast( adjacent.x, adjacent.y, "square" )
								if data:
									return
		if self.adjacentEnergyNum > 0:
			for target in self.adjacentEnergyCells:
				if self.FastCell( target ):
					data = self.game.AttackCell( target.x, target.y, boost = boost )
					if data:
						return
		if self.adjacentEnemyNum > 0 and ( self.adjacentNormalNum == 0 or random.randrange( 4 ) == 0 ):
			self.targetCell = random.choice( self.adjacentEnemyCells )
			if self.FastCell( self.targetCell ):
				self.AttackTarget( boost = boost )
		elif self.adjacentNormalNum > 0:
			self.targetCell = random.choice( self.adjacentNormalCells )
			if self.FastCell( self.targetCell ):
				self.AttackTarget( boost = boost )

def Run( name ):
	player = Pandamonium()
	player.Start( name )