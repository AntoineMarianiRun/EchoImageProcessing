function [absError] =  comparaisonImage(img,patternImage)
% comparaison d'une image en RGB et de dimension m, n 
% avec un image identité id RGB et de dimension m, n
% img(m,m,3)
% pattern(m,m,3)
% return error [0,1]

absError = nan(1);                                                             % intialisation 

if size(img,1) == size(patternImage,1) && ...
    size(img,2) == size(patternImage,2) && ...
    size(img,3) == size(patternImage,3)                                    % same length 
    if size(img,3) == 3                                                    % RGB image 
    errR = matrixComparaison(img(:,:,1),patternImage(:,:,1))/255;          % Red rms error
    errB = matrixComparaison(img(:,:,2),patternImage(:,:,2))/255;          % Bleu rms error
    errV = matrixComparaison(img(:,:,3),patternImage(:,:,3))/255;          % Green rms error
    absError = mean([errR,errB,errV]);                                   % Mean error 
    elseif size(img,3) == 1                                                % grey image 
    absError =  matrixComparaison(img(:,:,1),patternImage(:,:,1))/255;                   % Mean error 
    end
end
end 

function [absError] = matrixComparaison(M1,M2)
M1 = double(M1); 
M2 = double(M2); 

absError = sqrt(mean((M1 - M2).^2,"all"));
end