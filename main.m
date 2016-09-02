clc
clear

% Physical parameters
diffusion = 4.24*10^(-10); % 3*10^(-9); % m^2/s
B_eq = 0.16; % T
volume_fraction = 3.14*10^(-6);
echo_time2 = 1*10^(-3); % s
gyro = 2.675*10^8; %rad.s-1.T-1

% Simulation parameters
nAggregate = 50; % per cube 50
nCube = 3*3*3;
nFerritinPA = 1; % per aggregate
nFerritin = nFerritinPA * nAggregate; % per cube
nProton = 1000;
time_step = 1*10^(-6); % s
echo_step = floor((echo_time2/2)/time_step);
N = 5000; % echo_time2/time_step; 500
nGrid = 200; % 200

% Calculated parameters
radius_ferritin = 6*10^(-9); % m
volume_ferritin = (4/3) * pi * (radius_ferritin)^3; % m^3
volume_cube = volume_ferritin * nFerritin / volume_fraction; % m^3
length_cube = nthroot(volume_cube,3); % m
rmsDisplacement = sqrt(6*diffusion*time_step);

% Aggregate parameters
radius_aggregate = radius_ferritin;

% Ferritin distribution
position_aggregate_cube = (rand(nAggregate,3)-1/2).* (length_cube-2*radius_aggregate);
position_ferritin_cube = position_aggregate_cube;
position_ferritin = position_ferritin( nCube, nFerritin, length_cube, position_ferritin_cube );

% Calculate grid magnetic field
grid_magfield = grid_magnetic(nGrid, B_eq, radius_ferritin, length_cube, position_ferritin);
grid_magfield_peripheral = grid_magfield - grid_magnetic(nGrid, B_eq, radius_ferritin, length_cube, position_ferritin_cube);

signal_sum = zeros(1,6);
for p = 1:nProton
    p
    % Random proton intial position
    position_proton = zeros(3,N+1);
    distance_ferritin = zeros(nFerritin*27,N+1);
    
    position_proton(:,1) = [0 0 0];
    distance_ferritin(:,1) = 1;
    % while distance_ferritin(:,1) < radius_ferritin % not penetrating
    %     position_proton(:,1) = (rand(3,1)-1/2).* length_cube;
    %     distance_ferritin(:,1) = sqrt((position_proton(1,1) - position_ferritin(:,1)).^2+...
    %             (position_proton(2,1) - position_ferritin(:,2)).^2+...
    %             (position_proton(3,1) - position_ferritin(:,3)).^2);
    % end
    
    % Random Walk
    position_proton = randomWalk( N, position_ferritin, position_proton, rmsDisplacement, distance_ferritin, radius_ferritin, length_cube );
    
    % Calculate proton magnetic field
    is_near_ferritin = isNearFerritin(position_proton, position_ferritin_cube, length_cube, N, nFerritin);
    magfield = zeros(N+1,1);
    for n = 1:N+1
        if is_near_ferritin(n) == 0
            magfield(n,1) = trilinearField( nGrid, grid_magfield, position_proton(:,n), length_cube );
        else
            magfield(n,1) = trilinearField( nGrid, grid_magfield_peripheral, position_proton(:,n), length_cube ) + ...
                localField( position_proton(:,n), B_eq, radius_ferritin, position_ferritin_cube );
        end
    end
    
    % Calculate dephasing
    delPhi = gyro * magfield * time_step;
    phase(1) = 0;
    phase(2) = sum(delPhi(1:echo_step)) - sum(delPhi((echo_step+1):(2*echo_step)));
    phase(3) = phase(2) - sum(delPhi((2*echo_step+1):(3*echo_step))) + sum(delPhi((3*echo_step+1):(4*echo_step)));
    phase(4) = phase(3) + sum(delPhi((4*echo_step+1):(5*echo_step))) - sum(delPhi((5*echo_step+1):(6*echo_step)));
    phase(5) = phase(4) - sum(delPhi((6*echo_step+1):(7*echo_step))) + sum(delPhi((7*echo_step+1):(8*echo_step)));
    phase(6) = phase(5) + sum(delPhi((8*echo_step+1):(9*echo_step))) - sum(delPhi((9*echo_step+1):(10*echo_step)));
    
    % Calculate signal
    signal = cos(phase);
    signal_sum = signal_sum + signal;
    
end

signal_sum = signal_sum / nProton;
