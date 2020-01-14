%This function evaluates the interpolation
% polynomial Hw(x,y) at the point x and y
% for a third order polynomial in both
% directions.
%It may be used for the finite element 
% program for plates of C1 continuity
% or any other program that needs such 
% polynomials
function Hw=CalcHw(x,y)
  
  f0=1;f1=x;f2=x*x;f3=x*x*x;
  g0=1;g1=y;g2=y*y;g3=y*y*y;
  
  Hw=[f0*g0, ...
      f1*g0, f0*g1, ...
      f2*g0, f1*g1, f0*g2, ...
      f3*g0, f2*g1, f1*g2, f0*g3, ...
      f3*g1, f2*g2, f1*g3, ...
      f3*g2, f2*g3, ...
      f3*g3]
  
endfunction
