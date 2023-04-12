function [R]= Boom_areas (spar,c,naca,Bending)


%{
    DESCRIPTION:
    This function calculates the fuel weight for each wing section based on the 
    position of the front and rear spars. It integrates the airfoil profile for 
    each section of the wing with the spars positions as the integration limits.

    INPUTS:
    - spar: vector with the position of the spars for the section.
    - c: section chord.
    - naca: Non dimensional maximum thickness of the airfoil (value between 0 and 1).
    - bending: bending moment in the specific section.

    OUTPUTS:
    - R: matrix with the vector of areas whose configuration fit the
    requirements for each spar configuration.
%}
A=linspace(1e-4,1e-2,10);
n_iter=1;
yield=89800;

for i=1:length(A)
    for j=1:length(A)
        for k=1:length(A)
            for l=1:length(A)
                for m=1:length(A)
                    a=[A(k),A(l),A(m),A(m),A(l),A(k),A(j),A(i),A(i),A(j)];
                    [B,Ix] = Find_normal (spar,c,naca,Bending,a);

                    if 0.95>(B(4,1)/yield)>1.05 && 0.95>(B(4,2)/yield)>1.05 && 0.95>(B(4,3)/yield)>1.05 && 0.95>(B(4,4)/yield)>1.05 && 0.95>(B(4,5)/yield)>1.05 && 0.95>(B(4,6)/yield)>1.05 && 0.95>(B(4,7)/yield)>1.05 && 0.95>(B(4,8)/yield)>1.05 && 0.95>(B(4,9)/yield)>1.05 && 0.95>(B(4,10)/yield)>1.05
                        R(n_iter,:)=a;
                        n_iter=n_iter+1;
                    end

                end
            end
        end
    end
end