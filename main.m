%% SIAS_PROJECT I
clc;
clear;

%% DATA
sweep=32.2; %degrees
b=58;

% Import coordinates
nacas=[0.14 0.12 0.09];
z= @(x,naca) 5*naca.*(0.2969.*sqrt(x)-0.126.*x-0.3516.*x.^2+0.2843.*x.^3-0.1015.*x.^4);

% t/c for each section: fuselage, kink, 75%
tc1=14; tc2=12; tc3=09;   

% Nominal spar positions: only sections 2 and 3 (section 1 should be
% calculated due to kink)
eta_front=[0.15 0.20 0.25]; eta_mid=[0.47 0.5 0.53]; eta_rear=[0.65 0.7 0.75];

% Chord for each section
chord=[11.9, 7.15, 4.2];

% y-coordinate for each section
y_pos=[3, 10.6, 20.8];

%% CALCULATIONS
% Initial and final x-coordinate of each airfoil (LE and TE)
% x1 corresponds to section 1
x1=[y_pos(1)*tand(sweep), y_pos(1)*tand(sweep)+chord(1)];
x2=[y_pos(2)*tand(sweep), y_pos(2)*tand(sweep)+chord(2)];
x3=[y_pos(3)*tand(sweep), y_pos(3)*tand(sweep)+chord(3)];

% Leading and trailing edge definition 
x_LE=@(y) tand(sweep)*y;
x_TE=@(y) (y<y_pos(2)).*(x1(2))+(y>y_pos(2)).*((x3(2)-x2(2))/(y_pos(3)-y_pos(2)).*(y-y_pos(2))+x2(2));

% Parameters for aerodynamics:
% c_K=chord(2)
% c_R=chord(1)
% gamma_LE=sweep
y_R=y_pos(1)*2;
b_K=y_pos(2)*2;
c_CL=x_TE(0)-x_LE(0);

%% OPTIMIZATION OF NOMINAL CASE
% Fixing position of spars
eta=[eta_front(2),eta_mid(2),eta_rear(3)]; 

% Calculation of eta for section 1
[eta_sec_1]=wing_box_def(eta,chord,y_pos,x1,x2,x3,b,x_LE,x_TE);

%% ITERATION FOR ALL POSSIBLE COMBINATIONS OF SPAR LOCATIONS

% for i=eta_front
%     for j=eta_mid
%         for k=eta_rear
%             
%         end
%     end
% end

%% PLOTS
x_vec=linspace(0,1,99);
y_vec=linspace(0,b/2,100);

figure()
plot(x_vec,z(x_vec,nacas(3)),x_vec,-z(x_vec,nacas(3)),'color',[0, 0.4470, 0.7410])
hold on 
plot(x_vec,z(x_vec,nacas(2)),x_vec,-z(x_vec,nacas(2)),'color',[0.8500, 0.3250, 0.0980])
hold on
plot(x_vec,z(x_vec,nacas(1)),x_vec,-z(x_vec,nacas(1)),'color',[0.9290, 0.6940, 0.1250])
title('Normalized Airfoils','Interpreter','latex')
xlabel('x/c','Interpreter','latex')
ylabel('z/c','Interpreter','latex')
legend('NACA 0009','NACA 0012','NACA 0014','Interpreter','latex')
set(gca,'TickLabelInterpreter','latex');
axis equal

figure()
plot3(x1(1)+x_vec*chord(1),y_pos(1)*ones(1,99),z(x_vec,nacas(1))*chord(1),'b', x1(1)+x_vec*chord(1),y_pos(1)*ones(1,99),-z(x_vec,nacas(1))*chord(1),'b')
hold on 
plot3(x2(1)+x_vec*chord(2),y_pos(2)*ones(1,99),z(x_vec,nacas(2))*chord(2),'b',x2(1)+x_vec*chord(2),y_pos(2)*ones(1,99),-z(x_vec,nacas(2))*chord(2),'b')
hold on
plot3(x3(1)+x_vec*chord(3),y_pos(3)*ones(1,99),z(x_vec,nacas(3))*chord(3),'b',x3(1)+x_vec*chord(3),y_pos(3)*ones(1,99),-z(x_vec,nacas(3))*chord(3),'b')
hold on
plot3(x_LE(y_vec),y_vec,zeros(1,100),'b')
hold on
plot3(x_TE(y_vec),y_vec,zeros(1,100),'b')
title('Wing definition','Interpreter','latex')
xlabel('x','Interpreter','latex')
ylabel('y','Interpreter','latex')
zlabel('z','Interpreter','latex')
set(gca,'TickLabelInterpreter','latex');
axis equal
