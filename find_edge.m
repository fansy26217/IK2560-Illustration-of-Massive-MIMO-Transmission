function [P1,P2] = find_edge(p,p_next,x_block,y_block)
% p = [0.1 0.85];
% p_next = [0.1 0.75];
% x_block = [0 0 0.8 0.2 0.6];
% y_block = [0 0.6 1 0.8 0.2];
A = zeros(length(x_block),1);
B = zeros(length(x_block),1);
C = zeros(length(x_block),1);
n = length(x_block);
for i = 1:(n-1)
    A(i) = y_block(i+1) - y_block(i);
    B(i) = x_block(i) - x_block(i+1);
    C(i) = x_block(i+1)*y_block(i) - x_block(i)*y_block(i+1);
end
 A(n) = y_block(1) - y_block(n);
 B(n) = x_block(n) - x_block(1);
 C(n) = x_block(1)*y_block(n) - x_block(n)*y_block(1);

 for k = 1:(n)
    if((A(k)*p(1) + B(k)*p(2) + C(k)) * ...
            (A(k)*p_next(1) + B(k)*p_next(2) + C(k))>0)
        continue
    else
        if(k<n)
            P1 = [x_block(k),y_block(k)];
            P2 = [x_block(k+1),y_block(k+1)];
        else
            P1 = [x_block(k),y_block(k)];
            P2 = [x_block(1),y_block(1)];
        end
        break
    end
 end
end


