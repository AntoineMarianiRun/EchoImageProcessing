function memory_tracking = deleteMarker(memory_tracking)
    % DELETEMARKER - Supprimer un marqueur via une listbox
    %
    % Usage :
    %   memory_tracking = deleteMarkerGUI(memory_tracking)

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

    % Interface de sélection
    [indx, tf] = listdlg( ...
        'PromptString', 'Sélectionner le marqueur à supprimer :', ...
        'ListString', names, ...
        'SelectionMode', 'single', ...
        'ListSize', [250, 200]);

    if tf == 0
        return;
    end

    % Confirmation
    choice = questdlg( ...
        sprintf('Voulez-vous vraiment supprimer le marqueur #%d ?', indx), ...
        'Confirmation de suppression', ...
        'Oui', 'Non', 'Non');

    if strcmp(choice, 'Oui')
        memory_tracking.mkrTracked(indx) = []; % suppression
    end
end
