clc
clear

% Physical parameters
diffusion = 4.24*10^(-10); % 3*10^(-9); % m^2/s
B_eq = 0.16; % T
volume_fraction = 3.14*10^(-6); 
echo_time2 = 1*10^(-3); % s
gyro = 2.675*10^8; %rad.s-1.T-1

% Simulation parameters
nAggregate = 50; % per cube
nCube = 3*3*3;
nFerritinPA = 1; % per aggregate
nFerritin = nFerritinPA * nAggregate; % per cube
nProton = 1000;
time_step = 1*10^(-6); % s
N = 500; % echo_time2/time_step;
nGrid = 200;

% Calculated parameters
radius_ferritin = 6*10^(-9); % m
volume_ferritin = (4/3) * pi * (radius_ferritin)^3; % m^3
volume_cube = volume_ferritin * nFerritin / volume_fraction; % m^3
length_cube = nthroot(volume_cube,3); % m
rmsDisplacement = sqrt(6*diffusion*time_step);

% Aggregate parameters
radius_aggregate = radius_ferritin;

% Aggregate distribution
position_aggregate_cube = (rand(nAggregate,3)-1/2).* (length_cube-2*radius_aggregate);
position_ferritin_cube = position_aggregate_cube;
cubes = zeros(3,3,3,3);
cubes(1,:,:,1) = 1; cubes(3,:,:,1) = -1;
cubes(:,1,:,2) = 1; cubes(:,3,:,2) = -1;
cubes(:,:,1,3) = 1; cubes(:,:,3,3) = -1;
cubes = reshape(cubes,nCube,3);
cubes = repmat(cubes,nFerritin,1);

for i = 1:nFerritin
    position_ferritin((i-1)*nCube+1:i*nCube,:) = repmat(position_ferritin_cube(i,:),nCube,1);
end

position_ferritin = position_ferritin + cubes .* length_cube;

scatter3(position_ferritin(:,1),position_ferritin(:,2),position_ferritin(:,3),'b.');
axis([-length_cube*3/2 length_cube*3/2 -length_cube*3/2 length_cube*3/2 -length_cube*3/2 length_cube*3/2]);

% Random proton intial position
position_proton = zeros(3,N+1);
distance_ferritin = zeros(nFerritin*27,N+1);
while distance_ferritin(:,1) < radius_ferritin % not penetrating
    position_proton(:,1) = (rand(3,1)-1/2).* length_cube;
    distance_ferritin(:,1) = sqrt((position_proton(1,1) - position_ferritin(:,1)).^2+...
            (position_proton(2,1) - position_ferritin(:,2)).^2+...
            (position_proton(3,1) - position_ferritin(:,3)).^2);
end

% Random Walk
random_step = zeros(3,N);

for n = 2:N+1
    while distance_ferritin(:,n) < radius_ferritin % not penetrating
        theta = rand * 2 * pi;
        phi = rand * pi;
        r = rmsDisplacement;
        random_step(1,n-1) = r.*sin(theta).*cos(phi);
        random_step(2,n-1) = r.*sin(theta).*sin(phi);
        random_step(3,n-1) = r.*cos(theta);
        position_proton(:,n) = position_proton(:,n-1) + random_step(:,n-1);
        
        % Periodic Boundary Conditions
        if position_proton(1,n) < - length_cube / 2
            position_proton(1,n) = position_proton(1,n) + length_cube;
        elseif position_proton(1,n) >  length_cube / 2
            position_proton(1,n) = position_proton(1,n) - length_cube;
        end
        
        if position_proton(2,n) < - length_cube / 2
            position_proton(2,n) = position_proton(2,n) + length_cube;
        elseif position_proton(2,n) >  length_cube / 2
            position_proton(2,n) = position_proton(2,n) - length_cube;
        end
        
        if position_proton(3,n) < - length_cube / 2
            position_proton(3,n) = position_proton(3,n) + length_cube;
        elseif position_proton(3,n) >  length_cube / 2
            position_proton(3,n) = position_proton(3,n) - length_cube;
        end
        
        distance_ferritin(:,n) = sqrt((position_proton(1,n)-position_ferritin(:,1)).^2+...
                (position_proton(2,n)-position_ferritin(:,2)).^2+...
                (position_proton(3,n)-position_ferritin(:,3)).^2);
    end
end

hold on
plot3(position_proton(1,:),position_proton(2,:),position_proton(3,:),'r-')
hold off

% Calculate grid magnetic field

% grid_magfield = grid_magnetic(nGrid, B_eq, radius_ferritin, length_cube, position_ferritin);
% grid_magfield_peripheral = grid_magfield - grid_magnetic(nGrid, B_eq, radius_ferritin, length_cube, position_ferritin_cube);

% Calculate proton magnetic field
is_near_ferritin = isNearFerritin(position_proton, position_ferritin_cube, length_cube, N, nFerritin);

