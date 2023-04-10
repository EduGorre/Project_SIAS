clc;
clear all
close all 


%Plot style
set(groot, 'defaultLegendFontSize', 12);
set(groot, 'defaultTextFontSize', 15);
set(groot, 'defaultAxesFontSize', 13);
set(groot, 'defaultAxesLineWidth', 1.5);
set(groot, 'defaultAxesXMinorTick', 'on');
set(groot, 'defaultAxesYMinorTick', 'on');
set(groot, 'defaultLegendBox', 'on');
set(groot, 'defaultLegendLocation', 'best');
set(groot, 'defaultLineLineWidth',1);
set(groot, 'defaultLineMarkerSize', 5);
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');


A=1e-4:1e-4:1e-2;
nB=10;
Bending_section=[1000;1000;1000];
naca=[0.14;0.12;0.09];
chord=[11.9, 7.15, 4.2];


spar1=[0.15;0.2;0.25];
spar2=[0.47;0.50;0.53];



%% Sensitivity analysis for the boom areas effect on the stress
% Front spar boom area effect


Ix_front=zeros(100,3,9);
sigma_front=struct('Boom_stress',{'root','kink','75% wing'});
counter=0;
for z=1:3
    for y=1:3
        counter=counter+1;
        spar=[spar1(z), spar2(y), 0.75];
        for i=1:3
            stress=zeros(nB,length(A));
            a=1e-4*ones(nB,1);
            for j=1:100
                for k=1:nB
                [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
                stress(k,j)=B(k,4);
                end
                Ix_front(j,i,counter)=Ix_sol;
                a(8)=a(8)+1e-4;
                a(9)=a(9)+1e-4;
            end
            sigma_front(i).Boom_stress=stress;
        end
    end
end


% Left intermediate boom area effect

Ix_inter_front=zeros(100,3);
sigma_inter_front=struct('Boom_stress',{'root','kink','75% wing'});
counter=0;
for z=1:3
    for y=1:3
        counter=counter+1;
        spar=[spar1(z), spar2(y), 0.75];
        for i=1:3
            stress=zeros(nB,length(A));
            a=1e-4*ones(nB,1);
            for j=1:100
                for k=1:nB
                [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
                stress(k,j)=B(k,4);
                end
                Ix_inter_front(j,i, counter)=Ix_sol;
                a(7)=a(7)+1e-4;
                a(10)=a(10)+1e-4;
            end
            sigma_inter_front(i).Boom_stress=stress;
        end
    end
end


% Mid spar boom area effect

Ix_mid=zeros(100,3);
sigma_mid=struct('Boom_stress',{'root','kink','75% wing'});
counter=0;
for z=1:3
    for y=1:3
        counter=counter+1;
        spar=[spar1(z), spar2(y), 0.75];
        for i=1:3
            stress=zeros(nB,length(A));
            a=1e-4*ones(nB,1);
            for j=1:100
                for k=1:nB
                [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
                stress(k,j)=B(k,4);
                end
                Ix_mid(j,i, counter)=Ix_sol;
                a(1)=a(1)+1e-4;
                a(6)=a(6)+1e-4;
            end
            sigma_mid(i).Boom_stress=stress;
        end
    end
end
        
% Right intermediate boom area effect

Ix_inter_rear=zeros(100,3);
sigma_inter_rear=struct('Boom_stress',{'root','kink','75% wing'});
counter=0;
for z=1:3
    for y=1:3
        counter=counter+1;
        spar=[spar1(z), spar2(y), 0.75];
        for i=1:3
            stress=zeros(nB,length(A));
            a=1e-4*ones(nB,1);
            for j=1:100
                for k=1:nB
                [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
                stress(k,j)=B(k,4);
                end
                Ix_inter_rear(j,i, counter)=Ix_sol;
                a(2)=a(2)+1e-4;
                a(5)=a(5)+1e-4;
            end
            sigma_inter_rear(i).Boom_stress=stress;
        end
    end 
end

% Rear spar boom area effect

Ix_rear=zeros(100,3);
sigma_rear=struct('Boom_stress',{'root','kink','75% wing'});
counter=0;
for z=1:3
    for y=1:3
        counter=counter+1;
        spar=[spar1(z), spar2(y), 0.75];
        for i=1:3
            stress=zeros(nB,length(A));
            a=1e-4*ones(nB,1);
            for j=1:100
                for k=1:nB
                [B,Ix_sol]= Find_normal (spar,chord(i),naca(i),Bending_section(i),a);
                stress(k,j)=B(k,4);
                end
                Ix_rear(j,i, counter)=Ix_sol;
                a(3)=a(3)+1e-4;
                a(4)=a(4)+1e-4;
            end
            sigma_rear(i).Boom_stress=stress;
        end
    end
end

%% Batch plotter for every spar configuration

figure()
hold on
for i=1:9
    if i<=3
        plot(A, Ix_inter_front(:,1,i),'-square')
    
    elseif i<=6
        plot(A, Ix_inter_front(:,1,i),'-^')   
    else
        plot(A, Ix_inter_front(:,1,i),'-o')
    end

end
title('Inter-front spar boom area effect on section inertia')
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
legend('[0.15,0.47,0.75]', '[0.15,0.50,0.75]', '[0.15,0.53,0.75]','[0.20,0.47,0.75]', '[0.20,0.50,0.75]', '[0.20,0.53,0.75]', '[0.25,0.47,0.75]', '[0.25,0.5,0.75]', '[0.25,0.53,0.75]')

%% Plotter for one concrete spar configuration
%{
Configuration number:
- 1 --> [0.15,0.47, 0.75]
- 2 --> [0.15,0.50, 0.75]
- 3 --> [0.15,0.53, 0.75]
- 4 --> [0.20,0.47, 0.75]
- 5 --> [0.20,0.50, 0.75]
- 6 --> [0.20,0.53, 0.75]
- 7 --> [0.25,0.47, 0.75]
- 8 --> [0.25,0.50, 0.75]
- 9 --> [0.25,0.53, 0.75]

%}
spar_config=1;

% Spar plots
figure()
plot( A, Ix_front(:,1, spar_config))
hold on
plot( A, Ix_front(:,2, spar_config))
plot( A, Ix_front(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Front spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

figure()
plot( A, Ix_inter_front(:,1, spar_config))
hold on
plot( A, Ix_inter_front(:,2, spar_config))
plot( A, Ix_inter_front(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Inter-front spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

figure()
plot( A, Ix_mid(:,1, spar_config))
hold on
plot( A, Ix_mid(:,2, spar_config))
plot( A, Ix_mid(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Mid spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

figure()
plot( A, Ix_inter_rear(:,1, spar_config))
hold on
plot( A, Ix_inter_rear(:,2, spar_config))
plot( A, Ix_inter_rear(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Inter-rear spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

figure()
plot( A, Ix_rear(:,1, spar_config))
hold on
plot( A, Ix_rear(:,2, spar_config))
plot( A, Ix_rear(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Front spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

figure()
plot( A, Ix_front(:,1, spar_config))
hold on
plot( A, Ix_front(:,2, spar_config))
plot( A, Ix_front(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Front spar boom area effect on the section inertia')
legend('Section 1', 'Section 2', 'Section 3')

%Section Plots
figure()
plot(A, Ix_front(:,1, spar_config))
hold on
plot(A, Ix_inter_front(:,1, spar_config))
plot(A, Ix_mid(:,1, spar_config))
plot(A, Ix_inter_rear(:,1, spar_config))
plot(A, Ix_rear(:,1, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Boom area effect on section 1 inertia')
legend('Front', 'Inter-front', 'Mid','Inter-rear', 'Rear')

figure()
plot(A, Ix_front(:,2, spar_config))
hold on
plot(A, Ix_inter_front(:,2, spar_config))
plot(A, Ix_mid(:,2, spar_config))
plot(A, Ix_inter_rear(:,2, spar_config))
plot(A, Ix_rear(:,2))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Boom area effect on section 2 inertia')
legend('Front', 'Inter-front', 'Mid','Inter-rear', 'Rear')

figure()
plot(A, Ix_front(:,3, spar_config))
hold on
plot(A, Ix_inter_front(:,3, spar_config))
plot(A, Ix_mid(:,3, spar_config))
plot(A, Ix_inter_rear(:,3, spar_config))
plot(A, Ix_rear(:,3, spar_config))
xlabel('Boom Area ($m^2$)')
ylabel('$I_x$')
title('Boom area effect on section 3 inertia')
legend('Front', 'Inter-front', 'Mid','Inter-rear', 'Rear')

%% Conclusions
%The infliuence of the area increase in the increase of Ix is the following
%one:

% Inter_front> front >(by little) mid > inter_rear> rear

% Stress will be lager for the booms with higer y-coordinate, and Ix will
% increase the most with increasing the area of the booms with larger
% y-coordinate. Therefore, the most convenient way to increase Ix will be
% increasing the areas in the order shown above, therefore in our code this
% constrain will be imposed.

%A(inter_front)> A(front)>(by little) A(mid)> A(inter_rear)> A(rear)

% With the simplified configuration, inter_front influence will be always
% between influence of front and influence of mid. Hence for the simplified
% configuration calculation:

%A(Front)> A(inter_front)> A(mid)> A(inter_rear)> A(rear)