import cython
from rapidjson import loads, dumps
from io import BytesIO
import pycurl
import os

"""
framework.pyx

Framework is a high performance Python 3 module for interacting 
with the ColorFight API. Framework is dependent on the Cython,
RapidJSON, and PycURL libraries for maximizing performance.

@author:	Jared Flores
@version:	1.0.0
"""

requestURL = "http://localhost:8000/"
requestURL = "http://colorfight.herokuapp.com/"

cdef Post( subDir, postData ):
	global requestURL
	request = pycurl.Curl()
	buff = BytesIO()
	request.setopt( pycurl.URL, requestURL + subDir )
	request.setopt( pycurl.HTTPHEADER, [ "Content-Type: application/json" ] )
	request.setopt( pycurl.WRITEFUNCTION, buff.write )
	request.setopt( pycurl.POST, 1 )
	request.setopt( pycurl.POSTFIELDS, dumps( postData ) )
	request.perform()
	responseData = buff.getvalue().decode( "UTF-8" )
	statusCode = request.getinfo( pycurl.HTTP_CODE )
	request.close()
	buff.close()
	return ( statusCode, responseData )

cdef CheckToken( token ):
	cdef int statusCode
	statusCode, responseData = Post( "checktoken", { "token" : token } )
	if statusCode == 200:
		return loads( responseData )
	return None

cdef class Cell:
	def __init__( self, cellData, valid ):
		if valid:
			self.owner = cellData[ "o" ]
			self.attacker = cellData[ "a" ]
			self.isTaking = cellData[ "c" ]
			self.x = cellData[ "x" ]
			self.y = cellData[ "y" ]
			self.occupyTime = cellData[ "ot" ]
			self.attackTime = cellData[ "at" ]
			self.takeTime = cellData[ "t" ]
			self.finishTime = cellData[ "f" ]
			self.cellType = cellData[ "ct" ]
			if cellData[ "b" ] == "base":
				self.isBase = 1
			else:
				self.isBase = 0
			if cellData[ "bf" ]:
				self.isBuilding = 0
			else:
				self.isBuilding = 1
			self.buildTime = cellData[ "bt" ]
			self.valid = 1
		else:
			self.valid = 0

cdef class User:
	cdef int uid
	cdef name
	cdef double cdTime
	cdef double buildCdTime
	cdef int cellNum
	cdef int baseNum
	cdef int goldCellNum
	cdef int energyCellNum
	cdef double energy
	cdef double gold

	def __init__( self, userData ):
		self.uid = userData[ "id" ]
		self.name = userData[ "name" ]
		self.cdTime = userData[ "cd_time" ]
		self.buildCdTime = userData[ "build_cd_time" ]
		self.cellNum = userData[ "cell_num" ]
		self.baseNum = userData[ "base_num" ]
		self.goldCellNum = userData[ "gold_cell_num" ]
		self.energyCellNum = userData[ "energy_cell_num" ]
		self.energy = 0.0
		self.gold = 0.0
		if 'energy' in userData:
			self.energy = userData[ 'energy' ]
		if 'gold' in userData:
			self.gold = userData[ 'gold' ]

cdef class Game:
	def __init__( self ):
		self.data = None
		self.token = ""
		self.uid = -1
		self.endTime = 0.0
		self.joinEndTime = 0.0
		self.currTime = 0.0
		self.lastUpdate = 0.0
		self.gameId = 0
		self.cellNum = 0
		self.baseNum = 0
		self.goldCellNum = 0
		self.energyCellNum = 0
		self.cdTime = 0.0
		self.buildCdTime = 0.0
		self.energy = 0.0
		self.gold = 0.0

	cdef int JoinGame( self, name ):
		if os.path.isfile( "token" ):
			with open( "token" ) as f:
				self.token = f.readline().strip()
				data = CheckToken( self.token )
				if data != None:
					if name == data[ "name" ]:
						self.uid = data[ "uid" ]
						return 1

		cdef int statusCode
		statusCode, responseData = Post( "joingame", { "name" : name } )
		if statusCode == 200:
			responseData = loads( responseData )
			self.token = responseData[ "token" ]
			with open( "token", "w" ) as f:
				f.write( self.token )
			self.uid = responseData[ "uid" ]
			self.data = None
		else:
			return 0
		return 1

	cdef int Action( self, subDir, data ):
		cdef int statusCode
		statusCode, responseData = Post( subDir, data )
		if statusCode == 200:
			responseData = loads( responseData )
			return responseData[ "err_code" ]
		else:
			return -1

	cdef int AttackCell( self, int x, int y, boost = False ):
		return self.Action( "attack", { "cellx" : x, "celly" : y, "boost" : boost, "token" : self.token } )

	cdef int BuildBase( self, int x, int y ):
		return self.Action( "buildbase", { "cellx" : x, "celly" : y, "token" : self.token } )

	cdef int Blast( self, int x, int y, direction ):
		return self.Action( "blast", { "cellx" : x, "celly" : y, "token" : self.token, "direction" : direction } )

	cdef int MultiAttack( self, int x, int y ):
		return self.Action( "multiattack", { "cellx" : x, "celly" : y, "token" : self.token } )

	cdef Cell GetCell( self, int x, int y ):
		if ( x >= 0 and x < 30 ) and ( y >= 0 and y < 30 ):
			return Cell( self.data[ "cells" ][ x + ( 30 * y ) ], 1 )
		else:
			return Cell( {}, 0 )

	cdef double GetTakeTimeEq( self, double timeDiff ):
		if timeDiff <= 0:
			return 33.0
		return 30.0 * ( 2 ** ( -timeDiff / 30.0 ) ) + 3

	cdef int Refresh( self ):
		cdef int statusCode
		if self.data == None:
			statusCode, responseData = Post( "getgameinfo", { "protocol" : 2 } )
			if statusCode == 200:
				self.data = loads( responseData )
				self.endTime = self.data[ "info" ][ "end_time" ]
				self.joinEndTime = self.data[ "info" ][ "join_end_time" ]
				self.currTime = self.data[ "info" ][ "time" ]
				self.lastUpdate = self.currTime
			else:
				return 0
		else:
			statusCode, responseData = Post( "getgameinfo", { "protocol" : 1, "timeAfter" : self.lastUpdate } )
			if statusCode == 200:
				responseData = loads( responseData )
				self.data[ "info" ] = responseData[ "info" ]
				self.endTime = self.data[ "info" ][ "end_time" ]
				self.joinEndTime = self.data[ "info" ][ "join_end_time" ]
				self.currTime = self.data[ "info" ][ "time" ]
				self.lastUpdate = self.currTime
				for cell in responseData[ "cells" ]:
					if cell[ "c" ] == 1:
						cell[ "t" ] = -1
					elif cell[ "o" ] == 0:
						cell[ "t" ] = 2
					else:
						cell[ "t" ] = self.GetTakeTimeEq( self.currTime - cell[ "ot" ] )
					self.data[ "cells" ][ cell[ "x" ] + cell[ "y" ] * 30 ] = cell
			else:
				return 0
		return 1