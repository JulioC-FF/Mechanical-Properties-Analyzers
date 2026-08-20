%========================================================================
% SCRIPT PARA ENSAYO DE FLEXIÓN (3 PUNTOS)
%========================================================================

%---leer datos (cargas y deltaL)---
filename = 'Flexión a 3 puntos 4 baldosas, 2 Superboard, 2 Ladrillos Materiales 2 Pr Rodolfo Abril 16 de 2026.csv';
opts = detectImportOptions(filename);

% Verificamos qué tipo de archivo detectó MATLAB para evitar el error de importación
if isprop(opts, 'DataLines')
    opts.DataLines = [4 Inf]; % Si lo detecta como archivo de texto/CSV normal
elseif isprop(opts, 'DataRange')
    opts.DataRange = 'A4';    % Si lo detecta como hoja de cálculo/Excel
end

opts.VariableNames(1:3) = {'Tiempo', 'Fuerza', 'Desplazamiento'};

datos = readtable(filename, opts);

% --- Extracción y conversión segura a números ---

fuerza_N = datos.Fuerza;
% Si fuerza_N se importó como texto o celda, lo forzamos a número
if iscell(fuerza_N) || isstring(fuerza_N) || ischar(fuerza_N)
    fuerza_N = str2double(strrep(string(fuerza_N), ',', '.'));
end

deltaL_mm = datos.Desplazamiento;
% Si deltaL_mm se importó como texto o celda, lo forzamos a número
if iscell(deltaL_mm) || isstring(deltaL_mm) || ischar(deltaL_mm)
    deltaL_mm = str2double(strrep(string(deltaL_mm), ',', '.'));
end

%---solicitud datos iniciales para FLEXIÓN---
preguntas = {'Ancho de la probeta (b) en mm: ', ...
             'Espesor/Altura de la probeta (d) en mm: ', ...
             'Distancia entre los apoyos (Luz - L) en mm: '};
titulo = 'Configuración inicial del ensayo de flexión';
lineas= 1;

solicitud = inputdlg(preguntas,titulo,lineas);

if isempty(solicitud)
    error('Operación cancelada por el usuario.');
end

b_i = str2double(solicitud{1}); % Ancho
d_i = str2double(solicitud{2}); % Espesor
L_i = str2double(solicitud{3}); % Luz entre apoyos

if isnan(b_i) || isnan(d_i) || isnan(L_i)
    error('Por favor, ingrese solo valores numéricos en la ventana.');
end

%---Cálculo de Esfuerzo y Deformación a Flexión (3 puntos)---
% F en Newtons y dimensiones en mm dan el esfuerzo directamente en MPa
Esfuerzo = (3 * fuerza_N * L_i) ./ (2 * b_i * d_i^2);
Deformacion = (6 * deltaL_mm * d_i) ./ (L_i^2);

%---Gráfica esfuerzo/deformación---
figure('Name','Resultados del ensayo de flexión');
hold on;
plot(Deformacion, Esfuerzo, 'LineWidth', 1.5, 'Color', 'g', 'DisplayName', 'Curva Esfuerzo-Deformación');
grid on;
xlabel('Deformación a flexión \epsilon_f (mm/mm)');
ylabel('Esfuerzo a flexión \sigma_f (MPa)');
title('Gráfica Esfuerzo-Deformación (Flexión)');

%---Módulo de flexión (Equivalente al módulo de Young)---
Valores_elasticos = find(Deformacion < 0.002);

eps_elastico = Deformacion(Valores_elasticos);
sigma_elastico = Esfuerzo(Valores_elasticos);

p = polyfit(eps_elastico,sigma_elastico,1);
E = p(1); 

%---Esfuerzo de fluencia---
offset = 0.002;
recta_offset = E*(Deformacion-offset);

rango_busqueda = find(Deformacion > offset);

[~,punto_relativo] = min(abs(Esfuerzo(rango_busqueda) - recta_offset(rango_busqueda)));
punto_real = rango_busqueda(punto_relativo);

Esfuerzo_fluencia = Esfuerzo(punto_real);
Deformacion_fluencia = Deformacion(punto_real);

indices_grafico = find(recta_offset > 0 & recta_offset < Esfuerzo_fluencia*1.5);
plot(Deformacion(indices_grafico), recta_offset(indices_grafico), 'y--', 'LineWidth', 1, 'DisplayName', 'Límite Elástico (0.2% offset)');
plot(Deformacion_fluencia, Esfuerzo_fluencia, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'y', 'DisplayName', 'Esfuerzo de Fluencia');


%---Esfuerzo máximo (Módulo de Ruptura / MOR)---
[UTS, punto_UTS] = max(Esfuerzo);
Deformacion_UTS = Deformacion(punto_UTS);
plot(Deformacion_UTS, UTS, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', '[1, 0.5, 0]', 'DisplayName', 'Resistencia Máxima (MOR)');

%---Esfuerzo de rotura---
Deformacion_ruptura = Deformacion(end);
Esfuerzo_ruptura = Esfuerzo(end);

plot(Deformacion_ruptura, Esfuerzo_ruptura, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Punto de Ruptura');

%---Leyenda---
legend('Location', 'southeast', 'FontSize', 9)

%---Ductilidad---
Porcentaje_elongacion = Deformacion_ruptura * 100;

%---Tabla de resultados---
nombres = {'Módulo de Flexión'; 'Esfuerzo de Fluencia (0.2%)'; 'Resistencia Máxima (MOR)'; 'Esfuerzo de Ruptura'; 'Deformación Máx.'};
valores = {sprintf('%.2f', E/1000);...
            sprintf('%.2f', Esfuerzo_fluencia);...
            sprintf('%.2f', UTS);...
            sprintf('%.2f', Esfuerzo_ruptura);...
            sprintf('%.2f', Porcentaje_elongacion);};
unidades = {'GPa'; 'MPa'; 'MPa'; 'MPa'; '%'};

datos_finales = [nombres, valores, unidades];

fig_tabla= figure('Name', 'Reporte de Propiedades Mecánicas (Flexión)',...
                  'NumberTitle', 'off',...
                  'MenuBar', 'none', ...
                  'ToolBar', 'none', ...
                  'Position', [400, 400, 450, 180]);

uitable(fig_tabla, ...
    'Data', datos_finales, ...
    'ColumnName', {'Propiedad', 'Valor', 'Unidad'}, ...
    'ColumnWidth', {180, 100, 80}, ...
    'Position', [20, 20, 410, 140], ...
    'RowName', []);

fprintf('\n>> Análisis completo. Se ha generado la tabla de resultados. \n');