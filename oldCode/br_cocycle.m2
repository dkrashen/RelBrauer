print "\nprocedure : brco(a1,a2,a3,a4,a6)\n";
print "for a curve in Wierstrauss form:";
print "y^2 + a_1 xy + a_3 y = x^3 + a_2 x^2 + a_4 x + a_6\n";

print "\n\nresult is in the format of";
print "an array with each entry corresponding to a array with";
print "first entry a point defining the homogeneous space";
print "second entry, the order of the point on the curve";
print "third entry, an array of points generating the torsion on the curve";
print "fourth entry, an array of values of the cocycle at those generators";
print "\nif the rank of the torsion is 0, an empty array is returned.";

print "\nprocedure : brcolatex(a1,a2,a3,a4,a6,filename)";
print "produces a latex version of the output in the notation of the paper.";
print "filename must be a string enclosed in quotes. the resulting latex";
print "files are placed in the latex directory. (a .tex and .bib file are";
print "produced).\n\n";

cocyclefile := "pari_code/temp_br_cocycle.gp";
generatorsfile := "temp_br_cocycle_generators.gp";
copycocyclefile := "temp_br_cocycle_copy.gp";
isrank0file := "temp_br_cocycle_rank0.gp";

rankfile := "temp_br_cocycle_rank0.M2";
datafile := "temp_br_cocycle_data.M2";
ringsfile := "temp_br_cocycle_rings.M2";
 
brco = (a1,a2,a3,a4,a6) ->
  (
  "---------------------------------------------------------";
  "set a gp-readable string with the elliptic curve data";
  "---------------------------------------------------------";
  E = "["|a1|","|a2|","|a3|","|a4|","|a6|"]";
  "---------------------------------------------------------";
  "---------------------------------------------------------";
  
  "---------------------------------------------------------";
  
  "ISRANK0FILE AND RANKFILE STUFF";

  "---------------------------------------------------------";
  "check to see if the curve is rank 0. if so return an error";
  "the variable 'isrank0' will store 1 if rank 0 and 0 otherwise";
  
  S = "echo 'E = ellinit("|E|");' > "|isrank0file; run S;
  S = "cat pari_code/checkrank.gp >> "|isrank0file; run S;
  S = "gp -q < "|isrank0file|" > "|rankfile; run S;
  load rankfile;
  S = "rm -f "|rankfile|" "|isrank0file; run S;
  if (isrank0 == 1) then [] else
(
  
  "---------------------------------------------------------";

  "END ISRANK0FILE AND RANKFILE STUFF";
  
  "---------------------------------------------------------";

  
  "GENERATORSFILE AND DATAFILE STUFF";
  
  "---------------------------------------------------------";
  "pass the curve definition to the generator file";
  "---------------------------------------------------------";
  S = "echo 'E = ellinit("|E|");' > "|generatorsfile; run S;
  "---------------------------------------------------------";
  "---------------------------------------------------------";
  
  "---------------------------------------------------------";
  "create and load an M2 file with data on the generators of E";
  "variable are: Egens= an M2 array of generators [[x1,y1],[x2,y2],...]";
  "gorders= the orders of g";
  "---------------------------------------------------------";
  S = "echo 'T = elltors(E);' >> "|generatorsfile; run S;
  S = "cat pari_code/generators.gp >> "|generatorsfile; run S;
  S = "echo 'br_M2_assign_g_stuff()' >> "|generatorsfile; run S;
  S = "gp -q < "|generatorsfile|" > "|datafile; run S;
  load datafile;
  S = "rm -f "|datafile|" "|generatorsfile; run S;
  "---------------------------------------------------------";
  
  "END GENERATORSFILE AND DATAFILE STUFF";
  
  "---------------------------------------------------------";

  "RINGSFILE STUFF";

  "---------------------------------------------------------";
  "set up the coordinate ring and function field of the elliptic curve";
  "---------------------------------------------------------";
  S1 = "R = QQ[x,y]";
  S2 = "(y^2+("|a1|")*x*y+("|a3|")*y-(x^3+("|a2|")*x^2+("|a4|")*x+("|a6|")));";
  S = "echo '"|S1|"/"|S2|"' >> "|ringsfile; run S;
  S = "echo 'F = frac(R);' >> "|ringsfile; run S;
  S = "echo 'use frac(R);' >> "|ringsfile; run S;
  load ringsfile;
  S = "rm -f "|ringsfile; run S;
  "---------------------------------------------------------";
 
  "END RINGSFILE STUFF";
 
  "---------------------------------------------------------";
  
  "---------------------------------------------------------";
  
  "COCYCLEFILE STUFF";
  
  "---------------------------------------------------------";
  "compute the answers.  result is stored in the variable 'answer'";
  "format of answer:";
  "an array with each entry corresponding to a array with";
  "first entry a point defining the homogeneous space";
  "second entry, the order of the point on the curve";
  "third entry, a sequence of pairs giving curve generators and the";
  "cocycle image";
 "---------------------------------------------------------";
  "finalanswer contains the data to be returned";
  finalanswer = [];

  for m from 0 to (length(Egens)-1) do
  (
    "biganswer is a placeholder for the current homogeneous space";
    biganswer = [];
    
    g = Egens#m;
    n = gorders#m;
    
    biganswer = append(biganswer,g);
    biganswer = append(biganswer,n);
    
    answer = [];
    for j from 0 to (length(Egens)-1) do
    (
      egen = Egens#j;
      S = "echo 'E = ellinit("|E|");' > "|cocyclefile; run S;
      S = "echo 'g = ["|g#0|","|g#1|"];' >> "|cocyclefile; run S;
      S = "echo 'Egen = ["|egen#0|","|egen#1|"];' >> "|cocyclefile; run S;
      S = "cat pari_code/br_cocycle.gp >> "|cocyclefile; run S;

      "use the simplified formula to get a cocycle in standard form.";
      dummy = 1;
      for k from 1 to n do dummy=dummy*brcohelper(k,1);
      S = "rm -f "|cocyclefile; run S;
    
      answer = append(answer, [Egens#j,dummy]);
    );
    biganswer = append(biganswer, answer);
    finalanswer = append(finalanswer, biganswer);
  );
  "---------------------------------------------------------";
  "---------------------------------------------------------";

  "END COCYCLEFILE STUFF";
  
  finalanswer
)
)

brcohelper = (i,j) ->
  (
  S = "cp "|cocyclefile|" "|copycocyclefile; run S;
  S = "echo 'data=br_cocycle_data("|i|","|j|");' >> "|copycocyclefile; run S;
  S = "cat pari_code/ending.gp >> "|copycocyclefile; run S;
  S = "gp -q < "|copycocyclefile|" > "|datafile; run S;
  S = "rm -f "|copycocyclefile; run S;
  load datafile;
  dummy = 1/(ul * ur / den);
  S = "rm -f "|datafile; run S;
  dummy
  )


brcolatex = (a1,a2,a3,a4,a6,filename)->
(
  latexfile := "latex/"|filename|".tex";
  l := brco(a1,a2,a3,a4,a6);
  if (length(l) == 0) then (print "torsion rank is 0 - this program needs torsion points \nto give interesting output!") else
  (
    S = "cat latex/templates/latex_template_part_1.tex > "|latexfile; run S;
    S = "\\[y^2 + "|a1|"xy + "|a3|"y = x^3 + "|a2|"x^2 + "|a4|"x + "|a6|"\\]";
    S = "echo '"|S|"' >> "|latexfile; run S;

    S = "cat latex/templates/latex_template_part_2.tex >> "|latexfile; run S;
  
    S = "echo '";
    if (length(l) == 1) then (S = S|" point:\n") else (S = S|"points:\n");
    S = S|"\n\\noindent\n";
    for i from 0 to (length(l)-1) do
    (
      prinhom := l#i#0;
      order := l#i#1;
      S = S|"$("|prinhom#0|","|prinhom#1|")$ of order $"|order|"$";
      if (i == length(l)-1) then (S = S|".") else 
      (
        if (i == length(l)-2) then (S = S|" and ") else (S = S|", ");
      );
    );
    S = S|"' >> "|latexfile; run S;

    S = "cat latex/templates/latex_template_part_3.tex >> "|latexfile; run S;

    for i from 0 to (length(l)-1) do
    (
      S = "echo 'For the homogenous space defined by ";
      S = S|"$t = \\ominus("|l#i#0#0|","|l#i#0#1|")$, ' >> "|latexfile; run S;
      S = "echo 'we have: \\begin{align*}";
      for j from 0 to (length(l#i#2)-1) do
      (
        S = S|"\\fa_{C_t}("|l#i#2#j#0#0|","|l#i#2#j#0#1|")";
        S = S|"&= (L/k, \\sigma,' >> "|latexfile; run S;
        
        "since the cocycle entry is in F and not an integer, we";
        "must jump through a little hoop to print it to the file...";
        
        "br_temp_writing_file.tex" << l#i#2#j#1 << endl << close;
        S = "cat br_temp_writing_file.tex >> "|latexfile; run S;
        run "rm br_temp_writing_file.tex";

        S = "echo ')";
        if (j == length(l)-1) then (S = S|".") else (S = S|", \\\\");
      );
      S = S|"\\end{align*}' >> "|latexfile; run S;
    );
    S = "cat latex/templates/latex_template_part_4.tex >> "|latexfile; run S;
    S = "echo '\\bibliography{"|filename|".bib}' >> "|latexfile; run S;
    S = "echo '\\end{document}' >> "|latexfile; run S;
    S = "cp latex/templates/citations.bib latex/"|filename|".bib"; run S;
  )
)

