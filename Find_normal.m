function [B,Ix] = Find_normal (spar,c,naca,Bending,a)

%This function finds the shear distribution along the panels of our
%structure using 0,1 or 2 intermediate booms between the spar webs.
% It also returns the matrix data of the booms, providing the geometry of 
% the problem given the number of booms.
%The inputs are

%spar:vector containing x/c position of the spars
%Qy: Lift provided by the team A
%t: vector of thickness of the panels.
%a: vector of areas of the booms.
%c: chord provided by the team A.
%naca: max thick. of airfoil-> for NACA 0012, 'naca'=0.12

%% Calculation of the data for the problem

%This equation finds the y-coordinate of a symmetric airfoil as a function
%of its x-coordinate.

y= @(x) 5*naca*(0.2969*sqrt(x)-0.126*x-0.3516*x^2+0.2843*x^3-0.1015*x^4);


%n: number of intermediate booms between spar webs

n=(length(a)-6)/4;

%Number of booms can be expressed as follows:
nB=6+4*n; 

%B matrix will collect in the data of the booms. Each row will be devoted
%to a single boom. The first columnn indicate the area of the boom, second
%column the x-coordinate and third column the y-coordinate. For instance:
%B(3,2)-> x-coordinate of boom 3.

%The booms are called from 1 to nB starting from the top boom of the middle
%spar going clockwise. Like the hours of a clock moved one position
%backwards.



%The x-coordinate for the booms forming the spars do not depend on n.
B_inercial=zeros(nB,4);
B_inercial(:,1)=a;
B_inercial(1,2)=spar(2)*c;
B_inercial(nB/2+1,2)=spar(2)*c;
B_inercial(nB/2-(n+1),2)=spar(3)*c;
B_inercial(nB/2-(n),2)=spar(3)*c;
B_inercial(nB-n-1,2)=spar(1)*c;
B_inercial(nB-n,2)=spar(1)*c;


%For the booms that depend on n, they are collocated in the way they are
%separated by the same x-distance.
switch n 
    case 1
        B_inercial(2,2)= (B_inercial(3,2)+B_inercial(1,2))/2;
        B_inercial(5,2)= B_inercial(2,2);
        B_inercial(7,2)= (B_inercial(6,2)+B_inercial(8,2))/2;
        B_inercial(10,2)= B_inercial(7,2);
    case 2
        B_inercial(2,2)= B_inercial(1,2)+(B_inercial(4,2)-B_inercial(1,2))/3;
        B_inercial(3,2)= B_inercial(1,2)+2*(B_inercial(4,2)-B_inercial(1,2))/3;
        B_inercial(6,2)= B_inercial(3,2);
        B_inercial(7,2)= B_inercial(2,2);
        B_inercial(9,2)= B_inercial(12,2)+(B_inercial(1,2)-B_inercial(12,2))/3;
        B_inercial(10,2)= B_inercial(12,2)+2*(B_inercial(1,2)-B_inercial(12,2))/3;
        B_inercial(13,2)= B_inercial(10,2);
        B_inercial(14,2)=  B_inercial(9,2);
end

%Now find the y-coordinate using first equation.

for i=1:nB/2-(n+1)
    B_inercial(i,3)= y(B_inercial(i,2)/c)*c;
end
for i=nB/2-(n):nB-n-1
    B_inercial(i,3)= -y(B_inercial(i,2)/c)*c;
end
for i=nB-n:nB
    B_inercial(i,3)= y(B_inercial(i,2)/c)*c;
end


%Calculate CoM for the wing box.

p=0;
r=0;
for i=1:nB
    p=p+a(i)*B_inercial(i,2);
    r=r+a(i);
end
CoM_x=p/r;

p=0;
r=0;
for i=1:nB
    p=p+a(i)*B_inercial(i,3);
    r=r+a(i);
end
CoM_y=p/r;

%Notice that this coordinates consider the origin the LE of the chord-line.
%Hence we need to change now our origin to our CoM, since our airfoils are
%symmetric, only x-coordinate need to be corrected.(B(:,2))

B=B_inercial;
for i=1:nB
    B(i,2)=B_inercial(i,2)-CoM_x;
end

for i=1:nB
    B(i,3)=B_inercial(i,3)-CoM_y;
end

%% Calculation of inertia

% Calculation of Ix
Ix=0;
for i=1:nB
    Ix=Ix+B(i,1)*B(i,3)^2;
end

%% Calculation of normal stress

for i=1:nB
    B(i,4)= Bending*B(i,3)/Ix;
end 

end
