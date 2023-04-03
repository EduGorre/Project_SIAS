function [q,B] = Find_loads (spar,Lift,t,a,c,naca,G, W_inert,Bending)

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
    B_inercial(i,3)= y(B_inercial(i,2));
end
for i=nB/2-(n):nB-n-1
    B_inercial(i,3)= -y(B_inercial(i,2));
end
for i=nB-n:nB
    B_inercial(i,3)= y(B_inercial(i,2));
end


%Calculate CoM for the wing box.

p=0;
r=0;
for i=1:nB
    p=p+a(i)*B_inercial(i,2);
    r=r+a(i);
end
CoM=p/r;

%Notice that this coordinates consider the origin the LE of the chord-line.
%Hence we need to change now our origin to our CoM, since our airfoils are
%symmetric, only x-coordinate need to be corrected.(B(:,2))

B=B_inercial;
for i=1:nB
    B(i,2)=B_inercial(i,2)-CoM;
end

%% Calculation of shear flow once data is known

% Calculation of Ix
Ix=0;
for i=1:nB
    Ix=Ix+B(i,1)*B(i,3)^2;
end

%Calculation of the shear flow with a cut between booms 1 and 2 and booms
%nB and 1. q_open(i) will be the flow from (i) to (i+1). The only exception
%will be for the shear going through the middle spar, q(nB+1), which is the
%flow going from boom 1 to boom nB/2+1


q_open=zeros(nB+1,1);

%Panels with the cut.
q_open(1)=0;
q_open(nB)=0; %!CORRECTION ÓSCAR: 25/03/2023 21:00

%!Code line before correction:
%q_open(q_open-1)=0;

K=(Lift-W_inert)/Ix;

%For the first panels is straight forward because it is a linear sequence.
for i=2:nB/2
    q_open(i)=q_open(i-1)-K*(B(i,1))*(B(i,3));
end

%Calculation of the shear of that excepcional panel.
q_open(nB+1)= -K*(B(1,1))*(B(1,3)); %!CORRECTION ÓSCAR: 25/03/2023 21:00
%!Code line before correction (SIMPLEMENTE ES MÁS EFICIENTE SI TENEMOS QUE ITERAR MUCHAS VECES)
%q_open(length(q_open))= -K*(B(1,1))*(B(1,3));

%Applying equilibrium at boom nB/2+1
q_open(nB/2+1)= q_open(nB/2)+q_open(length(q_open))-K(B(nB/2+1,1))*(B(nB/2+1,3));


%For the final panels it is again a linear sequence.
for i=nB/2+2:length(q_open)-1
    q_open(i)=q_open(i-1)-K*(B(i,1))*(B(i,3));
end

% Now we need to calcualte the additional contribution of the flow inside
% each cell. To do so we need to calculte the area of each cell, and this
% one will be done by summing the area of the trapezes inside each cell.
%For n=0, we need to calculate one trapeze for each cell, with n=1 two
% trapezes each cell, with n=2 three trapezes each cell
%Total trapezes=2*(n+1)

%These trapeces have as bases the y-coordinates substraction of the
%symmetric booms and the height is the x-coordinate substraction of
%consecutive booms.

switch n 
    case 0
        A_cell_1=(B(1,3)-B(4,3)+B(2,3)-B(3,3))*(B(2,2)-B(1,2))/2;
        A_cell_2=(B(1,3)-B(4,3)+B(6,3)-B(5,3))*(B(1,2)-B(6,2))/2;
    case 1
        rho_1=(B(1,3)-B(6,3)+B(2,3)-B(5,3))*(B(2,2)-B(1,2))/2;
        rho_2=(B(2,3)-B(5,3)+B(3,3)-B(4,3))*(B(3,2)-B(2,2))/2;
        A_cell_1=rho_1+rho_2;
        rho_3=(B(1,3)-B(6,3)+B(10,3)-B(7,3))*(B(1,2)-B(10,2))/2;
        rho_4=(B(10,3)-B(7,3)+B(9,3)-B(8,3))*(B(10,2)-B(9,2))/2;
        A_cell_2=rho_3+rho_4;
    case 2
        rho_1=(B(1,3)-B(8,3)+B(2,3)-B(7,3))*(B(2,2)-B(1,2))/2;
        rho_2=(B(2,3)-B(7,3)+B(3,3)-B(6,3))*(B(3,2)-B(2,2))/2;
        rho_3=(B(3,3)-B(6,3)+B(4,3)-B(5,3))*(B(4,2)-B(3,2))/2;
        A_cell_1=rho_1+rho_2+rho_3;
        rho_4=(B(1,3)-B(8,3)+B(14,3)-B(9,3))*(B(1,2)-B(14,2))/2;
        rho_5=(B(14,3)-B(9,3)+B(13,3)-B(10,3))*(B(14,2)-B(13,2))/2;
        rho_6=(B(13,3)-B(10,3)+B(12,3)-B(11,3))*(B(13,2)-B(12,2))/2;
        A_cell_2=rho_4+rho_5+rho_6;
end

%Dummy variable to calculate which is outside the integral.

K1=1/(2*A_cell_1*G);
K2=1/(2*A_cell_2*G);

% Vectors to store the length of each panel.
l=zeros(length(q_open),1);
for i=1:nB-1
    l(i)=sqrt((B(i+1,2)-B(i,2))^2+(B(i+1,3)-B(i,3))^2);
end
l(length(l)-1)= sqrt((B(1,2)-B(nB,2))^2+(B(1,3)-B(nB,3))^2);
l(length(l))= B(1,3)-B(nB/2+1,3);

%vector with the deltas for each panel. Consider t constant along the
%panel.
delta=zeros(length(l),1);
for i=1:length(delta)
    delta(i)=l(i)/t(i);
end

%Sigma is the summation of deltas that feel only the shear flow of its own
%pannel. Sigma_1 for cell 1(right cell) and sigma_2 for left cell.

%Right cell
sigma_1=0;
for i=1:nB/2
    sigma_1=sigma_1+delta(i);
end
sigma_1=sigma_1+delta(length(delta));
alpha_1=0;
for i=1:nB/2
    alpha_1=alpha_1+delta(i)*q_open(i);
end
alpha_1=alpha_1-q_open(length(q_open))*delta(length(delta));

%Left cell
sigma_2=0;
for i=nB/2+1:length(delta)
    sigma_2=sigma_2+delta(i);
end

alpha_2=0;
for i=nB/2+1:length(delta)
    alpha_2=alpha_2+delta(i)*q_open(i);
end



% For the constrain equation of dtheta, we will evaluate momment
% equilibrium at lower boom of middle spar.
theta=zeros(nB,1);
for i=2:nB
    theta(i-1)=atan((B(i,3)-B(i-1,3))/(B(i,2)-B(i-1,2)));
end
theta(i)=atan((B(1,3)-B(nB,3))/(B(1,2)-B(nB,2)));

%Allocate variable of shear open contribution
Shear_torque=0;

%Contribution of skin 1 independent of n
Shear_torque=Shear_torque+q_open(1)*l(1)*abs(cos(theta(1))*(B(1,3)-B(nB/2+1,3)));

%Contribution of spar 3 independent of n
Shear_torque=Shear_torque+q_open(nB/2-(n+1))*l(nB/2-(n+1))*(spar(3)-spar(2))*c;

%Contribution of spar 1 independent of n
Shear_torque=Shear_torque+q_open(nB-n-1)*l(nB-n-1)*(spar(2)-spar(1))*c;

%Contribution of last skin independent of n
Shear_torque=Shear_torque+q_open(nB)*l(nB)*(abs(cos(theta(nB)))*(B(nB,3)-B(nB/2+1,3))-abs(sin(theta(nB))*(B(nB/2+1,2)-B(nB,2))));

%Additional panels dependent on n
switch n
    case 1
        Shear_torque=Shear_torque+q_open(2)*l(2)*(abs((sin(theta(2)))*(B(2,2)-B(6,2))+abs(cos(theta(2)))*(B(2,3)-B(6,3))));
        Shear_torque=Shear_torque+q_open(4)*l(4)*(abs((sin(theta(4)))*(B(4,2)-B(6,2))-abs(cos(theta(4)))*(B(4,3)-B(6,3))));
        Shear_torque=Shear_torque+q_open(7)*l(7)*(-abs(sin(theta(7)))*(B(6,2)-B(7,2))+abs(cos(theta(7)))*(B(6,3)-B(7,3)));
        Shear_torque=Shear_torque+q_open(9)*l(9)*(-abs(sin(theta(9)))*(B(6,2)-B(9,2))+abs(cos(theta(9)))*(B(9,3)-B(6,3)));

    case 2
        Shear_torque=Shear_torque+q_open(2)*l(2)*(abs(sin(theta(2)))*(B(2,2)-B(8,2))+abs(cos(theta(2)))*(B(2,3)-B(8,3)));
        Shear_torque=Shear_torque+q_open(3)*l(3)*(abs(sin(theta(3)))*(B(3,2)-B(8,2))+abs(cos(theta(3)))*(B(3,3)-B(8,3)));
        Shear_torque=Shear_torque+q_open(5)*l(5)*(abs(sin(theta(5)))*(B(5,2)-B(8,2))-abs(cos(theta(5)))*(B(5,3)-B(8,3)));
        Shear_torque=Shear_torque+q_open(6)*l(6)*(abs(sin(theta(6)))*(B(6,2)-B(8,2))-abs(cos(theta(6)))*(B(6,3)-B(8,3)));
        Shear_torque=Shear_torque+q_open(9)*l(9)*(-abs(sin(theta(9)))*(B(8,2)-B(9,2))+abs(cos(theta(9)))*(B(8,3)-B(9,3)));
        Shear_torque=Shear_torque+q_open(10)*l(10)*(-abs(sin(theta(10)))*(B(8,2)-B(10,2))+abs(cos(theta(10)))*(B(8,3)-B(10,3)));
        Shear_torque=Shear_torque+q_open(12)*l(12)*(-abs(sin(theta(12)))*(B(8,2)-B(12,2))+abs(cos(theta(12)))*(B(12,3)-B(8,3)));
        Shear_torque=Shear_torque+q_open(13)*l(13)*(-abs(sin(theta(13)))*(B(8,2)-B(13,2))+abs(cos(theta(13)))*(B(13,3)-B(8,3)));
end




% we have two equations for the two unknown shear contribution of each
% panel. First equation is that both contributions must be the same. Putted
% in matrix form where b=[w1;w2], it can be written as shown below. Second
% equation is the torque equation. Both in matrix form and solve for the
% contributions.

%External moment at lower middle spar boom
T= Lift*((spar(2)-0.25)*c)+W_inert*((spar(3)+spar(1))/2-spar(2))*c;

%Note that if (spar(3)+spar(1))/2-spar(2) is negative, the contribution of
%the inertial loads opposes lift contribution to the total twist. Whereas
%if the contribution is positive, the inertial loads amplifies the twist
%generated by the lift. This has to be taken into account in the
%optimization. 


%solve for w
A=[K1*(sigma_1+alpha_1)+K2*delta(length(delta)) -K2*(sigma_2+alpha_2)-K1*delta(length(delta)) %!LLAMAMOS PANEL 1 AL DE LA DERECHA
    2*A_cell_1 2*A_cell_2]; %!ASSUMING CLOCKWISE
b=[0;T-Shear_torque];

w=A\b; %!CLOSED SHEAR FLOW

%Vector containing the overall shear flow.
q=zeros(length(q_open),1);

%Sum the additonal contribution of each cell to the q_open calculated.
for i=1:length(nB)/2
    q=q_open(i)+w(1);
end

for i=length(nB)/2+1:length(nB)
    q=q_open(i)+w(2);
end

q(length(q))=q_open(length(q))+w(2)-w(1);


%% Calculation of normal stress
for i=1:nB
    B(i,4)= Bending*B(i,3)/Ix;
end 

end


