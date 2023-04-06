%% AIRCRAFT DATA - METRIC 
%b=60;
%height=17;
%length=57;
%range=13530;


%% helpers
%Calculation of the Additional Lift Distribution : L_A(eta)
function L_A =additiona_lift(eta,AR,c_l_alpha,lambda_e_25,c_mean)

%Get the Similitude parameter, F
F = (2*pi*AR)/(c_l_alpha*cos(lambda_e_25))
%Get Coeffs C1, C2,C3 from graph
C1 = 
C2 = 
C3 = 
%Get value of f from graph

end
%Calculation of the Basic Lift Distribution : L_B(eta)
function L_B =basic_lift(eta)

end


%% main function
function [c_l] = find_lift_distrib(chord_data,span_data,y_r,eta_dim)

%---INPUTS-----
% chord_data:  a struct that provides the values for: c_k, c_cl, c_t
%  span_data:  a struct that provides the values for: b (wingspan), b_k (which is the distance between the two kinks)
%        y_r:  The diameter of the fuselage, which I dont think I need!
%    eta_dim:  The required dimensions for the vector of eta. eta is
%    y/(b/2), the adimensional coordinate of the wing, as you are dividing
%    by half the span

%---OUTPUTS----
%       c_l : a vector,the Lift coefficient 2D distribution as a function of eta

% - - - - - - - 
% - - - - - - -

%Create the vector of positions along the span
eta = linspace(0:1:eta_dim);

%Allocate a vector to relate the different lift coefficients to the positions of eta
c_l = zeros(1,eta_dim)



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

epsilon_t = ????? 

%Calculation of the Lift distribution 

for i = 1:eta_dim
    %Chord at specific eta value
    c_eta = c_cle*(1-(1-lambda_e)*eta(i)); %In-between parenthesis is the equivalent wing chord 
    L_A =additiona_lift(eta(i),AR,c_l_alpha,lambda_e_25,c_mean);
    
    c_l(i) = (c_mean*(C_L_w*L_A+epsilon_t*C_L_alpha*L_B))/c_eta;
end


end