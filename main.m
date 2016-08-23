clc
clear

% Physical parameters
diffusion = 4.24*10^(-10); % 3*10^(-9); % m^2/s
B_eq = 0.16; % T
volume_fraction = 3.14*10^(-6); 
echo_time2 = 1*10^(-3); % s

% Simulation parameters
nAggregate = 50; % per cube
nCube = 3*3*3;
nFerritinPA = 1; % per aggregate
nFerritin = nFerritinPA * nAggregate; % per cube
nProton = 1000;
time_step = 10^(-9); % s

% Calculated parameters
radius_ferritin = 6*10^(-9); % m
volume_ferritin = (4/3) * pi * (radius_ferritin)^3; % m^3
volume_cube = volume_ferritin * nFerritin / volume_fraction; % m^3
length_cube = nthroot(volume_cube,3); % m

% Aggregate parameters
radius_aggregate = radius_ferritin;

% Aggregate distribution
position_aggregate_cube = (rand(nAggregate,3)-1/2).* (length_cube-2*radius_aggregate);
% scatter3(position_aggregate(:,1),position_aggregate(:,2),position_aggregate(:,3),'b.');
% axis([-length_cube/2 length_cube/2 -length_cube/2 length_cube/2 -length_cube/2 length_cube/2]);

% Random proton intial position
position_proton(:,1) = rand(3,1).* protonLength - protonLength / 2