function [ grid ] = grid_magnetic( nGrid, B_eq, radius_ferritin, length_cube, position_ferritin )
% Precalculated local magnetic field given by ferritins
% 200*200*200 grid

% Calculate grid magnetic field
% Creat grid
grid_x = -length_cube/2:length_cube/nGrid:length_cube/2;
grid_y = -length_cube/2:length_cube/nGrid:length_cube/2;
grid_z = -length_cube/2:length_cube/nGrid:length_cube/2;

grid = zeros(nGrid+1,nGrid+1,nGrid+1);

for i = 1:nGrid+1
    for j = 1:nGrid+1
        for k = 1:nGrid+1
            distance_grid = ...
                sqrt((position_ferritin(:,1)-grid_x(i)).^2+...
                (position_ferritin(:,2)-grid_y(j)).^2+...
                (position_ferritin(:,3)-grid_z(k)).^2);
            cos_theta = (grid_z(k)-position_ferritin(:,3))./distance_grid;
            Bz = B_eq*(radius_ferritin)^3*(3*(cos_theta).^2-1)./(distance_grid.^3);
            grid(i,j,k) = sum(Bz);
        end
    end
end

fprintf('Grid magnetic field calculated.\n');

end

