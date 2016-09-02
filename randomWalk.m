function [ position_proton ] = randomWalk( N, position_ferritin, position_proton, rmsDisplacement, distance_ferritin, radius_ferritin, length_cube )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

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

% hold on
% plot3(position_proton(1,:),position_proton(2,:),position_proton(3,:),'r-')
% hold off

end

