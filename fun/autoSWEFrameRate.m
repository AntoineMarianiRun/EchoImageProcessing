function [timeSWE,idxSWE,state] = autoSWEFrameRate(frames,colorScale,coef,time)
state = "fail";
coef.x = coef.x*2;
coef.y = coef.y*2;
[Shape] = autoShape(frames{1},coef);

nb_frame = floor(length(frames)/3);
if nb_frame>120
    nb_frame = 120;
end

SWindex = 1 : 1 : nb_frame;

results = colorCalculation(frames,...                                      % frames
    SWindex,...                                                            % index of the swe images
    colorScale.colorScaleRGBdouble,...                                     % colors of the scale
    colorScale.colorScaleValue,...                                         % values of the scale
    coef,...                                                               % scale value of the video dimension
    Shape,...                                                              % shape
    time.Bmode);                                                           % time vecteur of the b mode


% test difference frame (first methode)
x = results.meanValueShearModulus(~isnan(results.meanValueShearModulus));
pctChange = abs(diff(x) ./ x(1:end-1)) * 100;

seuil = 0 : 0.5 : max(pctChange);
seuil = flip(seuil);

for i = 1 : length(seuil)
    idx = find(islocalmax(pctChange>seuil(i),'FlatSelection','center'));
    delta_ = diff(idx);

    if length(delta_)>2 && all(abs(delta_ - mean(delta_)) <= 3)
        break
    end
end

idx = idx+1;

timeBmode = time.Bmode;
fs_swe = round(1/mean(diff(timeBmode(idx))),1);
first_frame = idx(1);

idxSWE = first_frame : round(mean(delta_)) : length(timeBmode);
timeSWE = timeBmode(idxSWE);

if fs_swe>0.5 && fs_swe<2
    state = "sucess";
end


% read frame information
if state ~= "sucess"
    info_image = frames{1}(100:450, ...
        1:300, ...
        :);

    r=ocr(info_image);
    boxes = r.WordBoundingBoxes;    % coordonnées de chaque mot
    words = r.Words;                 % texte de chaque mot

    idx = contains(words,'Std/');
    fs_swe = words{idx};
    fs_swe = str2double(extractAfter(fs_swe, '/'));

    changing_frame = findchangingframeRecursive(pctChange,50);

    first_frame = changing_frame(1);
    timeSWE = timeBmode(first_frame) : fs_swe : max(timeBmode);
    idxSWE = nan(1);
    for i = 1 : length(timeSWE)
        idxSWE(i) = find(timeBmode >= timeSWE(i),1,'first');
    end

    if fs_swe>0.5 && fs_swe<2
        state = "sucess";
    end
end


if state ~= "sucess"
    disp("error in swe frame rate")
end
end


function  changing_frame = findchangingframeRecursive(pctChange,trashold)
if nargin==1
    trashold = 200;
end


% figure('Name',[' find changing frame trashold: ', num2str(trashold)])
% figure
% plot(pctChange,'k')
% hold on
% plot([0 length(pctChange)],[trashold trashold],'r')

changing_frame = find(pctChange>trashold) + 1;

if length(changing_frame)<2
    trashold = trashold * .5;
    changing_frame = findchangingframeRecursive(pctChange,trashold);
end 

end