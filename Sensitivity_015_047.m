clc;
clear all
close all 

A=1e-4:1e-4:1e-2;
nB=10;
Bending_section=[1000;1000;1000];
naca=[0.14;0.12;0.09];
chord=[11.9, 7.15, 4.2];
spar=[0.15;0.47;0.75];


%% Sensitivity analysis for the boom areas effect on the stress
% Front spar boom area effect

Ix_front=zeros(100,3);
sigma_front=struct('Boom_stress',{'root','kink','75% wing'});

for i=1:3
    stress=zeros(nB,length(A));
    a=1e-4*ones(nB,1);
    for j=1:100
        for k=1:nB
        [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
        stress(k,j)=B(k,4);
        end
        Ix_front(j,i)=Ix_sol;
        a(8)=a(8)+1e-4;
        a(9)=a(9)+1e-4;
    end
    sigma_front(i).Boom_stress=stress;
end

% Left intermediate boom area effect

Ix_inter_front=zeros(100,3);
sigma_inter_front=struct('Boom_stress',{'root','kink','75% wing'});

for i=1:3
    stress=zeros(nB,length(A));
    a=1e-4*ones(nB,1);
    for j=1:100
        for k=1:nB
        [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
        stress(k,j)=B(k,4);
        end
        Ix_inter_front(j,i)=Ix_sol;
        a(7)=a(7)+1e-4;
        a(10)=a(10)+1e-4;
    end
    sigma_inter_front(i).Boom_stress=stress;
end


% Mid spar boom area effect

Ix_mid=zeros(100,3);
sigma_mid=struct('Boom_stress',{'root','kink','75% wing'});

for i=1:3
    stress=zeros(nB,length(A));
    a=1e-4*ones(nB,1);
    for j=1:100
        for k=1:nB
        [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
        stress(k,j)=B(k,4);
        end
        Ix_mid(j,i)=Ix_sol;
        a(1)=a(1)+1e-4;
        a(6)=a(6)+1e-4;
    end
    sigma_mid(i).Boom_stress=stress;
end

% Right intermediate boom area effect

Ix_inter_rear=zeros(100,3);
sigma_inter_rear=struct('Boom_stress',{'root','kink','75% wing'});

for i=1:3
    stress=zeros(nB,length(A));
    a=1e-4*ones(nB,1);
    for j=1:100
        for k=1:nB
        [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
        stress(k,j)=B(k,4);
        end
        Ix_inter_rear(j,i)=Ix_sol;
        a(2)=a(2)+1e-4;
        a(5)=a(5)+1e-4;
    end
    sigma_inter_rear(i).Boom_stress=stress;
end

% Rear spar boom area effect

Ix_rear=zeros(100,3);
sigma_rear=struct('Boom_stress',{'root','kink','75% wing'});

for i=1:3
    stress=zeros(nB,length(A));
    a=1e-4*ones(nB,1);
    for j=1:100
        for k=1:nB
        [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
        stress(k,j)=B(k,4);
        end
        Ix_rear(j,i)=Ix_sol;
        a(3)=a(3)+1e-4;
        a(4)=a(4)+1e-4;
    end
    sigma_rear(i).Boom_stress=stress;
end

%% Conclusions
%The influence of the area increase in the increase of Ix is the following
%one:

% Inter_front> mid> front > inter_rear> rear

% Stress will be lager for the booms with higer y-coordinate, and Ix will
% increase the most with increasing the area of the booms with larger
% y-coordinate. Therefore, the most convenient way to increase Ix will be
% increasing the areas in the order shown above, therefore in our code this
% constrain will be imposed.

%A(inter_front)> A(mid)> A(front)> A(inter_rear)> A(rear)

% With the simplified configuration, inter_front influence will be always
% between influence of front and influence of mid. Hence for the simplified
% configuration calculation:

%A(Mid)> A(inter_front)> A(front)> A(inter_rear)> A(rear)
