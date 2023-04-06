%% AIRCRAFT DATA - METRIC 
b=60;
height=17;
length=57;
range=13530;

%chi_fs: position of front spar
%chi_rs: position of rear spar
%eta: non-dimensional position in the spanwise (to be analysed)
%chord_data includes: c_k, c_cl,c_r, c_t
%span_data includes: b, b_k (distance between the two kinks)
%y_r = diameter of the fuselage

function [lift,fuel_weight] = find_inertial_loads(chord_data,span_data,y_r, chi_fs,chi_rs,eta)

%Calculation of lift distribution given a position of the spanwise
%direction

S_in = 0.5*(chord_data.c_k+chord_data.c_cl)*span_data.b_k;
S_out = 0.5*(chord_data.c_k+chord_data.c_t)*(span_data.b-span_data.b_k);
S_fus = 0.5*(chord_data.c_r+chord_data.c_l)*y_r;

S_e =S_in+S_out-S_fus;

c_re = (2*S_e/(span_data.b-y_r))-chord_data.c_t;
c_cle = (span_data.b*c_re-y_r*chord_data.c_t)/(span_data.b-y_r);

lambda_e = chord_data.c_t/c_cle;

lambda_e_25 = atan(tand(32.2)-0.5*(c_cle*(1-lambda_e))/span_data.b);

%Calculate C_L based on:
n_z = 2.5; %Pull-up load factor
W_max = 228930; %MTOW [kg]
rho_c = 0.364;  %@42,975 ft in [kg/m^3]
V_c = 903; %[km/h]
C_L = (2*n_z*W_max)/(S_e*rho_c*V_c^2);
Mach = 0.85;

C_L_w = 1.05*C_L; %Wing lift coefficient adjusted for compressibility effects ? CHECK.

beta = sqrt(1-Mach^2);

lambda_beta = lambda_e_25 / atan(beta);

c_l_alpha = (2*pi)/(sqrt(1-(Mach*cos(lambda_e_25))^2));

AR_e = (span_data.b^2)/S_e

C_L_alpha = (2*pi*AR_e)/(2+sqrt(((2*pi*AR_e)/(cos(lambda_beta)*c_l_alpha))^2+4));


%Calculation of the fuel weight distribution given 

end