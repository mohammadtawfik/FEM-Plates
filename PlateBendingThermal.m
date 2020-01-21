%This program performs plate bending 
% problems using C1 rectangular elements

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

%Explanation for how this code works is 
% available in the text
%Title: Dynamics and Control of Flexible Structures
%DOI: 10.13140/RG.2.2.29036.26242
%Updated text link:
%https://www.researchgate.net/publication/321850001_Dynamics_and_Control_of_Flexible_Structures_Book_Draft


%Clearing the memory
clear all
close all
clc

%Problem Data
%Aluminum material properties are used
Modulus  = 71e9;   %GPa    - Modulus of elasticity
Nu       = 0.3;    %         Poisson's ration
Rho      = 2700;   %Kg/m^3 - Density
Alpha    = 22.5e-6;%         Thermal expansion coefficient
%Geometric Data
LengthX  = 1;         % m
LengthY  = 1;         % m
Thickness= 0.001;     % m
%Finite Element Problem Data
Nx = 10; %number of elements in the x-direction
Ny = 10; %number of elements in the x-direction

%Evaluating the basic quantities
Lx=LengthX/Nx; %element dimensions
Ly=LengthY/Ny;
Qq=Modulus/(1-Nu*Nu)* ...
    [1,Nu,0;Nu,1,0;0,0,(1-Nu)/2];
Dd=Qq*Thickness*Thickness*Thickness/12;
Nt=Modulus*Thickness*Alpha/(1-Nu);
TbInv=CalcTbInv(Lx,Ly);

[Kb,Mb]=CalcLinear(Dd,Lx,Ly);
Kb=TbInv'*Kb*TbInv;
Mb=TbInv'*Mb*TbInv*Rho*Thickness;
Kt=CalcThermal(Lx,Ly);
Kt=Nt*TbInv'*Kt*TbInv;
%***************************************
%Creating the Mesh (Noedes and Elements)
%***************************************
%Initializing the Nodes registry!
% Columns 1&2 contain the 
%  coordinates of the nodes (x,y)
% Columns 3 to 6 contain the numbers
%  of the degrees of freedom at the node
Nodes=zeros((Nx+1)*(Ny+1),6);
%filling the Nodes registry
for jj=1:Ny+1
  for ii=1:Nx+1
    Pointer=(jj-1)*(Nx+1) + ii; %Node number
    Nodes(Pointer,1)=(ii-1)*Lx;
    Nodes(Pointer,2)=(jj-1)*Ly;
    Nodes(Pointer,3)=Pointer*4-3; %w
    Nodes(Pointer,4)=Pointer*4-2; %wx
    Nodes(Pointer,5)=Pointer*4-1; %wy
    Nodes(Pointer,6)=Pointer*4;   %wxy
  endfor
endfor

%Initializing the Elements registry
% Columns 1 to 4 contain the global node
%  numbers associated with the element
Elements=zeros(Nx*Ny,4);
for jj=1:Ny
  for ii=1:Nx
    Pointer=(jj-1)*Nx + ii;
    Elements(Pointer,1)=(jj-1)*(Nx+1)+ii;
    Elements(Pointer,2)=(jj-1)*(Nx+1)+ii+1;
    Elements(Pointer,3)=(jj)*(Nx+1)+ii+1;
    Elements(Pointer,4)=(jj)*(Nx+1)+ii;
  endfor
endfor
%
%Creating the Boundary Conditions vector
% This vector will contain the numbers of
%  the fixed degrees of freedom;
%  ie. the columns and rows that will be
%  eleminated from the global matrix
BCs=[];
%Support conditions are user-defined
% 0=CCCC
% 1=SSSS
SupportConditions=1;
for jj=1:Ny+1
  for ii=1:Nx+1
    Pointer=(jj-1)*(Nx+1) + ii; %Node number
    %If the node is on the sides ...
    if or(or(jj==1,jj==Ny+1),or(ii==1,ii==Nx+1))
      if SupportConditions==0
        %The following line counts the BCs
        % for a CCCC plate
        BCs=[BCs,Nodes(Pointer,3:6)];
      elseif SupportConditions==1
        %The following lines counts for BCs
        % for SSSS plate
        %if the node is a corner node
        if and(or(jj==1,jj==Ny+1),or(ii==1,ii==Nx+1))
          BCs=[BCs,Nodes(Pointer,3:6)];
        %if the node is on either horizontal sides
        elseif or(jj==1,jj==Ny+1)
          BCs=[BCs,Nodes(Pointer,3:4)];
        %if the node is on either vertical sides
        elseif or(ii==1,ii==Nx+1)
          BCs=[BCs,Nodes(Pointer,3)];
          BCs=[BCs,Nodes(Pointer,5)];
        endif
      endif
    endif
  endfor
endfor
%The complementary coundary conditions
% is a vector that contains the numbers
% of the degrees of freedom that are FREE
BCsC=1:4*(Nx+1)*(Ny+1);
%BCs
BCsC(BCs)=[];

%*****************************************
%The global Matrices
%*****************************************
%Initialization
KG=zeros(4*(Nx+1)*(Ny+1),4*(Nx+1)*(Ny+1));
MG=zeros(4*(Nx+1)*(Ny+1),4*(Nx+1)*(Ny+1));
KT=zeros(4*(Nx+1)*(Ny+1),4*(Nx+1)*(Ny+1));

%Looping for the elements
for ii=1:Nx*Ny
  %Looping for the element nodes
  for jj=1:4
    DOFsj=Nodes(Elements(ii,jj),3:6);
    %Looping AGAIN for the elements nodes;
    for kk=1:4
      DOFsk=Nodes(Elements(ii,kk),3:6);
      KG(DOFsj,DOFsk)=KG(DOFsj,DOFsk)+ ...
        Kb(4*jj-3:4*jj,4*kk-3:4*kk);
      KT(DOFsj,DOFsk)=KT(DOFsj,DOFsk)+ ...
        Kt(4*jj-3:4*jj,4*kk-3:4*kk);
      MG(DOFsj,DOFsk)=MG(DOFsj,DOFsk)+ ...
        Mb(4*jj-3:4*jj,4*kk-3:4*kk);
    endfor
  endfor
endfor
%Applying the boundary conditions
KReduced=KG(BCsC,BCsC);
KtReduced=KT(BCsC,BCsC);
MReduced=MG(BCsC,BCsC);

%Evaluating the Natural Frequencies of the
% plate without the presence of themal
% load
vvv=sqrt(sort(eig(inv(MReduced)*KReduced)));
%Displaying the lowest 5 frequencies 
% normalized to be able to compare to
% literature
vvv(1:5)*sqrt(Rho*Thickness/Dd(1,1)) %rad/sec

%Evaluating the buckling teperature
ttt=sort(eig(inv(KtReduced)*KReduced));
%Displaying the lowest buckling temperatures
% normalized to compare with literature
ttt(1:5)*12*(1+Nu)*Alpha/pi/pi/Thickness/Thickness


%Showing the effect of thermal loads on 
% the lowest natural frequency of the plate
DeltaT=ttt(1)/20;
for ii=1:21
  TTT(ii)=DeltaT*(ii-1);
  vv(ii)=min(sqrt(sort(eig(inv(MReduced)*(KReduced-TTT(ii)*KtReduced)))));
endfor
plot(TTT*12*(1+Nu)*Alpha/pi/pi/Thickness/Thickness,vv*sqrt(Rho*Thickness/Dd(1,1)))
grid
xlabel("Normalized Temperature")
ylabel("Normalized First Natural Frequency")