% Copyright 2017 Sotiris Papatheodorou
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%    http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function move_vector = AWGV_cell_integrals( Xi, uradiusi, GVcelli, ...
    sradiusi, Xj, uradiusj, GVcellj, sradiusj, FULL, DEBUG )
% Calculate the integral over Hij, Hji and return the move vector
% Handle optional debug argument
if nargin < 10
    DEBUG = 0;
end
if nargin < 9
    FULL = 1;
end

% Translate and rotate Xi and Xj so that the hyperbola is East-West
XXi = Xi - (Xi+Xj)/2;
XXj = Xj - (Xi+Xj)/2;
theta = -atan2( Xj(2)-Xi(2), Xj(1)-Xi(1) );
XXi = rot(XXi, theta);
XXj = rot(XXj, theta);



% Hyperbola parameters
aij = (uradiusi + uradiusj + sradiusj - sradiusi) / 2;
aji = (uradiusi + uradiusj + sradiusi - sradiusj) / 2;
c = norm( Xi-Xj ) / 2;
bij = sqrt(c^2 - aij^2);
bji = sqrt(c^2 - aji^2);
% Error tolerance
e = 10^-10;

move_vector = zeros(2,1);




% Integral over Hij
% Loop over all vertices of GVi (the rotated and translated cell, as if
% produced by an East-West hyperbola). For each vertex check if it
% satisfies the East-West hyperbola equation. If it does find t and
% integrate
if ~isempty(GVcelli)
    % Translate and rotate the cell
    GVi = bsxfun(@minus, GVcelli, (Xi+Xj)/2);
    GVi = rot( GVi, theta );
    
    for k=1:length( GVi(1,:) )
        % Check if it satisfies the hyperbola equation
        if abs(GVi(1,k)^2/aij^2 - GVi(2,k)^2/bij^2 - 1) <= e
            % Check if it's inside the sensing circle
            if norm( GVi(:,k)-XXi ) <= sradiusi           
                % Find the t parameter
                t = asinh( GVi(2,k)/bij );

                % Substitute the symbolic expressions
                xi = XXi(1);
                yi = XXi(2);
                xj = XXj(1);
                yj = XXj(2);

                uni = FJni_AWGV(sradiusi,sradiusj,uradiusi,uradiusj,...
                    t,xi,xj,yi,yj);

                % Rotate back to the correct orientation
                uni = rot( uni, -theta );

                % Find the length of the arc (half the distance from each adjacent vertex)
                % Cases for first and last vertices
                if k == 1
                    d = norm(GVi(:,k)-GVi(:,end)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,k+1)) / 2;
                elseif k == length( GVi(1,:) )
                    d = norm(GVi(:,k)-GVi(:,k-1)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,1)) / 2;
                else
                    d = norm(GVi(:,k)-GVi(:,k-1)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,k+1)) / 2;
                end
                % Add to the move vector
                move_vector = move_vector + d*uni;
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
                if DEBUG
                    plot(GVcelli(1,k), GVcelli(2,k), 'm.');
                    plot([GVcelli(1,k) GVcelli(1,k)+d*uni(1)], ...
                         [GVcelli(2,k) GVcelli(2,k)+d*uni(2)], 'm');
                end
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
            end
        end
    end
end




if FULL
    % Integral over Hji
    % Loop over all vertices of GVj (the rotated and translated cell, as if
    % produced by an East-West hyperbola). For each vertex check if it
    % satisfies the East-West hyperbola equation. If it does find t and
    % integrate
    if ~isempty(GVcellj)
        % Translate and rotate the cell
        GVj = bsxfun(@minus, GVcellj, (Xi+Xj)/2);
        GVj = rot( GVj, theta );

        for k=1:length( GVj(1,:) )
            % Check if it satisfies the hyperbola equation
            if abs(GVj(1,k)^2/aji^2 - GVj(2,k)^2/bji^2 - 1) <= e
                % Check if it's inside the sensing circle
                if norm( GVj(:,k)-XXj ) <= sradiusj
                    % Find the t parameter
                    t = asinh( GVj(2,k)/bji );
                    if imag(t) ~= 0
                        disp('imaginary t j')
                    end

                    % Substitute the symbolic expressions
                    xi = XXi(1);
                    yi = XXi(2);
                    xj = XXj(1);
                    yj = XXj(2);

                    unj = FJnj_AWGV(sradiusi,sradiusj,uradiusi,uradiusj,...
                    t,xi,xj,yi,yj);

                    % Rotate back to the correct orientation
                    unj = rot( unj, -theta );

                    % Find the length of the arc (half the distance from each adjacent vertex)
                    % Cases for first and last vertices
                    if k == 1
                        d = norm(GVj(:,k)-GVj(:,end)) / 2 + ...
                            norm(GVj(:,k)-GVj(:,k+1)) / 2;
                    elseif k == length( GVj(1,:) )
                        d = norm(GVj(:,k)-GVj(:,k-1)) / 2 + ...
                            norm(GVj(:,k)-GVj(:,1)) / 2;
                    else
                        d = norm(GVj(:,k)-GVj(:,k-1)) / 2 + ...
                            norm(GVj(:,k)-GVj(:,k+1)) / 2;
                    end
                    % Add to the move vector
                    move_vector = move_vector + d*unj;
                    %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
                    if DEBUG
                        plot(GVcellj(1,k), GVcellj(2,k), 'm.');
                        plot([GVcellj(1,k) GVcellj(1,k)+d*unj(1)], ...
                             [GVcellj(2,k) GVcellj(2,k)+d*unj(2)], 'm');
                    end
                    %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
                end
            end
        end
    end
end
