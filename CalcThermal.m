%This function evaluates thermal stiffness
% matrix [KT] 
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

%More code about other topics in the text
% may be downloaded from:
% https://github.com/mohammadtawfik/FEM-Plates

function [KT]=CalcThermal(Lx,Ly)

GCn=8; %Number of Gauss integration points
%Get the Gauss constants
GaussConstants=GetGC(GCn);
%Initialize the matrices
KT=zeros(16,16);
%Start the numerical integrration procedure
for Xi=1:GCn
  %Evaluating the physiscal value of X
  X = Lx * (GaussConstants(2, Xi) + 1) / 2;
  for Yi=1:GCn
    %Evaluating the physical value of Y
    Y= Ly * (GaussConstants(2,Yi) + 1) / 2;
    Ct=CalcCt(X,Y);
    Kt= Ct'*Ct;
    %performing the weighted summation
    KT=KT+GaussConstants(1,Xi)*GaussConstants(1,Yi)*Kt;
    %End of Calculation loop body
  endfor
endfor 
%Multiplying the resulting matrices by Jacobian
KT = KT * Lx * Ly / 4;
endfunction
