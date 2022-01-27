
function draw_blocks()
clear S
S.Vertices = [0   8.9; 0     11; 0.4   11; 2.1 7.8; 1.2 7.2;
              1.6  11; 4.5   11; 5    8.6; 3.4 7.7; 1.6  11;
              6.7  11; 8.6   11; 9.5 10.2; 10  8.1; 7.5 7.5;
              0   6.3; 2.3  7.5; 2.8  6.3; 0   3.2; 0   6.3;
              1.4 3.8; 3.4  5.2; 6      0; 2     0; 1.4 3.8;
              8   5.4; 10.5 5.9; 10.8 4.6; 8.2   4; 8   5.4;
              8.5 2.8; 11   3.7; 11     0; 9.1   0; 8.5 2.8];


% S.Vertices = [x_block1(1) y_block1(1); x_block1(2) y_block1(2); x_block1(3) y_block1(3); x_block1(4) y_block1(4); x_block1(5) y_block1(5);
%               x_block2(1) y_block2(1); x_block2(2) y_block2(2); x_block2(3) y_block2(3); x_block2(4) y_block2(4); x_block2(1) y_block2(1) ];   %多边形的五个顶点
S.Faces = [1 2 3 4 5; 
           6 7 8 9 10;
           11 12 13 14 15;
           16 17 18 19 20;
           21 22 23 24 25;
           26 27 28 29 30;
           31 32 33 34 35];   %第12345个点连成一个多边形
%S.FaceVertexCData = [0];
S.FaceColor = [200 200 200]/255;  %设定block颜色
S.EdgeColor = [100 100 100]/255;  %设定边界颜色
S.LineWidth = 2;   %设定边界宽度
axis equal
axis([-0.5 11.5 -0.5 11.5])
%figure
patch(S)
end