% =========================================================================
% SCRIPT PRINCIPAL PARA PROBAR MÉTODOS NUMÉRICOS
% =========================================================================
% Este script permite definir los parámetros y llamar a los algoritmos
% de búsqueda de raíces.

clc; % Limpia la ventana de comandos
clear; % Borra las variables del espacio de trabajo
close all; % Cierra todas las figuras

pkg load symbolic; % Carga el paquete de matemática simbólica

% -- Parámetros de Entrada --
f_str = 'x^3 - x - 2'; % 1. Define la función como un string
f = @(x) x^3 - x - 2;  % 2. Convierte a expresión simbólica
x0 = 1.0;              % Primer valor inicial
x1 = 2.0;              % Segundo valor inicial
tolerancia = 0.0001;   % Tolerancia para el criterio de parada
max_iter = 150;        % Máximo de iteraciones
dominio = [0, 3];      % Dominio para graficar la función


% -- Llamada al Método de la Secante --
fprintf('Ejecutando el Método de la Secante...\n');
% 4. Se pasa el function handle 'f' y el string 'f_str' a la función
[raiz_secante, tiempo_secante] = secante(f, f_str, x0, x1, tolerancia, max_iter, dominio);

if ~isnan(raiz_secante)
    fprintf('\nEl método de la secante tardó %f segundos.\n', tiempo_secante);
    
    % -- Método de Control: fzero --
    fprintf('\n--- Comparación con fzero (método de control) ---\n');
    tic;
    raiz_fzero = fzero(f, [x0, x1]);
    tiempo_fzero = toc;
    fprintf('La raíz encontrada por fzero es: %f\n', raiz_fzero);
    fprintf('El método fzero tardó %f segundos.\n', tiempo_fzero);
    fprintf('Diferencia absoluta entre métodos: %e\n', abs(raiz_secante - raiz_fzero));
end
