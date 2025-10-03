function [x_intersect,y_intersect] = findIntersect(fun1,fun2,precision)
% cette fonction permet de trouver le point d'intersection entre deux
% fonctions continues
% fun1, fun2 : fonctions continues
% precision  : pas 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<3
    precision = 0.01; %cm
end
maxValue = round(1080 * 3 * precision); % 3 fois la longueur de l'image

x = (0 : 0.01 : maxValue) - (maxValue/2); % distance vector

y1 = fun1(x); % première fonction 
y2 = fun2(x); % seconde fonction 

% % Tracé
% figure
% plot(x, y1, 'k', 'LineWidth', 1.5)
% hold on
% plot(x, y2, 'r', 'LineWidth', 1.5)

% Différence entre fonctions
diffy = y1 - y2;

% Recherche du changement de signe (intersection)
signChange = find(diffy(1:end-1).*diffy(2:end) <= 0);

if ~isempty(signChange)
    % On prend celui le plus proche de 3/4 du domaine
    idx_mid = round(length(x) * (3/4));
    [~, idx] = min(abs(signChange - idx_mid));
    index = signChange(idx);

    % Interpolation linéaire pour une meilleure précision
    x_intersect = interp1(diffy(index:index+1), x(index:index+1), 0);
    y_intersect = interp1(x(index:index+1), y1(index:index+1), x_intersect);

    % % Marquer le point d'intersection
    % plot(x_intersect, y_intersect, 'bo', 'MarkerFaceColor', 'b')
    % legend('f1(x)', 'f2(x)', 'Intersection')
else
    warning('Pas d’intersection trouvée.')
    x_intersect = NaN;
    y_intersect = NaN;
end

end