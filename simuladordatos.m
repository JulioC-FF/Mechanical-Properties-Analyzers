% --- Generador de Datos de Ensayo de Tensión ---
clear; clc;

% 1. Parámetros de la Probeta (Geometría)
L0 = 50;          % Longitud inicial (mm)
d0 = 12.5;        % Diámetro inicial (mm)
A0 = pi*(d0/2)^2; % Área inicial (mm^2)

% 2. Propiedades del Material Simulado (Aluminio)
E_teorico = 70000;    % Módulo de Young (MPa)
sigma_y = 270;        % Esfuerzo de fluencia (MPa)
K = 450;              % Coeficiente de resistencia (MPa)
n = 0.15;             % Coeficiente de endurecimiento

% 3. Generar vector de deformación (strain)
epsilon = linspace(0, 0.15, 500)'; % De 0 a 15% de deformación

% 4. Modelo de Esfuerzo (Piecewise: Elástico + Plástico)
esfuerzo = zeros(size(epsilon));
for i = 1:length(epsilon)
    if epsilon(i) * E_teorico <= sigma_y
        esfuerzo(i) = E_teorico * epsilon(i); % Zona Elástica
    else
        % Zona Plástica (Ecuación de Hollomon)
        esfuerzo(i) = K * (epsilon(i))^n; 
    end
end

% 5. Añadir ruido blanco para hacerlo realista
esfuerzo = esfuerzo + randn(size(esfuerzo)) * 1.5; 

% 6. Convertir a Carga (N) y Desplazamiento (mm)
Fuerza_N = esfuerzo * A0;
Desplazamiento_mm = epsilon * L0;

% 7. Crear la tabla y exportar a Excel
T = table(Fuerza_N, Desplazamiento_mm, 'VariableNames', {'Carga_N', 'DeltaL_mm'});
writetable(T, 'datos_ensayo.xlsx');

fprintf('¡Archivo "datos_ensayo.xlsx" generado con éxito!\n');
plot(Desplazamiento_mm, Fuerza_N);
title('Datos Brutos Generados (Carga vs Desplazamiento)');
xlabel('Desplazamiento (mm)'); ylabel('Carga (N)'); grid on;
 

