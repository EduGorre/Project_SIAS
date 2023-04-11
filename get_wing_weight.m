%{
    DESCRIPTION: 
        -> This function computes the wing weight distribution based on the
        assumption that it is distributed as a function of the chord of
        each seaction. Note that this function might NOT be used. This is
        still under consideration. 

    INPUTS: 
        -> total_wing_weight: Total weight of each wing (float)
        -> chord_dist: Chord distribution of the wing (array)
        
    
    OUTPUTS: 
        -> wing_weight_dist: Wing weight distribution (array) 
       
%}

function [wing_weight_dist] = get_wing_weight (total_wing_weight, chord_dist)

% Calculate the total length of the wing
chord_sum = sum(chord_dist);

% Calculate the weight per unit length
weight_per_length = total_wing_weight / chord_sum;

% Distribute the weight according to the chord
wing_weight_dist= weight_per_length * chord_dist;
end


