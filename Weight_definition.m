
%{
This functions calculates the total wight taking into account both
structural and inertial loads.
The imputs are:
    --> c: vector of chords provided by the team A.
    --> surface: total surface of the wing
    --> n_span_points: number of points the spain witll be divided on (100)
    --> wing_span: length of the wing (aprox 57m)
    --> w_fuel: vector with the distribution of the fuel accross the wing
    (optional and not needed for the other calculations)

The outputs are:
--> W_total_vector: vector with all the weights distrubuted accross the
span
--> W_structural: vector with the skin weights distrubuted accross the span
--> landing_gear_weight: number with the wight of the LG (n_z added)
--> landing_gear_pos: index of the vector where LG is located
--> engine_weight: number with the wight of the engine (n_z added)
--> engine_pos: index of the vector where engine is located
%}


function [W_total_vector, W_structural, landing_gear_weight, landing_gear_pos, engine_weight, engine_pos] = Weight_definition (chord, n_span_points, wing_span, W_fuel)

W_w= 7938; %structural weight of the wing (according to ChatGPT)
W_max=172365.1; %Max plane weight at landing 
W_lgm=40+0.16*W_max^0.75+0.019*W_max+1.5*10e-5*W_max^1.5; %Approximation given by Torenbeek for airliner-type aircraft.
W_e= 6147; %inertial weight of the engines (GEnx-1B: 6,147 kg or Trent 1000: 5765 kg)
n_z=3; %Load factor

%% Calculation of the data for the problem

%Structural weight

% Calculate the total length of the wing
chord_sum = sum(chord);

% Calculate the weight per unit length
weight_per_length = W_w * n_z / chord_sum;

% Distribute the weight according to the chord
W_structural= weight_per_length * chord_dist;


%Inertial weight


landing_gear_weight_vector=zeros(1,n_span_points);
landing_gear_weight = (W_lgm * n_z) /2; %This weight is located 4.9m from the root
landing_gear_pos=(4.9/wing_span)*(n_span_points);
landing_gear_pos=round(landing_gear_pos);
landing_gear_weight_vector(1,landing_gear_pos)=landing_gear_weight; %vector with the puntual weight of the lading gear

engine_weight_vector=zeros(1,n_span_points);
engine_weight = W_e*n_z; %This weight is located 9.73m from the root
engine_pos=(9.73/wing_span)*(n_span_points);
engine_pos=round(engine_pos);
engine_weight_vector(1,engine_pos)=engine_weight; %vector with the puntual weight of the engine


%Total weigth

W_total_vector = W_structural + landing_gear_weight_vector + engine_weight_vector + W_fuel;

end

