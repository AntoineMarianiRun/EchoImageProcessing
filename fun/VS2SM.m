function [shear_modulus] = VS2SM(Vs,structure)
% Vs2SWE calculate the ShearWave moduli (u)
% according to the following equation
% u = rho * Vs.^2
% where :
%   rho is the muscle density (1,000 kg/m3),
%   Vs is the shearwave speed (in m/s).
%   u : elastic modulis in kPa
%
% it assume that the material is an homogenus, isotopic, elastic .
% neglects viscous effects (the medium to be non-dispersive).
%
% input 'structre' must be : "muscle", "tendinus" or "aponevrosis".

%% input
if nargin ==  1
    structure = "muscle" ;
elseif nargin == 2
    if ischar(structure)
        structure = lower(string(structure)) ;
    else
        % do nothing
    end
end


%% stucture
if structure == "muscle"
    rho = 1000 ;
elseif structure == "tendinus"
    rho = nan ; % to find
else
    error("seconde input must be : 'muscle', 'tendinus' or 'aponevrosis'")
end

shear_modulus = rho .* (Vs.^2) ;
%fprintf(['the medium is a : ', char(structure), '; with a density of : ', num2str(rho), 'kg/m^3 \n'])
end