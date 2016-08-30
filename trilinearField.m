function [ trilinear_field ] = trilinearField( nGrid, grid_magnetic_field, proton_position, length_cube )
% Calculate local magnetic field using trilinear method
% Calculate local magnetic field using trilinear method

grid_length = length_cube/nGrid;
base(1,:) = floor((proton_position(:) + length_cube/2)./grid_length)+1;
base(2,:) = base(1,:) + [1 0 0]; base(3,:) = base(1,:) + [0 1 0]; base(4,:) = base(1,:) + [1 1 0];
base(5,:) = base(1,:) + [0 0 1]; base(6,:) = base(1,:) + [1 0 1]; base(7,:) = base(1,:) + [0 1 1]; 
base(8,:) = base(1,:) + [1 1 1];
target = mod((proton_position + length_cube/2), grid_length)./grid_length;

base_magfield = grid_magnetic_field(base(:,1),base(:,2),base(:,3));
linear(1) = base_magfield(1)*target(1) + base_magfield(2)*(1-target(1));
linear(2) = base_magfield(3)*target(1) + base_magfield(4)*(1-target(1));
linear(3) = base_magfield(5)*target(1) + base_magfield(6)*(1-target(1));
linear(4) = base_magfield(7)*target(1) + base_magfield(8)*(1-target(1));
bilinear(1) = linear(1)*target(2) + linear(2)*(1-target(2));
bilinear(2) = linear(3)*target(2) + linear(4)*(1-target(2));
trilinear_field = bilinear(1)*target(3) + bilinear(2)*(1-target(3));

end

