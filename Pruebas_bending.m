clear;clc;

%DATA
n_span_points=100;
wing_span=27.8;
wing_length=wing_span*2;
% nu=linspace(0,1,n_span_points);
chord_data.c_k = 7.15; %Chord at the kink
chord_data.c_cl = 13.7892008257736; %CL is center line
chord_data.c_r = 11.9; %Chord at the root 
chord_data.c_t = 1.8284; %Chord at the tip
span_data.b = 58; % [m]
span_data.b_k = 10.6*2; %[m]
y_r = 3*2;

rho_c = 0.364;  %@42,975 ft in [kg/m^3]
V_c = 250.833; %[m/s] 

    %data nominal case
chi_fs=0.2;
chi_rs=0.7;


fuel_weight_dist = get_fuel_weight(chi_fs,chi_rs,n_span_points);

%WEIGHTS

[W_total_vector, wing_weight_dist, landing_gear_weight, landing_gear_pos, engine_weight, engine_pos] = Weight_definition (n_span_points, wing_span, fuel_weight_dist);

%Lift inventado
lift_dist=zeros(1,n_span_points);

%LIFT

[c_l,eta] = get_lift_distrib(chord_data,span_data,y_r,n_span_points);
lift_dist= c_l .* (rho_c * 0.5 * V_c^2);

%Bending
[bending_moment_dist] = Find_bending (n_span_points, fuel_weight_dist, lift_dist,...
    wing_weight_dist, wing_length, engine_pos, landing_gear_pos, engine_weight, landing_gear_weight, eta);



plot(eta,lift_dist);
title('Lift distribution across the wing','interpreter','latex')
xlabel('Non-dimentional span of the wing','interpreter','latex')
ylabel('Lift {N}','interpreter','latex')

