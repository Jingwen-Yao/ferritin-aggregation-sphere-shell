function [ sphere_aggregate ] = sphereAggregate( nAggregate, position_aggregate_cube, radius_aggregate, radius_ferritin, nFerritinPA )
% random position of ferritin in an aggregate
% shell aggregate of given size and number of ferritin

sphere_ferritin = zeros(nFerritinPA,3);

for f = 1:nFerritinPA
    overlap = 1;
    while overlap == 1
        theta = rand * 2 * pi;
        phi = rand * pi;
        r = rand * radius_aggregate;
        sphere_ferritin(f,1) = r.*sin(theta).*cos(phi);
        sphere_ferritin(f,2) = r.*sin(theta).*sin(phi);
        sphere_ferritin(f,3) = r.*cos(theta);
        if f == 1
            overlap = 0;
        else
            overlap = 0;
            for a = 1:f-1
                distance = distanceBetween(sphere_ferritin(f,:),sphere_ferritin(a,:));
                if distance < 2*radius_ferritin
                    overlap = 1;
                end
            end
        end
    end
end

sphere_aggregate = zeros(nFerritinPA*nAggregate,3);
sphere_ferritin = repmat(sphere_ferritin,nAggregate,1);
for i = 1:nAggregate
    sphere_aggregate((i-1)*nFerritinPA+1:i*nFerritinPA,:) = repmat(position_aggregate_cube(i,:),nFerritinPA,1);
end

sphere_aggregate = sphere_aggregate + sphere_ferritin;

end
