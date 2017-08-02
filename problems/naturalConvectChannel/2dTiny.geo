ymax = 40.0;

Point(1) = {0, 0, 0, 2.5};
Point(2) = {28.0, 0, 0, 1.0};
Point(3) = {44.0, 0, 0, 1.0};
Point(4) = {72.0, 0, 0, 2.5};
Point(5) = {72.0, ymax, 0, 2.5};
Point(6) = {44.0, ymax, 0, 1.0};
Point(7) = {28.0, ymax, 0, 1.0};
Point(8) = {0, ymax, 0, 2.5};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 1};
Line(9) = {7, 2};
Line(10) = {6, 3};

//mod left
Line Loop(11) = {1, -9, 7, 8};
Line Loop(12) = {2, -10, 6, 9};
Line Loop(13) = {3, 4, 5, 10};

Plane Surface(14) = {11};
Plane Surface(15) = {12};
Plane Surface(16) = {13};

Physical Surface("fuel") = {15};
Physical Surface("moder") = {14, 16};
Physical Line("fuelBottom") = {2};
Physical Line("fuelTop") = {6};
Physical Line("moderBottom") = {1, 3};
Physical Line("moderTop") = {7, 5};
Physical Line("moderBoundary") = {8, 4};
Physical Line("fuelBoundary") = {9, 10};
