function [ shell_aggregate ] = shellAggregate( nAggregate, position_aggregate_cube, radius_aggregate, radius_ferritin, nFerritinPA )
% random position of ferritin in an aggregate
% shell aggregate of given size and number of ferritin

shell_ferritin = zeros(nFerritinPA,3);

for f = 1:nFerritinPA
    overlap = 1;
    while overlap == 1
        theta = rand * 2 * pi;
        phi = rand * pi;
        r = radius_aggregate;
        shell_ferritin(f,1) = r.*sin(theta).*cos(phi);
        shell_ferritin(f,2) = r.*sin(theta).*sin(phi);
        shell_ferritin(f,3) = r.*cos(theta);
        if f == 1
            overlap = 0;
        else
            overlap = 0;
            for a = 1:f-1
                distance = distanceBetween(shell_ferritin(f,:),shell_ferritin(a,:));
                if distance < 2*radius_ferritin
                    overlap = 1;
                end
            end
        end
    end
end

shell_aggregate = zeros(nFerritinPA*nAggregate,3);
shell_ferritin = repmat(shell_ferritin,nAggregate,1);
for i = 1:nAggregate
    shell_aggregate((i-1)*nFerritinPA+1:i*nFerritinPA,:) = repmat(position_aggregate_cube(i,:),nFerritinPA,1);
end

shell_aggregate = shell_aggregate + shell_ferritin;

end

