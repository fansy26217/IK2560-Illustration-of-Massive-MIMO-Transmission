%% set parameters 
delta_t = 0.05;    % time interval 时间间隔
v = 3;  % propagation speed of the signal 信号的传播速度

% position of the user device 用户设备的位置
user_px = [1.7 5.3 8.6];
user_py = [4.8 2 3];

% position of the base station 基站的位置
station_px = 5.5;
station_py = 5.5;

angle = pi/100;    % angular interval of the signals sent in phase1 传播信号的角度间隔
maximum_time = 10;
%% draw blocks
 draw_blocks();

%% phase1: user devices transmit signals in the uplink
[pictures1, receive_time, receive_i_1, receive_i_2, receive_i_3, receive_num_1, receive_num_2, receive_num_3] = phase1(maximum_time, angle, station_px, station_py, user_px, user_py,delta_t, v);

%% phase2: base station transmit signals in the downlink
pictures2 = phase2(maximum_time, angle, receive_i_1, receive_i_2,receive_i_3, receive_num_1, receive_num_2,receive_num_3, station_px, station_py, user_px, user_py,delta_t, v);

%% output movie
pictures = [pictures1,pictures2];
