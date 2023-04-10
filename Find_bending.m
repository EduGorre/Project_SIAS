%{
    DESCRIPTION: 
        -> This function computes the bending moment distribution along the
        wing span by summing up every contribution to the bending moment from each section of the
        wing for an specific nu position. As it can be seen, the function
        adds the contribution of the engine and the landing gear (point
        forces) whether the index of the for loop is not ahead of this points.

    INPUTS: 
        -> n_span_points: Number of points used to describe wing spanwise characteristics from root to tip  (integer)
        -> fuel weight_dist, b/2lift_dist: Distribution of the fuel weight and lift, respectively. Input expected from team A (1xn_span_points double)
        -> wing_length: b/2
        -> engine_pos: Nu index corresponding to the engine position  (integer)
        -> landing_gear_pos: Nu index corresponding to the landing gear position  (integer)
        -> engine_weight: Engine weight  (float)
        -> landing_gear_weight: Landing gear weight  (float)
        -> nu: Non-dimensional wingspan (1xn_span_points double)

        
    
    OUTPUTS: 
        -> bending_moment_dist: Bending moment distribution along the wingspan [-] (float) 
       
%}

function [bending_moment_dist] = Find_bending (n_span_points, fuel_weight_dist,lift_dist, wing_weight_dist,  wing_length, engine_pos,landing_gear_pos, engine_weight, landing_gear_weight, nu)

bending_moment_dist = zeros(1, n_span_points);

for span_pos = 1:100
    iter_range = span_pos:n_span_points;
    force_distribution = sum((lift_dist(iter_range)-fuel_weight_dist(iter_range)-wing_weight_dist(iter_range))) .* (nu(iter_range)-nu(span_pos)) * wing_length;

    if span_pos > engine_pos
        bending_moment_dist(span_pos) = force_distribution;
    elseif span_pos > landing_gear_pos
        bending_moment_dist(span_pos) = force_distribution - engine_weight * (nu(engine_pos)-nu(span_pos))*wing_length;
    else
        bending_moment_dist(span_pos) = force_distribution - engine_weight * (nu(engine_pos)-nu(span_pos))*wing_length - landing_gear_weight * (nu(landing_gear_pos)-nu(span_pos))*wing_length;
    end
end

end
