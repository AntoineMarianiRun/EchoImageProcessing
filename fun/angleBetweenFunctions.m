function theta_deg = angleBetweenFunctions(fun1, fun2, x_i)
% fun1, fun2 : fonctions continues
% x0         : point où calculer l'angle
% theta_deg  : angle en degrés
% methode difference centrale fini si Symbolic_Toolbox n'est pas installé
% attention que derivé de polynome pour l'instant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theta_deg = NaN(1);

try

    if license('test','Symbolic_Toolbox')
        disp('Symbolic Math Toolbox is installed: symbolic derivation')
e
        % fun 1
        info_fun1 = functions(fun1);
        fun1_type = info_fun1.function;
        if contains(fun1_type,'polyval') % derivé d'un poynome
            fun1_p = info_fun1.workspace{1}.p;
            dp_fun1 = polyder(fun1_p);
            df_fun1 = @(x) polyval(dp_fun1, x);
            m1 = df_fun1(x_i);
        else
            disp('fun1 is not a polynomia: numeric derivation')
            epison = 1e-6;
            m1 = (fun1(x_i+epison) - fun1(x_i-epison)) / (2*epison);
        end

        % fun 2
        info_fun2 = functions(fun2); 
        fun2_type = info_fun2.function;
        if contains(fun2_type,'polyval') % derivé d'un poynome
            fun2_p = info_fun2.workspace{1}.p;
            dp_fun2 = polyder(fun2_p);
            df_fun2 = @(x) polyval(dp_fun2, x);
            m2 = df_fun2(x_i);
        else
            disp('fun2 is not a polynomia: numeric derivation')
            epison = 1e-6;
            m2 = (fun2(x_i+epison) - fun2(x_i-epison)) / (2*epison);
        end

    else
        disp('Symbolic Math Toolbox is not installed: numeric derivation')

        epison = 1e-6;

        % Dérivée numérique (difference central finie
        m1 = (fun1(x_i+epison) - fun1(x_i-epison)) / (2*epison);
        m2 = (fun2(x_i+epison) - fun2(x_i-epison)) / (2*epison);
    end


    % Formule de l'angle entre deux droites
    theta = atan(abs((m1 - m2) / (1 + m1*m2)));

    % Conversion en degrés
    theta_deg = rad2deg(theta);
catch M
    disp(M)
end
end