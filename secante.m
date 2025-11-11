function [raiz] = secante(f, x0, x1, error_permitido, max_iteraciones)
    % secante: Encuentra una raíz de f(x) usando el método de la secante.
    %
    % Entradas:
    %   f:        Función a evaluar (function handle, ej: @(x) x^2-2).
    %   x0:       Primer valor inicial.
    %   x1:       Segundo valor inicial.
    %   error_permitido: Tolerancia para el criterio de parada.
    %   max_iteraciones: Límite de iteraciones para evitar bucles infinitos.
    %
    % Salida:
    %   raiz:     La raíz aproximada encontrada. Retorna NaN si falla.
    
    fprintf('Iteración |     x0     |     x1     |     x2     |   Error\n');
    fprintf('------------------------------------------------------------\n');
    
    for i = 1:max_iteraciones
        fx0 = f(x0);
        fx1 = f(x1);
        
        % Prevenir división por cero
        if abs(fx1 - fx0) < eps
            disp('Error: División por cero detectada (f(x1) y f(x0) son muy cercanos).');
            raiz = NaN;
            return;
        end
        
        % Fórmula del método de la secante
        x2 = x1 - (fx1 * (x1 - x0)) / (fx1 - fx0);
        
        % Calcular el error absoluto
        error_actual = abs(x2 - x1);
        
        fprintf('%9d | %10.6f | %10.6f | %10.6f | %10.6f\n', i, x0, x1, x2, error_actual);
        
        % Criterio de parada
        if error_actual < error_permitido
            raiz = x2;
            fprintf('\nRaíz encontrada con éxito en %d iteraciones.\n', i);
            return;
        end
        
        % Actualizar los valores para la siguiente iteración
        x0 = x1;
        x1 = x2;
    end
    
    disp('Se alcanzó el número máximo de iteraciones sin converger a una solución.');
    raiz = NaN; % Retorna NaN si no se encuentra la raíz
endfunction



% Para ejecutar el codigo desde la terminal se debe hacer lo siguiente:

%  1- Definir la función (ej: f(x) = x^3 - x - 2)
% f = @(x) x^3 - x - 2;

%  Llama al método de la secante con los parámetros deseados
% raiz_encontrada = secante(f, 1.0, 2.0, 0.0001, 50)

% Muestra el resultado
% fprintf('La raíz es aproximadamente: %f\n', raiz_encontrada);

