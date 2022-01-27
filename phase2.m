function pictures2 = phase2(maximum_time, angle, receive_i_1, receive_i_2,receive_i_3, receive_num_1, receive_num_2,receive_num_3, station_px, station_py, user_px, user_py, delta_t, v)
%% set parameters 参数设定
t_max = maximum_time;
t = 0:delta_t:t_max;

x_block1 = [0 0 0.4 2.1 1.2];    
y_block1 = [8.9 11 11 7.8 7.2];
x_block2 = [1.6 4.5 5 3.4];
y_block2 = [11 11 8.6 7.7];
x_block3 = [6.7 8.6 9.5 10 7.5];
y_block3 = [11 11 10.2 8.1 7.5];
x_block4 = [0 2.3 2.8 0];
y_block4 = [6.3 7.5 6.3 3.2];
x_block5 = [1.4 3.4 6 2];
y_block5 = [3.8 5.2 0 0];
x_block6 = [8 10.5 10.8 8.2];
y_block6 = [5.4 5.9 4.6 4];
x_block7 = [8.5 11 11 9.1];
y_block7 = [2.8 3.7 0 0];

%% initialize variable 变量初始化

% initialize display parameters 显示参数初始化
frame_num = int8(t_max/delta_t+1);    % the number of the frames of the animation 存储帧的数量
pictures2(frame_num) = struct('cdata',[],'colormap',[]);    % store each frame of the animation 用来存储每一帧动画

% initialize signal direction vectors 信号方向向量初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use1 对于用户1
vector(1,:) = [-1,-1];  % initial direction vectors of the signals 信号的初始方向向量
vector(1,:) = vector(1,:)/norm(vector(1,:));
[theta,r] = cart2pol(vector(1,1),vector(1,2));
vector_1 = zeros(receive_num_1,2);
rho_1 = zeros(1,receive_num_1);    % angles of the initial signal direction vectors 初始信号方向向量对应的角度值
for i = 1:receive_num_1    % angles of the initial signal direction vectors that received by the base station 基站接受到信号对应的初始方向向量的角度值
    rho_1(i) = theta + (receive_i_1(i)-1)*angle;
    [vector_1(i,1),vector_1(i,2)] = pol2cart(rho_1(i),r);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use2 对于用户2
vector_2 = zeros(receive_num_1,2);
rho_2 = zeros(1,receive_num_1);
for i = 1:receive_num_2
    rho_2(i) = theta + (receive_i_2(i)-1)*angle;
    [vector_2(i,1),vector_2(i,2)] = pol2cart(rho_2(i),r);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use3 对于用户3
vector_3 = zeros(receive_num_1,2);
rho_3 = zeros(1,receive_num_1);
for i = 1:receive_num_3
    rho_3(i) = theta + (receive_i_3(i)-1)*angle;
    [vector_3(i,1),vector_3(i,2)] = pol2cart(rho_3(i),r);
end
%% save the path information of the signals that can be received by the base station 记录能被基站接收到信号的路径

% initial position of each signal 记录每个信号的初始位置
p_1 = zeros(receive_num_1,2*length(t));
p_1(:,1:2) = repmat([user_px(1),user_py(1)],receive_num_1,1);
p_2 = zeros(receive_num_2,2*length(t));
p_2(:,1:2) = repmat([user_px(2),user_py(2)],receive_num_2,1);
p_3 = zeros(receive_num_3,2*length(t));
p_3(:,1:2) = repmat([user_px(3),user_py(3)],receive_num_3,1);

% the method to determine the path is the same as phase1 判断路径的方法同phase1
for n = 1:length(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use1 对于用户1
% antenna 1
    for i = 1:receive_num_1      
       
        % ignore the signal arriving at the base station 基站接收到的信号不再绘制
        if((p_1(i,2*n-1)==station_px && p_1(i,2*n)==station_py)||(p_1(i,2*n-1)==12 && p_1(i,2*n)==12))    
            p_1(i,2*(n+1)-1) = 12;
            p_1(i,2*(n+1)) = 12;
            continue
        end
        
        % estimate whether the signal can transfer normally 特殊情况判断 
        position_1 = [p_1(i,2*n-1),p_1(i,2*n)] + vector_1(i,:)*v*delta_t;
        p_1(i,2*(n+1)-1) = position_1(1);
        p_1(i,2*(n+1)) = position_1(2);
        p_next_1 = [p_1(i,2*(n+1)-1),p_1(i,2*(n+1))] + vector_1(i,:)*v*delta_t;        
       
        if(inpolygon(p_next_1(1),p_next_1(2),x_block1,y_block1)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block1,y_block1);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
      
        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block2,y_block2)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block2,y_block2);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
        
        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block3,y_block3)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block3,y_block3);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);

        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block4,y_block4)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block4,y_block4);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);

        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block5,y_block5)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block5,y_block5);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);

        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block6,y_block6)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block6,y_block6);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);

        elseif(inpolygon(p_next_1(1),p_next_1(2),x_block7,y_block7)==1)
            [P1,P2] = find_edge(position_1,p_next_1,x_block7,y_block7);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);

        elseif((p_next_1(1)-station_px)^2 + (p_next_1(2)-station_py)^2 <=0.1)
            p_1(i,2*(n+1)-1) = station_px;
            p_1(i,2*(n+1)) = station_py;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use2 对于用户2
% antenna 2
    for i = 1:receive_num_2        

        if((p_2(i,2*n-1)==station_px && p_2(i,2*n)==station_py)||(p_2(i,2*n-1)==12 && p_2(i,2*n)==12))
            p_2(i,2*(n+1)-1) = 12;
            p_2(i,2*(n+1)) = 12;
            continue
        end
        
        position_2 = [p_2(i,2*n-1),p_2(i,2*n)] + vector_2(i,:)*v*delta_t;
        p_2(i,2*(n+1)-1) = position_2(1);
        p_2(i,2*(n+1)) = position_2(2);
        p_next_2 = [p_2(i,2*(n+1)-1),p_2(i,2*(n+1))] + vector_2(i,:)*v*delta_t;
        
        if(inpolygon(p_next_2(1),p_next_2(2),x_block1,y_block1)==1)          
            [P1,P2] = find_edge(position_2,p_next_2,x_block1,y_block1);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
      
        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block2,y_block2)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block2,y_block2);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
        
        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block3,y_block3)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block3,y_block3);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);

        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block4,y_block4)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block4,y_block4);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);

        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block5,y_block5)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block5,y_block5);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);

        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block6,y_block6)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block6,y_block6);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);

        elseif(inpolygon(p_next_2(1),p_next_2(2),x_block7,y_block7)==1)
            [P1,P2] = find_edge(position_2,p_next_2,x_block7,y_block7);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            
        elseif((p_next_2(1)-station_px)^2 + (p_next_2(2)-station_py)^2 <=0.1)
            p_2(i,2*(n+1)-1) = station_px;
            p_2(i,2*(n+1)) = station_py;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use3 对于用户3
% antenna 3
    for i = 1:receive_num_3        
        if((p_3(i,2*n-1)==station_px && p_3(i,2*n)==station_py)||(p_3(i,2*n-1)==12 && p_3(i,2*n)==12))
            p_3(i,2*(n+1)-1) = 12;
            p_3(i,2*(n+1)) = 12;
            continue
        end
        
        position_3 = [p_3(i,2*n-1),p_3(i,2*n)] + vector_3(i,:)*v*delta_t;
        p_3(i,2*(n+1)-1) = position_3(1);
        p_3(i,2*(n+1)) = position_3(2);
        p_next_3 = [p_3(i,2*(n+1)-1),p_3(i,2*(n+1))] + vector_3(i,:)*v*delta_t;
        
        if(inpolygon(p_next_3(1),p_next_3(2),x_block1,y_block1)==1)      
            [P1,P2] = find_edge(position_3,p_next_3,x_block1,y_block1);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
      
        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block2,y_block2)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block2,y_block2);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
        
        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block3,y_block3)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block3,y_block3);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);

        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block4,y_block4)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block4,y_block4);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);

        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block5,y_block5)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block5,y_block5);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);

        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block6,y_block6)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block6,y_block6);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);

        elseif(inpolygon(p_next_3(1),p_next_3(2),x_block7,y_block7)==1)
            [P1,P2] = find_edge(position_3,p_next_3,x_block7,y_block7);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            
        elseif((p_next_3(1)-station_px)^2 + (p_next_3(2)-station_py)^2 <=0.1)
            p_3(i,2*(n+1)-1) = station_px;
            p_3(i,2*(n+1)) = station_py;
        end
    end
end

%% base station sends signals --- downlink
    s1 = scatter(p_1(:,2*length(t)-1),p_1(:,2*length(t)),10,"filled","r"); 
    hold on
    s2 = scatter(p_2(:,2*length(t)-1),p_2(:,2*length(t)),10,"filled","b");
    s3 = scatter(p_3(:,2*length(t)-1),p_3(:,2*length(t)),10,"filled","g");      
    draw_blocks();
    hold on
    scatter(user_px(1),user_py(1),20,'x','r','LineWidth',2)
    scatter(user_px(2),user_py(2),20,'x','b','LineWidth',2)
    scatter(user_px(3),user_py(3),20,'x','g','LineWidth',2)
    scatter(station_px,station_py,40,'k','LineWidth',2)

% invert the path of the signal from the user to the base station 倒放信号从用户到基站的路径    
for n = length(t):-1:1
    for i = 1:receive_num_1
        revp_1(i,1:2) = [p_1(i,2*n-1),p_1(i,2*n)];
    end
    for i = 1:receive_num_2
        revp_2(i,1:2) = [p_2(i,2*n-1),p_2(i,2*n)];
    end
    for i = 1:receive_num_3
        revp_3(i,1:2) = [p_3(i,2*n-1),p_3(i,2*n)];
    end
    
% show animation 绘图
    hold on
    s1.XData = revp_1(:,1);
    s1.YData = revp_1(:,2);
    s2.XData = revp_2(:,1);
    s2.YData = revp_2(:,2);
    s3.XData = revp_3(:,1);
    s3.YData = revp_3(:,2);
    pictures2(length(t)-n+1) = getframe;
end
end