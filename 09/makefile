guts: ../guts/guts.v
	v -shared ../guts/guts.v

shr: shr/shr.v
	v -shared shr/shr.v

sol: shr sol.v
	v run sol.v

vis: shr guts vis.v
	v run vis.v
