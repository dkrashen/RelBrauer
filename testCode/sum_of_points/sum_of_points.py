

# This function will add two points on an ellipctic curve


# sample input

E = EllipticCurve('389a1')

P = E(-1,1)
Q = E(0,-1)


#defin a function to add the two points

def add_points(P, Q):

	return P+Q


#####
##testing area

print add_points(P, Q)


