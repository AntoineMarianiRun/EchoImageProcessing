function [x_cluster,y_cluster,x_moyen,y_moyen] = getStuctureCluster(x_template,y_template,ncc_map,min_correlation,epsilon,minpts)

% 1. set up de la function
if nargin < 5
    epsilon = 10;    % distance max entre 2 points pour être voisins
    minpts  = 100;      % nombre minimum de points pour former un cluster
end

% 2. faire un vecteur avec les positions ou il y a une forte correlation
[y,x] = find(ncc_map>min_correlation); % prendre en compte les pixs avec forte correlations
X = [x y];   % Regroupement en une matrice (N x 2)
try
    % 3. etude de cluster : Clustering avec DBSCAN
    idx = dbscan(X, epsilon, minpts); % indice des
    clusters = unique(idx(idx > 0)); % -1 signifie "bruit" dans DBSCAN, on l'ignore
    n_cluster = length(clusters);
    % counts = arrayfun(@(c) sum(idx==c), clusters); % Compter la taille de chaque cluster


    % 4. distance minimale entre le cluster et template
    dist = nan(1,n_cluster);
    for i = 1 : length(clusters)
        [position_cluster] = X(idx == clusters(i),:);
        dist(i) = min(sqrt(sum((position_cluster - [x_template,y_template]).^2,2))); % distance minimal entre le tempalte et les point du cluster
    end

    % 5. cluster d'interet (distance minimal entre mon point et les point du
    % cluster
    [~,idx_cluster] = min(dist);
    position_cluster = X(idx == clusters(idx_cluster),:);

    % 6. passer de cluster à une ligne
    x_cluster = min(position_cluster(:,1)) : max(position_cluster(:,1));
    y_cluster = NaN(1,length(x_cluster));

    for i = 1 : length(x_cluster)
        y_cluster(i) = mean(position_cluster(position_cluster(:,1) == x_cluster(i),2));
    end

    % 7. epicentre du cluster
    x_moyen = mean(x_cluster);
    y_moyen = mean(y_cluster);
catch M
    disp(M)
    x_cluster = NaN(1);
    y_cluster = NaN(1);
    x_moyen = NaN(1);
    y_moyen = NaN(1);
end
end