
\\ create a Macaulay 2 command to enter elliptic curve stuff:

\\ output is : upper left, upper right before substitution, x value to
\\ to be substituted, y val to be subbed, denominator.

print("ul = " data[1]);
print("preur = " data[2] " + x - x");
print("ur = sub(preur,{x=>"data[3]",y=>"data[4]"})");
print("den = " data[5]);

