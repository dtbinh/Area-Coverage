% Copyright 2016-2017 Sotiris Papatheodorou
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

clear variables

syms a b c x y xi yi xj yj ri rj Ri Rj t
assume([a b c x y xi yi xj yj ri rj Ri Rj],'real');
assume([c ri rj Ri Rj],'positive');

% Hyperbola parameters
qi = [xi ; yi];
qj = [xj ; yj];
c = norm(qi-qj) / 2;
ai = (ri + rj + Rj - Ri) / 2;
bi = sqrt(c^2 - ai^2);
aj = (ri + rj + Ri - Rj) / 2;
bj = sqrt(c^2 - ai^2);

% Hyperbolic branches
Hij = [ai * cosh(t) ; bi * sinh(t)];
Hji = [aj * cosh(t) ; bj * sinh(t)];

% Rotate branches
thetai = atan2( yi-yj, xi-xj );
thetaj = atan2( yj-yi, xj-xi );
Hij = [cos(thetai) -sin(thetai) ; sin(thetai) cos(thetai)] * Hij;
Hji = [cos(thetaj) -sin(thetaj) ; sin(thetaj) cos(thetaj)] * Hji;

% Translate branches
Hij = Hij + (qi+qj)/2;
Hji = Hji + (qi+qj)/2;



% Jacobian matrices
Jix_xi = diff(Hij(1), xi);
Jix_yi = diff(Hij(1), yi);
Jiy_xi = diff(Hij(2), xi);
Jiy_yi = diff(Hij(2), yi);
Jjx_xi = diff(Hji(1), xi);
Jjx_yi = diff(Hji(1), yi);
Jjy_xi = diff(Hji(2), xi);
Jjy_yi = diff(Hji(2), yi);
Ji = [Jix_xi Jix_yi ; Jiy_xi Jiy_yi]';
Jj = [Jjx_xi Jjx_yi ; Jjy_xi Jjy_yi]';

% Normal vectors
dHij = diff(Hij, t);
ddHij = diff(dHij, t);
dHji = diff(Hji, t);
ddHji = diff(dHji, t);
ni = ddHij - dot( ddHij, dHij/norm(dHij) ) * dHij/norm(dHij);
nj = ddHji - dot( ddHji, dHji/norm(dHji) ) * dHji/norm(dHji);
% Whether the cell is convex or not depends on the sign of a
ni = - sign(ai) * ni / norm(ni);
nj = - sign(aj) * nj / norm(nj);

% Export matlab functions
Jni = Ji * ni;
Jnj = Jj * nj;
FJni = matlabFunction( Jni, 'File','FJni_AWGV');
FJnj = matlabFunction( Jnj, 'File','FJnj_AWGV');

FJi = matlabFunction( Ji, 'File','FJi_AWGV');
FJj = matlabFunction( Jj, 'File','FJj_AWGV');

Fni = matlabFunction( ni, 'File','Fni_AWGV');
Fnj = matlabFunction( nj, 'File','Fnj_AWGV');
