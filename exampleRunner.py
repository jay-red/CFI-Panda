import sys
from exampleAI import Run

name = "Pandamonium"
if len( sys.argv ) == 2:
	name = sys.argv[ 1 ]
Run( name )