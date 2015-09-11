

\\ converts the list l to a string contatining the same in M2 format
M2_array_display(l)=
{
  local(s,i,n);
  n = length(l);
  s="[";
  for (i=1,n-1,
    s = concat(s,l[i]);
    s = concat(s,",");
    );
  s = concat(s,l[n]);
  s = concat(s,"]");
  s
}

\\in the following we assume that T has been previously assigned as a
\\vector containing the torsion info for the elliptic curve.
br_M2_assign_g_stuff()=
{
  local(points,n,i);
  \\ first the generator vector Egens:
  n = length(T[3]);
  points="[";
  for (i=1,n-1,
    points = concat(points,M2_array_display(T[3][i]));
    points = concat(points,",");
    );
  points = concat(points,M2_array_display(T[3][n]));
  points = concat(points,"]");
  egens = concat("Egens = ", points);
  print(egens);
  
  \\ finally, the order of the generator g:
  gorder = concat("gorders = ", M2_array_display(T[2]));
  print(gorder);
}

