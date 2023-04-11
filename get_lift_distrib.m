
function [c_l,eta] = get_lift_distrib(chord_data,span_data,y_r,n_span_points)

%---INPUTS-----
% chord_data:  a struct that provides the values for: c_k, c_cl, c_t, c_r.
%  span_data:  a struct that provides the values for: b (wingspan), b_k (which is the distance between the two kinks).
%        y_r:  The diameter of the fuselage.
%    n_span_points:  The required dimensions for the vector of eta. eta is
%    y/(b/2), the adimensional coordinate of the wing, as you are dividing
%    by half the span

%---OUTPUTS----
%       c_l : a vector,the Lift coefficient 2D distribution as a function of eta
%       eta : non-dimensional spanwise parameter vector. 
% - - - - - - - 
% - - - - - - -


%f for Additional Lift: 

l0 = readmatrix('csv/Lambda_0.csv');

p_l0 = polyfit(l0(:,1),l0(:,2),2);


%Create the vector of positions along the span
eta = linspace(0,1,n_span_points);

%Allocate a vector to relate the different lift coefficients to the positions of eta
c_l = zeros(1,n_span_points);



%Areas
S_in = 0.5*(chord_data.c_k+chord_data.c_cl)*span_data.b_k;
S_out = 0.5*(chord_data.c_k+chord_data.c_t)*(span_data.b-span_data.b_k);
S_fus = 0.5*(chord_data.c_r+chord_data.c_cl)*y_r;

S_e =S_in+S_out-S_fus;

c_re = (2*S_e/(span_data.b-y_r))-chord_data.c_t;
c_cle = (span_data.b*c_re-y_r*chord_data.c_t)/(span_data.b-y_r);

lambda_e = chord_data.c_t/c_cle;

lambda_e_25 = atan(tand(32.2)-0.5*(c_cle*(1-lambda_e))/span_data.b);

%Calculate C_L based on the numerical data:

n_z = 2.5; %Pull-up load factor
W_max = 228930; %MTOW [kg]
rho_c = 0.364;  %@42,975 ft in [kg/m^3]
V_c = 250.833; %[m/s] 
C_L = (2*n_z*W_max)/(S_e*rho_c*V_c^2);
Mach = 0.85; %Cruise mach number [-]

C_L_w = 1.05*C_L; %Wing lift coefficient adjusted for compressibility effects

beta = sqrt(1-Mach^2); % [rad] = 0.5268 rad ---> 30.18deg ~ 30deg

lambda_beta = lambda_e_25 / atan(beta);

c_l_alpha = (2*pi)/(sqrt(1-(Mach*cos(lambda_e_25))^2));

AR_e = (span_data.b^2)/S_e;

C_L_alpha = (2*pi*AR_e)/(2+sqrt(((2*pi*AR_e)/(cos(lambda_beta)*c_l_alpha))^2+4));

c_mean = S_e/span_data.b;

epsilon_t = 3*(pi/180); %[rad]

%Calculation of the Lift distribution 
lbsum = zeros(1,n_span_points);
for i = 1:n_span_points
    %Chord at specific eta value
    c_eta = c_cle*(1-(1-lambda_e)*eta(i)); %In-between parenthesis is the equivalent wing chord 

    [L_A,C4] =additiona_lift(eta(i),AR_e,c_l_alpha,lambda_e_25,c_mean,c_eta,p_l0);

    L_B =basic_lift(eta(i),L_A,C4);
    lbsum(i) = L_B;

    c_l(i) = (c_mean*(C_L_w*L_A + epsilon_t*C_L_alpha*L_B));
end


%% helpers
%Calculation of the Additional Lift Distribution : L_A(eta)
function [L_A,C4] =additiona_lift(eta,AR,c_l_alpha,lambda_e_25,c_mean,c_eta, p_l0)

%Get the Similitude parameter, F
F = (2*pi*AR)/(c_l_alpha*cos(lambda_e_25));

%Get Coeffs C1, C2,C3 from graph given the value of F 

C = get_Diederich_coeffs(F);
C4 = C(4);

f = polyval(p_l0,eta);

L_A = C(1)*(c_eta/c_mean)+C(2)*(4/pi)*sqrt(1-(eta)^2)+C(3)*f;
end


%Calculation of the Basic Lift Distribution : L_B(eta)
function L_B =basic_lift(eta,L_A,C4)

expr = @(eta) eta*L_A;
alpha_01=integral( expr , 0 , 1 ); 

L_B = L_A*C4*(eta.^2-alpha_01);
end


end





