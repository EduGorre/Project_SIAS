function [W_inert] = Weight_definition (c, z, eta, eta_sec1, surface, W_w, W_e, rho_f, ndsa)

%This functions calculates the total wight taking into account both
%structural and inertial loads.
%The imputs are:

%c: chord provided by the team A.
%z: height of top surface of wing from cord
%eta: calculated in main
%surface: ?
%W_w: structural weight of the wing
%W_lgm: inertial weight of the landing gear (Safran) calculated by:
W_max=172365.1; %Max plane weight at landing 
W_lgm=40+0.16*W_max^0.75+0.019*W_max+1.5*10e-5*W_max^1.5; %Approximation given
% by Torenbeek for airliner-type aircraft.

%W_e: inertial weight of the engines (GEnx-1B: 6,147 kg or Trent 1000: 5765 kg)

%rho_f: density pof the fuel
g=9.81; %Gravity
n_z=3; %Load factor
%ndsa: fuel tank volume

%% Calculation of the data for the problem

%Structural weight

W_structural = W_w/surface*n_z*c; %this needs to be distributed across the surface


%Inertial weight

W_landinggear = (W_lgm * n_z) /2; %This weight is located 4.9m from the root

W_engine = W_e*n_z; %This weight is located 9.73m from the root

h=z*2;
ndsa_sect1= integral (h,eta_sec1(1), eta_sec1(3));
ndsa_sect23= integral (h,eta(1), eta(3));
ndsa=ndsa_sect1+ndsa_sect23;

W_fuel = rho_f*g*n_z*c^2*ndsa; %This weight needs to be distributed acroos the fuel tank


%Total weigth

W_inert = W_structural + W_landinggear + W_engine + W_fuel;

end

