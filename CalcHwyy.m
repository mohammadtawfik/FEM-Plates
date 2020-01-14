%This function evaluates the second y-derivative
% for interpolation polynomial Hw(x,y)
% at the point x and y
% for a third order polynomial in both
% directions.
%It may be used for the finite element 
% program for plates of C1 continuity
% or any other program that needs such 
% polynomials

%Functions will work on Octave, FreeMat
% and Matlab
%Created by Mohammad Tawfik
%mohammad.tawfik@gmail.com 
%In assotiation with research papers
% published on ResearchGate.Net
%Author: Mohammad Tawfik

%Title: Fundamentals of Numerical Analysis
%DOI: 10.13140/RG.2.2.25680.81925
%Updated text link:
%https://www.researchgate.net/publication/321850359_Fundamentals_of_Numerical_Analysis_Book_Draft

%Title: Finite Element Analysis
%DOI: 10.13140/RG.2.2.32391.70560
%Updated text link:
%https://www.researchgate.net/publication/321850256_Finite_Element_Analysis_Book_Draft

%Title: Dynamics and Control of Flexible Structures
%DOI: 10.13140/RG.2.2.29036.26242
%Updated text link:
%https://www.researchgate.net/publication/321850001_Dynamics_and_Control_of_Flexible_Structures_Book_Draft

%Title: Panel Flutter
%DOI: 10.13140/RG.2.1.1537.6807
%Updated text link:
%https://www.researchgate.net/publication/275712979_Panel_Flutter

%More code abpout other topics in the text
% may be downloaded from:
% https://github.com/mohammadtawfik/FEM-Plates

function Hw=CalcHwyy(x,y)
  
  f0=1;f1=x;f2=x*x;f3=x*x*x;
  g0=0;g1=0;g2=2  ;g3=6*y;
  
  Hw=[f0*g0, ...
      f1*g0, f0*g1, ...
      f2*g0, f1*g1, f0*g2, ...
      f3*g0, f2*g1, f1*g2, f0*g3, ...
      f3*g1, f2*g2, f1*g3, ...
      f3*g2, f2*g3, ...
      f3*g3];
  
endfunction
