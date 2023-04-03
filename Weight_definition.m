function [W_inert] = Weight_definition (c, surface, W_w, W_lgm, W_e, rho_f)

%This functions calculates the total wight taking into account both
%structural and inertial loads.
%The imputs are:

%c: chord provided by the team A.
%surface: ?
%W_w: structural weight of the wing
%W_lgm: inertial weight of the landing gear
%W_e: inertial weight of the engines
%rho_f: density pof the fuel
n_z=3; %Load factor

%% Calculation of the data for the problem

%Structural weight

W_structural= W_w/surface*n_z*c;

