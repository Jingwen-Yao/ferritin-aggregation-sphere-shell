function [ local_field ] = localField( proton_position, B_eq, radius_ferritin, position_ferritin_cube )
% Calculate magnetic field experienced by proton
% accurate calculation given by ferritins

distance_proton = sqrt((position_ferritin_cube(:,1)-proton_position(1)).^2+...
                (position_ferritin_cube(:,2)-proton_position(2)).^2+...
                (position_ferritin_cube(:,3)-proton_position(3)).^2);
cos_theta = (proton_position(3)-position_ferritin_cube(:,3))./distance_proton;
Bz = B_eq*(radius_ferritin)^3*(3*(cos_theta).^2-1)./(distance_proton.^3);
local_field = sum(Bz);

end

