function [pictures1, receive_time, receive_i_1, receive_i_2,receive_i_3, receive_num_1, receive_num_2,receive_num_3] = phase1(maximum_time, angle, station_px, station_py, user_px, user_py, delta_t, v)
%% set parameters 参数设定
t_max = maximum_time;    % the maximum time to execute the phase1 执行phase1的最大时间
t = 0:delta_t:t_max;
number = int8(2*pi/angle);    % number of the signals sent in phase1 传播信号的数量

% positions of blocks 障碍物坐标
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

% the total number of the signals arriving at the base station 记录基站收到信号的个数
receive_num = 0;    
receive_num_1 = 0;    % signals sent by user1 记录基站收到用户1发来信号的个数
receive_num_2 = 0;    % signals sent by user2 记录基站收到用户2发来信号的个数
receive_num_3 = 0;

% the serial number of the signals arriving at the base station 记录基站收到信号的编号
receive_i_1 = zeros(1,number);
receive_i_2 = zeros(1,number);
receive_i_3 = zeros(1,number);

% the total number of the signals outside the area 记录逸出信号的个数
out_num_1 = 0;
out_num_2 = 0;
out_num_3 = 0;

% the serial number of the signals outside the area 记录逸出信号的编号
out_i_1 = zeros(1,number);
out_i_2 = zeros(1,number);
out_i_3 = zeros(1,number);

% to record the number of reflections for each signal 记录信号的反射的次数
reflect_i_1 = zeros(1,number);
reflect_i_2 = zeros(1,number);
reflect_i_3 = zeros(1,number);

% time when the base station received the signal 记录基站接受到信号的时间
receive_time = zeros(2,number);    

% positions of the signals at the current moment 存储每个信号在当前时刻的位置
p_1 = zeros(number,2);
p_2 = zeros(number,2);
p_3 = zeros(number,2);
for i = 1:number
    p_1(i,:) = [user_px(1),user_py(1)];
    p_2(i,:) = [user_px(2),user_py(2)];
    p_3(i,:) = [user_px(3),user_py(3)];
end

% positions of the signals at the next moment 信号在下一时刻的位置
p_next_1= zeros(number,2);    
p_next_2= zeros(number,2); 
p_next_3= zeros(number,2); 

% initialize signal direction vectors 信号方向向量初始化
vector_1(1,:) = [-1,-1];  % initial direction vectors of the signals 信号的初始方向向量
vector_1(1,:) = vector_1(1,:)/norm(vector_1(1,:));
[theta,r] = cart2pol(vector_1(1,1),vector_1(1,2));
rho = zeros(1,number);    % angles of the initial signal direction vectors 初始信号方向向量对应的角度值
rho(1) = theta;
for i = 2:number
    rho(i) = rho(i-1) + angle;
    [vector_1(i,1),vector_1(i,2)] = pol2cart(rho(i),r);
end
vector_2 = vector_1;  % the initial vector is the same for user 1 and 2
vector_3 = vector_1;

% initialize display parameters 显示参数初始化
frame_num = int8(t_max/delta_t+1);    % the number of the frames of the animation 存储帧的数量
pictures1(frame_num) = struct('cdata',[],'colormap',[]);    % store each frame of the animation 用来存储每一帧动画

%% users send signals --- uplink
    s1 = scatter(p_1(:,1),p_1(:,2),10,"filled","r");
    hold on
    s2 = scatter(p_2(:,1),p_2(:,2),10,"filled","b");
    s3 = scatter(p_3(:,1),p_3(:,2),10,"filled","g");
    draw_blocks();
    scatter(user_px(1),user_py(1),20,'x','r','LineWidth',2);
    scatter(user_px(2),user_py(2),20,'x','b','LineWidth',2);
    scatter(user_px(3),user_py(3),20,'x','g','LineWidth',2);
    scatter(station_px,station_py,40,'k','LineWidth',2);
    
for n = 1:length(t)    % at a certain time 在某个时间下
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use1 对于用户1
% antenna 1  
    for i = 1:number    % estimate each signal 对每个信号逐个判断        
        
        % calculate the particles' position 计算每个点的位置
        if(find(receive_i_1==i)~=0)    % ignore the signal arriving at the base station 基站接收到的信号不再绘制 
            continue
        elseif(find(out_i_1==i)~=0)    % ignore the signal outside the base station 逸出边界的信号不再绘制
            continue
        else    % otherwise plot the signal 否则绘制信号
            p_1(i,:) = p_1(i,:) + vector_1(i,:)*v*delta_t;
            p_next_1(i,:) = p_1(i,:) + vector_1(i,:)*v*delta_t;    % calculate the postion of the signal at the next moment 计算下一时刻信号位置
        end
        
        % estimate whether the signal can transfer normally 特殊情况判断       
        if(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block1,y_block1)==1)    % reflected by block1 触碰到障碍物1反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block1,y_block1);    % the edge that the signal arrives 判断在哪条边上反弹
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);    % execute reflection 执行反射函数
            reflect_i_1(i)=reflect_i_1(i)+1;
      
        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block2,y_block2)==1)    % reflected by block2 触碰到障碍物2反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block2,y_block2);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;

        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block3,y_block3)==1)    % reflected by block3 触碰到障碍物3反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block3,y_block3);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;

        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block4,y_block4)==1)    % reflected by block4 触碰到障碍物4反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block4,y_block4);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;

        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block5,y_block5)==1)    % reflected by block5 触碰到障碍物5反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block5,y_block5);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;

        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block6,y_block6)==1)    % reflected by block6 触碰到障碍物6反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block6,y_block6);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;

        elseif(inpolygon(p_next_1(i,1),p_next_1(i,2),x_block7,y_block7)==1)    % reflected by block7 触碰到障碍物7反弹
            [P1,P2] = find_edge(p_1(i,:),p_next_1(i,:),x_block7,y_block7);
            vector_1(i,:) = reflection(vector_1(i,:),P1,P2);
            reflect_i_1(i)=reflect_i_1(i)+1;
            
        elseif(((p_next_1(i,1)-station_px)^2 + (p_next_1(i,2)-station_py)^2 <=0.1) && reflect_i_1(i)<=10)    % received by the base station 被基站接受
            receive_num = receive_num+1;
            receive_num_1 = receive_num_1+1;
            receive_vector(receive_num_1,:) = vector_1(i,:);    % direction vectors of signals arriving at the base station 记录基站接受到信号的方向向量
            receive_time(1,receive_num) = t(n);    % time when the base station received the signal 记录基站接受到信号的时间
            receive_time(2,receive_num) = 1;
            receive_i_1(receive_num_1) = i;
            p_1(i,:) = [12 12];
        elseif(p_next_1(i,1)<=-0.5 || p_next_1(i,1)>=11 ||p_next_1(i,2)>=11 ||p_next_1(i,2)<=-0.5)    % the signal is outside the area 逸出区域
            out_num_1=out_num_1+1;
            out_i_1(out_num_1)=i;
            p_1(i,:) = [12 12];    % plot the point outside the area to make it disappear 将点画在图像范围外以达到消失的效果
        elseif (reflect_i_1(i)>10)    % ignore the weak signal 衰减的信号不再绘制
            p_1(i,:) = [12 12];
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use2 对于用户2
% antenna 2  
    for i = 1:number
        if(find(receive_i_2==i)~=0) 
            continue
        elseif(find(out_i_2==i)~=0)
            continue
        else
            p_2(i,:) = p_2(i,:) + vector_2(i,:)*v*delta_t;
            p_next_2(i,:) = p_2(i,:) + vector_2(i,:)*v*delta_t;
        end   
        if(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block1,y_block1)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block1,y_block1);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;
      
        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block2,y_block2)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block2,y_block2);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;

        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block3,y_block3)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block3,y_block3);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;

        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block4,y_block4)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block4,y_block4);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;

        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block5,y_block5)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block5,y_block5);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;

        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block6,y_block6)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block6,y_block6);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;

        elseif(inpolygon(p_next_2(i,1),p_next_2(i,2),x_block7,y_block7)==1)
            [P1,P2] = find_edge(p_2(i,:),p_next_2(i,:),x_block7,y_block7);
            vector_2(i,:) = reflection(vector_2(i,:),P1,P2);
            reflect_i_2(i)=reflect_i_2(i)+1;
            
        elseif(((p_next_2(i,1)-station_px)^2 + (p_next_2(i,2)-station_py)^2 <=0.1) && reflect_i_2(i)<=10)
            receive_num = receive_num+1;
            receive_num_2 = receive_num_2+1;
            receive_vector(receive_num_2,:) = vector_2(i,:);
            receive_time(1,receive_num) = t(n);
            receive_time(2,receive_num) = 2;
            receive_i_2(receive_num_2) = i;
            p_2(i,:) = [12 12];
        elseif(p_next_2(i,1)<=-0.5 || p_next_2(i,1)>=11 ||p_next_2(i,2)>=11 ||p_next_2(i,2)<=-0.5)
            out_num_2=out_num_2+1;
            out_i_2(out_num_2)=i;
            p_2(i,:) = [12 12];
        elseif (reflect_i_2(i)>10)
            p_2(i,:) = [12 12];
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for use3 对于用户3
% antenna 3
    for i = 1:number    % estimate each signal 对每个信号逐个判断        
        
        % calculate the particles' position 计算每个点的位置
        if(find(receive_i_3==i)~=0)    % ignore the signal arriving at the base station 基站接收到的信号不再绘制 
            continue
        elseif(find(out_i_3==i)~=0)    % ignore the signal outside the base station 逸出边界的信号不再绘制
            continue
        else    % otherwise plot the signal 否则绘制信号
            p_3(i,:) = p_3(i,:) + vector_3(i,:)*v*delta_t;
            p_next_3(i,:) = p_3(i,:) + vector_3(i,:)*v*delta_t;    % calculate the postion of the signal at the next moment 计算下一时刻信号位置
        end
        
        % estimate whether the signal can transfer normally 特殊情况判断       
        if(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block1,y_block1)==1)    % reflected by block1 触碰到障碍物1反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block1,y_block1);    % the edge that the signal arrives 判断在哪条边上反弹
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);    % execute reflection 执行反射函数
            reflect_i_3(i)=reflect_i_3(i)+1;
      
        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block2,y_block2)==1)    % reflected by block2 触碰到障碍物2反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block2,y_block2);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;

        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block3,y_block3)==1)    % reflected by block3 触碰到障碍物3反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block3,y_block3);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;

        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block4,y_block4)==1)    % reflected by block4 触碰到障碍物4反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block4,y_block4);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;

        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block5,y_block5)==1)    % reflected by block5 触碰到障碍物5反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block5,y_block5);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;

        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block6,y_block6)==1)    % reflected by block6 触碰到障碍物6反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block6,y_block6);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;

        elseif(inpolygon(p_next_3(i,1),p_next_3(i,2),x_block7,y_block7)==1)    % reflected by block7 触碰到障碍物7反弹
            [P1,P2] = find_edge(p_3(i,:),p_next_3(i,:),x_block7,y_block7);
            vector_3(i,:) = reflection(vector_3(i,:),P1,P2);
            reflect_i_3(i)=reflect_i_3(i)+1;
            
        elseif(((p_next_3(i,1)-station_px)^2 + (p_next_3(i,2)-station_py)^2 <=0.1) && reflect_i_3(i)<=10)    % received by the base station 被基站接受
            receive_num = receive_num+1;
            receive_num_3 = receive_num_3+1;
            receive_vector(receive_num_3,:) = vector_3(i,:);    % direction vectors of signals arriving at the base station 记录基站接受到信号的方向向量
            receive_time(1,receive_num) = t(n);    % time when the base station received the signal 记录基站接受到信号的时间
            receive_time(2,receive_num) = 1;
            receive_i_3(receive_num_3) = i;
            p_3(i,:) = [12 12];
        elseif(p_next_3(i,1)<=-0.5 || p_next_3(i,1)>=11 ||p_next_3(i,2)>=11 ||p_next_3(i,2)<=-0.5)    % the signal is outside the area 逸出区域
            out_num_3=out_num_3+1;
            out_i_3(out_num_3)=i;
            p_3(i,:) = [12 12];  % 将点画在图像范围外以达到消失的效果
        elseif (reflect_i_3(i)>10)
            p_3(i,:) = [12 12];        
        end
    end
    
% show animation 绘图
    hold on
    s1.XData = p_1(:,1);
    s1.YData = p_1(:,2);
    s2.XData = p_2(:,1);
    s2.YData = p_2(:,2);
    s3.XData = p_3(:,1);
    s3.YData = p_3(:,2);                                                            
    pictures1(n) = getframe;
    hold off
end
end
