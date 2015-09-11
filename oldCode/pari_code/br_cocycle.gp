\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\ the following function computes the function in the
\\ paper denoted by l_{p,q} for the curve E
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
br_linear(E, p, q)=
{
  local(dummy,g,cx,cy,c0);
  if ((p == [0]) && (q == [0]), dummy=1 , 
    if ((q == [0]), dummy = (x - p[1]),
      if ((p == [0]), dummy = (x - q[1]),
        if (((p[1] == q[1]) && (p[2] != q[2])), dummy = (x - q[1]),
	  if ((p == q),	
	    dummy = -((y-p[2])*(2*p[2]+E[1]*p[1]+E[3])-(x-p[1])*(3*p[1]^2+2*E[2]*p[1]+E[4]-E[1]*p[2])),
	dummy = (q[2]-p[2])*x-(q[1]-p[1])*y+q[1]*p[2]-p[1]*q[2])))));
  \\ reduce extraneous factors:
  cx = numerator(polcoeff(dummy,1,x));
  cy = numerator(polcoeff(dummy,1,y));
  c0 = numerator(polcoeff(polcoeff(dummy,0,x),0,y));
  g = gcd([cx,cy,c0]);
  dummy/g
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\ the following function computes the function in the
\\ paper denoted by f_{p,\sigma}
\\ we will think of this as a function br_func(E, p, t)
\\ where E is the curve, p the point and t is a torsion
\\ point which represents the image of the 1-cocycle
\\ i.e. t = \gamma(\sigma) in the paper.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
br_func(E, p, t)=
{
  br_linear(E, elladd(E, t, p), ellsub(E,[0],elladd(E, t, p)))/br_linear(E, t, p)
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\ in the following function, we will assume that g is defined as the
\\ point on the curve defining the cocycle for the principal homogeneous
\\ space, and that Egen is the point on the curve at which the Brauer
\\ cocycle will be evaluated.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\ the brauer cocycle - although it is constant on the
\\ curve, it is given as a rational function in the plane
\\ arguments are :
\\ E - curve
\\ p - a point on the curve (whose image is the Brauer group element)
\\ s, t - torsion points on the curve which are the images
\\ of the elements \sigma and \tau respectively in the Galois group
\\ note - we are making the rather strong assumption that all f's are
\\ rational (defined over the ground field). Otherwise a Galois action
\\ would need to be included...Also assuming image of 1-cocyle and point
\\ q are rational as well...
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
br_cocycle_data(i,j)=
{
  local(p,t,s,ul,point_minus_t,ur_pre,ur,bot);
  p=Egen;
  t=ellpow(E,g,j);
  s=ellpow(E,g,i);
  ul = br_func(E,p,s);
  point_minus_s = ellsub(E,[x,y],s);
  ur_pre = br_func(E,p,t);
  ur = subst(subst(ur_pre,x,point_minus_s[1]),y,point_minus_s[2]);
  bot = br_func(E,p,elladd(E,s,t));
  [ul,ur_pre,br_ellminus(i)[1],br_ellminus(i)[2],bot]
}

br_ellminus(i)=
{
  ellsub(E,[x,y],ellpow(E,g,i))
}
