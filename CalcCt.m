%This function evaluates geometric 
% strain matrix [Ct]
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

%More code about other topics in the text
% may be downloaded from:
% https://github.com/mohammadtawfik/FEM-Plates

function Cb=CalcCt(x,y)
  
  C1=CalcHwx(x,y);
  C2=CalcHwy(x,y);
  
  Cb=-[C1;C2];
  
endfunction
