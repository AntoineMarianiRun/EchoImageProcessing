function [colorScaleValue] = setColorscaleValue(colorScaleRGBuint8,colorScaleRGBdouble)
opts.Interpreter = 'tex'; opts.Default = "m/s"; %option
dlg = questdlg('What is the scale unit?',...
    'echo type',...
    "kPa","m/s",opts);
if strcmpi(string(dlg),"kPa")
    txt = "kPa";
elseif strcmpi(string(dlg),"m/s")
    txt = "m/s";
end


[Maxvalue] = scaleSWEValue(colorScaleRGBuint8,txt);

if txt == "kPa"
    colorScaleValue = linspace(0,Maxvalue/3,length(colorScaleRGBdouble)); % from young modulus (E) to shear modulus (μ)
elseif txt == "m/s"
    colorScaleValue_ms = sqrt(linspace(0,Maxvalue^2,length(colorScaleRGBdouble)));% no linearity of the scale (μ)
    colorScaleValue = VS2SM(colorScaleValue_ms); % in Pa
    colorScaleValue = colorScaleValue./1000;  % in kPa
end
end