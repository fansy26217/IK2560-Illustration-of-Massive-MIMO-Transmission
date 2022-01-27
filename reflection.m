function vector = reflection(vi, p1, p2)
[theta_i,r_i] = cart2pol(vi(1),vi(2));
vl = p1-p2;
[theta_l,~] = cart2pol(vl(1),vl(2));
theta_o = 2*theta_l - theta_i;
[vector(1),vector(2)] = pol2cart(theta_o, r_i); 
end