function sdd_map_normaized = SDD_matching(image_, template_,method)
% SDD_matching calcule la carte de similarité par corrélation croisée normalisée
%
%   sdd_map = SDD_matching(image_, template_)
%
% Entrées :
%   - image    : matrice 2D (grayscale)
%   - template : matrice 2D (gabarit à rechercher)
%
% Sortie :
%   - sdd_map : carte 2D des erreur normaisé [0 1]
if nargin < 3
    method = "mean_distance"; % "mean_distance" or "rmse"
end


image_ = mean(image_,3);
template_= mean(template_,3);

% Dimensions
[H, W] = size(image_);
[h, w] = size(template_);
template_size = h*w;

% Dimensions de la carte NCC effet de borf
outH = H - h + 1;
outW = W - w + 1;

% Initialisation
sdd_map = NaN(H, W);

if method == "mean_distance"
    % Boucles sur toutes les positions valides
    for i = 1:outH
        for j = 1:outW
            % Extraire le patch de l'image
            patch = image_(i:i+h-1, j:j+w-1);
            diff = patch - template_;
            sdd_map(i+(floor(h/2)),j+(floor(w/2)))  = sum(sqrt(diff(:).^2));
        end
    end
    max_error = template_size * 255;
    sdd_map_normaized = sdd_map./max_error;

elseif method == "rmse"
    % Boucles sur toutes les positions valides
    for i = 1:outH
        for j = 1:outW
            % Extraire le patch de l'image
            patch = image_(i:i+h-1, j:j+w-1);
            diff = patch - template_;
            sdd_map(i+(floor(h/2)),j+(floor(w/2)))  = sqrt(mean(diff(:).^2));
        end
    end
    max_error = 255;
    sdd_map_normaized = sdd_map./max_error;
end
end