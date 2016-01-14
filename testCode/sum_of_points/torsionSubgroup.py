
# This function will compute the torsion subgroup of the given elliptic curve

# sample input

E = EllipticCurve([-4,0])

def torSub(E):
	return E.torsion_subgroup()

print torSub(E)