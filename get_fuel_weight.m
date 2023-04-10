
%{
    DESCRIPTION:
    This function calculates the fuel weight for each wing section based on the 
    position of the front and rear spars. It integrates the airfoil profile for 
    each section of the wing with the spars positions as the integration limits.

    INPUTS:
    - chi_fs: non-dimensional position of the front spar as a percentage of the cord. 
    - chi_rs: non-dimensional position of the rear spar as a percentage of the cord. 
    - n: number of sections the wing is divided in.

    OUTPUTS:
    - fuel_weight: vector with the fuel weight for each section of the
    wing.
%}

function fuel_weight = get_fuel_weight(chi_fs,chi_rs,n)

    x_TE = linspace(13.7892,18.8304,n);
    y_LE = linspace(0,23.2,n);
    %m = 4.60207887;
    %y_TE = m*(x_TE - 13.7892);
    x_LE = y_LE*tand(32.2);
    
    chord = x_TE-x_LE; %chord disribution up to 80% of the wing
    
    
    z= @(x,NACA) 5*NACA.*(0.2969.*sqrt(x)-0.126.*x-0.3516.*x.^2+0.2843.*x.^3-0.1015.*x.^4); 
    
    m1 = -0.002631579;
    m2 = -0.002941176;
    x = linspace(0,20.2,n);
    
    
    rho_f = 0.804;
    g = 9.81;
    n_z = 2.5;
    
    
    fuel_weight = zeros(1,n);
    for i = 1:n
        
        if x(i) <= 7.6
            NACA = 0.14 + m1*x(i);
    
        elseif x(i) > 7.6 && x(i) <= 17.8
                NACA = 0.12 + m2*(x(i)-7.6);
        else
            NACA = 0.09;
        end
    
        curve = @(x)z(x,NACA);
        fuel_weight(i) = rho_f * g * n_z * chord(i).^2 * 2 * integral(curve,chi_fs,chi_rs); %integral of the upper part of the airfoil curve, multiplied by 2 to account for the lower part.
    
    end
    
    






end