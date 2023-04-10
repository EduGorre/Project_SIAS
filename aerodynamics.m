clc;
clear all;
close all;

%% AIRCRAFT DATA - METRIC 
%b=60;
%height=17;
%length=57;
%range=13530;

%Graphs: 

c1 = readmatrix('csv/C1.csv');
c2 = readmatrix('csv/C2.csv');
c3 = readmatrix('csv/C3.csv');
c4 = readmatrix('csv/C4.csv');

x = linspace(0,14,1000);

p_c1 = polyfit(c1(:,1),c1(:,2),2);
y_c1 = polyval(p_c1,x);

p_c2 = polyfit(c2(:,1),c2(:,2),2);
y_c2 = polyval(p_c2,x);

p_c3 = polyfit(c3(:,1),c3(:,2),2);
y_c3 = polyval(p_c3,x);

p_c4 = polyfit(c4(:,1),c4(:,2),2);
y_c4 = polyval(p_c4,x);

l0 = readmatrix('csv/Lambda_0.csv');
l30 = readmatrix('csv/Lambda_30.csv');
l45 = readmatrix('csv/Lambda_45.csv');
l60 = readmatrix('csv/Lambda_60.csv');

x_2 = linspace(0,1,1000);

p_l0 = polyfit(l0(:,1),l0(:,2),2);
y_l0 = polyval(p_l0,x_2);

p_l30 = polyfit(l30(:,1),l30(:,2),2);
y_l30 = polyval(p_l30,x_2);

p_l45 = polyfit(l45(:,1),l45(:,2),2);
y_l45 = polyval(p_l45,x_2);

p_l60 = polyfit(l60(:,1),l60(:,2),2);
y_l60 = polyval(p_l60,x_2);


%% helpers
%Calculation of the Additional Lift Distribution : L_A(eta)
function [L_A,C4] =additiona_lift(eta,AR,c_l_alpha,lambda_e_25,c_mean,c_eta, x, y_c1,y_c2,y_c3,y_c4,x_2,y_l30)

%Get the Similitude parameter, F
F = (2*pi*AR)/(c_l_alpha*cos(lambda_e_25))

%Get Coeffs C1, C2,C3 from graph given the value of F 

ind = interp1(x,1:length(x),F,'nearest');
C1 = y_c1(ind)
C2 = y_c2(ind)
C3 = y_c3(ind)
C4 = y_c4(ind)
%Get value of f from graph
ind2 = interp1(x_2,1:length(x_2),eta,'nearest');
f = y_130(ind2) %Taking Delta_beta as 30degrees, calculated before

L_A = C1*(c_eta/c_mean)+C2*(4/pi)*sqrt(1-(eta)^2)+C3*f
end


%Calculation of the Basic Lift Distribution : L_B(eta)
function L_B =basic_lift(eta,L_A,C4)

expr(eta) = eta*L_A;
alpha_01=int( expr , 0 , 1 );  %pag 18/48 CHECK!

L_B = L_A*C4*(eta-alpha_01);
end



%% main function
function [c_l] = find_lift_distrib(chord_data,span_data,y_r,n_span_points)

%---INPUTS-----
% chord_data:  a struct that provides the values for: c_k, c_cl, c_t
%  span_data:  a struct that provides the values for: b (wingspan), b_k (which is the distance between the two kinks)
%        y_r:  The diameter of the fuselage, which I dont think I need!
%    n_span_points:  The required dimensions for the vector of eta. eta is
%    y/(b/2), the adimensional coordinate of the wing, as you are dividing
%    by half the span

%---OUTPUTS----
%       c_l : a vector,the Lift coefficient 2D distribution as a function of eta

% - - - - - - - 
% - - - - - - -

%Create the vector of positions along the span
eta = linspace(0:1:n_span_points);

%Allocate a vector to relate the different lift coefficients to the positions of eta
c_l = zeros(1,n_span_points)



%Areas
S_in = 0.5*(chord_data.c_k+chord_data.c_cl)*span_data.b_k;
S_out = 0.5*(chord_data.c_k+chord_data.c_t)*(span_data.b-span_data.b_k);
S_fus = 0.5*(chord_data.c_r+chord_data.c_l)*y_r;

S_e =S_in+S_out-S_fus;

c_re = (2*S_e/(span_data.b-y_r))-chord_data.c_t;
c_cle = (span_data.b*c_re-y_r*chord_data.c_t)/(span_data.b-y_r);

lambda_e = chord_data.c_t/c_cle;

lambda_e_25 = atan(tand(32.2)-0.5*(c_cle*(1-lambda_e))/span_data.b);

%Calculate C_L based on the numerical data:

n_z = 2.5; %Pull-up load factor
W_max = 228930; %MTOW [kg]
rho_c = 0.364;  %@42,975 ft in [kg/m^3]
V_c = 903; %[km/h]
C_L = (2*n_z*W_max)/(S_e*rho_c*V_c^2);
Mach = 0.85;

C_L_w = 1.05*C_L; %Wing lift coefficient adjusted for compressibility effects ? CHECK.

beta = sqrt(1-Mach^2); % [rad ?] = 0.5268 rad ---> 30.18deg ~ 30deg

lambda_beta = lambda_e_25 / atan(beta);

c_l_alpha = (2*pi)/(sqrt(1-(Mach*cos(lambda_e_25))^2));

AR_e = (span_data.b^2)/S_e

C_L_alpha = (2*pi*AR_e)/(2+sqrt(((2*pi*AR_e)/(cos(lambda_beta)*c_l_alpha))^2+4));

c_mean = S_e/span_data.b

epsilon_t = 2.5* (pi/180) %[rad]

%Calculation of the Lift distribution 

for i = 1:n_span_points
    %Chord at specific eta value
    c_eta = c_cle*(1-(1-lambda_e)*eta(i)); %In-between parenthesis is the equivalent wing chord 
    [L_A,C4] =additiona_lift(eta(i),AR,c_l_alpha,lambda_e_25,c_mean,c_eta, x, y_c1,y_c2,y_c3,y_c4,x_2,y_l30);
    L_B =basic_lift(eta,L_A,C4);
    c_l(i) = (c_mean*(C_L_w*L_A+epsilon_t*C_L_alpha*L_B))/c_eta;
end


end