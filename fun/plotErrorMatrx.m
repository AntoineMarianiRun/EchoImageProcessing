function plotErrorMatrx(errMatrix)
% Condition pour remplacer les valeurs égales à 1 par NaN
errMatrix(errMatrix == 1) = NaN;

% Créer les coordonnées X et Y
[x, y] = meshgrid(1:size(errMatrix, 2), 1:size(errMatrix, 1));

% Tracer la matrice en utilisant mesh
mesh(x, y, errMatrix);

% Ajuster l'échelle des couleurs à [0, 1]
caxis([0 1]);

% Ajouter une barre de couleur pour la légende des valeurs
colorbar;

% Ajouter les labels des axes
xlabel('pixel row');
ylabel('pixel column');
zlabel('normalized error');

% Titre de la figure (optionnel)
title('Matrix of normalized error');
end