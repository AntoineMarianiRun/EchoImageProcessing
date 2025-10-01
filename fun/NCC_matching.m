function ncc_map = NCC_matching(image_, template_)
% NCC_matching calcule la carte de similarité par corrélation croisée normalisée
%
%   ncc_map = NCC_matching(image, template)
%
% Entrées :
%   - image    : matrice 2D (grayscale)
%   - template : matrice 2D (template à rechercher)
%
% Sortie :
%   - ncc_map : carte 2D des scores NCC (entre -1 et 1)

image_ = mean(image_,3);
template_= mean(template_,3);

% Dimensions
[H, W] = size(image_);
[h, w] = size(template_);

% Dimensions de la carte NCC effet de borf
outH = H - h + 1;
outW = W - w + 1;

% Pré-calcul moyenne et écart-type du template
t_mean = mean(template_(:));
t_std  = std(template_(:));

% Initialisation
ncc_map = NaN(H, W);

% Boucles sur toutes les positions valides
for i = 1:outH
    for j = 1:outW
        % Extraire le patch de l'image
        patch = image_(i:i+h-1, j:j+w-1);

        % Normalisation patch
        p_mean = mean(patch(:));
        p_std  = std(patch(:));

        % Numérateur : somme (patch - moyenne_patch) * (template - moyenne_template)
        numerator = sum((patch(:) - p_mean) .* (template_(:) - t_mean));

        % Dénominateur : produit des normes
        denominator = (p_std * t_std) * numel(template_);

        % Éviter division par zéro
        if denominator ~= 0
            ncc_map(i+(floor(h/2)),j+(floor(w/2))) = numerator / denominator;
        else
            ncc_map(i+(floor(h/2)),j+(floor(w/2))) = NaN(1);
        end
    end
end
end