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
close all

addpath( genpath('../Functions') );

region = 8*[1 1 -1 -1 ; 1 -1 -1 1];
% Uncertainty centers
q = [-2 2 0;
    0 0 2];
% Uncertainty radii
r = [0.2 0.4 0.5];
% Guaranteed sensing radii
R_original = [3.5 1 2.4];
R = R_original - r;
N = length(q(1,:));


% AWGV
AWGV = cell([1 N]);
for i=1:N
    AWGV{i} = AWGV_cell(region, q, r, R, i);
end

% Normal vectors




%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
figure
hold on
plot(q(1,:), q(2,:), 'k.');
for i=1:N
    plot_circle(q(:,i), r(i), 'k');
    plot_circle(q(:,i), R(i), 'r');
end
for i=1:N
    if ~isempty(AWGV{i})
        plot(AWGV{i}(1,:), AWGV{i}(2,:), 'b');
    end
end
axis equal