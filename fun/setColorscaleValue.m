function [colorScaleValue] = setColorscaleValue(colorScaleRGBuint8,colorScaleRGBdouble)
opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
dlg = questdlg('What is the scale unit?',...
    'echo type',...
    'kPa','m/s',opts);
if strcmpi(string(dlg),"kPa")
    txt = "kPa";
elseif strcmpi(string(dlg),"m/s")
    txt = "m/s";
end


[Maxvalue] = scaleSWEValue(colorScaleRGBuint8,txt);

if txt == "kPa"
    colorScaleValue = linspace(0,Maxvalue,length(colorScaleRGBdouble));
elseif txt == "m/s"
    colorScaleValue_ms = linspace(0,Maxvalue,length(colorScaleRGBdouble));
    colorScaleValue = VS2SM(colorScaleValue_ms);
    colorScaleValue = colorScaleValue./1000;
end
end