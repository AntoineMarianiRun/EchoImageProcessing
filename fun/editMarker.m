function memory_tracking = editMarker(memory_tracking)
    % EDITMARKERGUI - Sélectionner et modifier un marqueur via une listbox
    %
    % Usage :
    %   memory_tracking = editMarkerGUI(memory_tracking)

    % Vérification
    if ~isfield(memory_tracking, 'mkrTracked') || isempty(memory_tracking.mkrTracked)
        error('La structure memory_tracking.mkrTracked est vide ou inexistante.');
    end

    % Création de la liste des noms (ou indice si pas de nom)
    nMarkers = numel(memory_tracking.mkrTracked);
    names = cell(1, nMarkers);
    for k = 1:nMarkers
        if isfield(memory_tracking.mkrTracked, 'mkrName') && ~isempty(memory_tracking.mkrTracked(k).mkrName)
            names{k} = sprintf('%d : %s', k, memory_tracking.mkrTracked(k).mkrName);
        else
            names{k} = sprintf('%d : (sans nom)', k);
        end
    end

    % Interface
    [indx, tf] = listdlg( ...
        'PromptString', 'Sélectionner un marqueur :', ...
        'ListString', names, ...
        'SelectionMode', 'single', ...
        'ListSize', [250, 200]);

    if tf == 0
        disp('Sélection annulée.');
        return;
    end

    nbmkr = indx; % indice choisi

    % Récupération des valeurs actuelles
    current = memory_tracking.mkrTracked(nbmkr);

    prompt = { ...
        sprintf('Couleur actuelle (%s) :', current.color), ...
        sprintf('Type de marqueur actuel (%s) :', current.marker), ...
        sprintf('Taille actuelle (%d) :', current.markerSize), ...
        sprintf('Nom actuel (%s) :', current.mkrName) ...
        };

    dlgtitle = sprintf('Modifier le marqueur #%d', nbmkr);
    dims = [1 50];
    definput = {current.color, current.marker, num2str(current.markerSize), current.mkrName};

    answer = inputdlg(prompt, dlgtitle, dims, definput);

    if ~isempty(answer)
        memory_tracking.mkrTracked(nbmkr).color      = answer{1};
        memory_tracking.mkrTracked(nbmkr).marker     = answer{2};
        memory_tracking.mkrTracked(nbmkr).markerSize = str2double(answer{3});
        memory_tracking.mkrTracked(nbmkr).mkrName    = answer{4};
    end
end
