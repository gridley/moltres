// units are centimeters
pitch = 34.0;
saltFrac = 0.225;
channelRadius = (pitch^2 * 3.0^0.5 / 2.0 / Pi * saltFrac)^0.5;
y1 = pitch / (2 * 3.0^0.5);
y2 = ((pitch/2.0)^2 + pitch^2 /12.0 )^0.5;

lc = 2.0;

// the hexagon
Point(1) = {pitch/2.0, y1, 0.0, lc};
Point(2) = {0.0, y2, 0.0, lc};
Point(3) = {-pitch/2.0, y1, 0.0, lc};
Point(4) = {-pitch/2.0, -y1, 0.0, lc};
Point(5) = {0.0, -y2, 0.0, lc};
Point(6) = {pitch/2.0, -y1, 0.0, lc};
Line(2) = {6, 1};
Line(3) = {1, 2};
Line(4) = {2, 3};
Line(5) = {3, 4};
Line(6) = {4, 5};
Line(7) = {5, 6};
Line Loop(10) = {2, 3, 4, 5, 6, 7};

// the channel
Point(7) = {0,0,0,lc}; //origin
Point(8) = {channelRadius, 0,0,lc};
Point(9) = {0, channelRadius, 0, lc};
Point(10) = {-channelRadius, 0, 0, lc};
Point(11) = {0, -channelRadius, 0, lc};
Circle(20) = {8, 7, 9};
Circle(21) = {9, 7, 10};
Circle(22) = {10, 7, 11};
Circle(23) = {11, 7, 8};

Line Loop(9) = {20, 21, 22, 23};
Plane Surface(11) = {10, -9}; //in hex but not circle
Plane Surface(12) = {9}; //in circle

out0[] = Extrude{0.0, 0.0, 400.0}{Surface{11};};
out[] = Extrude{0.0, 0.0, 400.0}{Surface{12};};
