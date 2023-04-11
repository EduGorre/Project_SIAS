function [C] = get_Diederich_coeffs(F)
c1 = readmatrix('csv/C1.csv');
c2 = readmatrix('csv/C2.csv');
c3 = readmatrix('csv/C3.csv');
c4 = readmatrix('csv/C4.csv');

p_c1 = polyfit(c1(:,1),c1(:,2),2);
C(1) = polyval(p_c1,F);

p_c2 = polyfit(c2(:,1),c2(:,2),2);
C(2) = polyval(p_c2,F);

p_c3 = polyfit(c3(:,1),c3(:,2),2);
C(3) = polyval(p_c3,F);

p_c4 = polyfit(c4(:,1),c4(:,2),2);
C(4) = polyval(p_c4,F);

end









