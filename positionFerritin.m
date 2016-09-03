function [ position_ferritin ] = positionFerritin( nCube, nFerritin, length_cube, position_ferritin_cube, cubes )
% ferritin distribution in 3*3*3 cubes
% ferritin distribution in 3*3*3 cubes

cubes = repmat(cubes,nFerritin,1);

for i = 1:nFerritin
    position_ferritin((i-1)*nCube+1:i*nCube,:) = repmat(position_ferritin_cube(i,:),nCube,1);
end

position_ferritin = position_ferritin + cubes .* length_cube;

%hold on
%scatter3(position_ferritin(:,1),position_ferritin(:,2),position_ferritin(:,3),'b.');
%axis([-length_cube*3/2 length_cube*3/2 -length_cube*3/2 length_cube*3/2 -length_cube*3/2 length_cube*3/2]);
%hold off

end

