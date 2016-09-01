function [ position_ferritin ] = position_ferritin( nCube, nFerritin, length_cube, position_ferritin_cube )
% ferritin distribution in 3*3*3 cubes
% ferritin distribution in 3*3*3 cubes

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

end

