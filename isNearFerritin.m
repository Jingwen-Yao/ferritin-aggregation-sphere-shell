function [ is_near_ferritin ] = isNearFerritin( position_proton, position_ferritin_cube, length_cube, N, nFerritin )
% test if proton is near a ferritin
% test if proton is within 10 nodes of any ferritin
maxDistance = length_cube / 20;
is_near_ferritin = false(N+1,1);

for i = 1:N+1
    for n = 1:nFerritin
        if abs(position_ferritin_cube(n,1)-position_proton(1,i)) <= maxDistance &&...
             abs(position_ferritin_cube(n,2)-position_proton(2,i)) <= maxDistance &&...
             abs(position_ferritin_cube(n,3)-position_proton(3,i)) <= maxDistance
         is_near_ferritin(i,1) = true;
        end
    end
end

end

