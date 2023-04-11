%This functions calculates the total wight taking into account both
%structural and inertial loads.
%The imputs are:

function [W_total, W_structural, W_landinggear, engine_weight] = Weight_definition (c, surface, W_w, n_span_points, wing_span)

%c: chord provided by the team A.
%surface: ?
%W_w: structural weight of the wing
%W_lgm: inertial weight of the landing gear (Safran) calculated by:
W_max=172365.1; %Max plane weight at landing 
W_lgm=40+0.16*W_max^0.75+0.019*W_max+1.5*10e-5*W_max^1.5; %Approximation given
% by Torenbeek for airliner-type aircraft.

W_e= 6147; %inertial weight of the engines (GEnx-1B: 6,147 kg or Trent 1000: 5765 kg)
n_z=3; %Load factor

%% Calculation of the data for the problem

%Structural weight

W_structural = W_w/surface*n_z*c; %this needs to be distributed across the surface


%Inertial weight


landing_gear_weight=zeros(1,n_span_points);
W_landinggear = (W_lgm * n_z) /2; %This weight is located 4.9m from the root
landing_gear_pos=(4.9/wing_span)*(n_span_points);
landing_gear_pos=round(landing_gear_pos);
landing_gear_weight(1,landing_gear_pos)=W_landinggear;

engine_weight = W_e*n_z; %This weight is located 9.73m from the root
engine_pos=(9.73/wing_span)*(n_span_points);


%Total weigth

W_total = W_structural + W_landinggear + engine_weight + W_fuel;

end

