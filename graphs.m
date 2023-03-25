clc;        clear;      close all;

default_settings();
%% Coefficients
c1 = readmatrix('C1.csv');
c2 = readmatrix('C2.csv');
c3 = readmatrix('C3.csv');
c4 = readmatrix('C4.csv');

x = linspace(0,14,1000);

p_c1 = polyfit(c1(:,1),c1(:,2),2);
y_c1 = polyval(p_c1,x);

p_c2 = polyfit(c2(:,1),c2(:,2),2);
y_c2 = polyval(p_c2,x);

p_c3 = polyfit(c3(:,1),c3(:,2),2);
y_c3 = polyval(p_c3,x);

p_c4 = polyfit(c4(:,1),c4(:,2),2);
y_c4 = polyval(p_c4,x);

figure(1)
plot(x,y_c1,x,y_c2,x,y_c3,x,y_c4)
title('$Diederichs$ $Method$ $C_i$ $Coefficients$')
xlabel('$(2 \pi AR )/(C_{l\alpha}cos\Lambda_{0.25})$')
ylabel('$C_i$')
legend('$C_1$','$C_2$','$C_3$','$C_4$')
grid on

%% f

l0 = readmatrix('Lambda_0.csv');
l30 = readmatrix('Lambda_30.csv');
l45 = readmatrix('Lambda_45.csv');
l60 = readmatrix('Lambda_60.csv');

x_2 = linspace(0,1,1000);

p_l0 = polyfit(l0(:,1),l0(:,2),2);
y_l0 = polyval(p_l0,x_2);

p_l30 = polyfit(l30(:,1),l30(:,2),2);
y_l30 = polyval(p_l30,x_2);

p_l45 = polyfit(l45(:,1),l45(:,2),2);
y_l45 = polyval(p_l45,x_2);

p_l60 = polyfit(l60(:,1),l60(:,2),2);
y_l60 = polyval(p_l60,x_2);

figure(2)
plot(x_2,y_l0,x_2,y_l30,x_2,y_l45,x_2,y_l60)
title('$Diederichs$ $Method$ $Function$ $f$')
xlabel('$Non-dimensional$ $Lateral$ $Co-ordinate$ $\eta$')
ylabel('$f$')
legend('$\Lambda_{\beta}=0^{\circ}$','$\Lambda_{\beta}=30^{\circ}$','$\Lambda_{\beta}=45^{\circ}$','$\Lambda_{\beta}=60^{\circ}$')
grid on






