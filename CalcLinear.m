%This function evaluates mass and stiffness
% matrices [Kb] and [Mb] 
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

function [KB,MB]=CalcLinear(Q,Lx,Ly)

GCn=9;
GaussConstants=GetGC(GCn);
KB=zeros(16,16);
MB=zeros(16,16);

%Start the numerical integrration procedure
for Xi=1:GCn
  X = Lx * (GaussConstants(2, Xi) + 1) / 2;
  for Yi=1:GCn
    Y= Ly * (GaussConstants(2,Yi) + 1) / 2;
    Hw=CalcHw(X,Y);
    Cb=CalcCb(X,Y);
    Kb= cb'*Q*cb;
    Mb= Hw'*Hw;
    %performing the weighted summation
    KB=KB+GaussConstants(1,Xi)*GaussConstants(1,Yi)*Kb;
    MB=MB+GaussConstants(1,Xi)*GaussConstants(1,Yi)*Mb;
    %End of Calculation loop body
  endfor
endfor 
%Multiplying the resulting matreces by Jacobian
KB = KB * Lx * Ly / 4;
MB = MB * Lx * Ly / 4;
endfunction
