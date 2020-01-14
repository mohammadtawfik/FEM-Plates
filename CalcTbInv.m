%This function evaluates Transformation 
% matrix [Tb]^-1 
%It may be used for the finite element 
% program for plates of C1 continuity

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

function TbInv=CalcTbInv(Lx,Ly)
  
  T01=CalcHw(0,0);
  T02=CalcHwx(0,0);
  T03=CalcHwy(0,0);
  T04=CalcHwxy(0,0);
  
  T05=CalcHw(Lx,0);
  T06=CalcHwx(Lx,0);
  T07=CalcHwy(Lx,0);
  T08=CalcHwxy(Lx,0);
  
  T09=CalcHw(Lx,Ly);
  T10=CalcHwx(Lx,Ly);
  T11=CalcHwy(Lx,Ly);
  T12=CalcHwxy(Lx,Ly);
  
  T13=CalcHw(0,Ly);
  T14=CalcHwx(0,Ly);
  T15=CalcHwy(0,Ly);
  T16=CalcHwxy(0,Ly);
  
  Tb=[T01;T02;T03;T04; ...
      T05;T06;T07;T08; ...
      T09;T10;T11;T12; ...
      T13;T14;T15;T16];
  TbInv=inv(Tb);
endfunction
