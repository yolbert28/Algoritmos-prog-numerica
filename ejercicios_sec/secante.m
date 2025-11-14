function [raiz, iteraciones, tiempo_ejecucion] = secante(f, TOL, x0, x1, a, b)
% METODO_SECANTE Implementa el algoritmo de la Secante para encontrar raíces.
%
% ENTRADAS:
%   f   : Función simbólica (ej: sym('x^3 - 2*x - 5'))
%   TOL : Tolerancia para el criterio de parada.
%   x0  : Primer valor inicial.
%   x1  : Segundo valor inicial.
%   a   : Límite inferior del intervalo para graficar.
%   b   : Límite superior del intervalo para graficar.
%
% SALIDAS:
%   raiz       : Valor de la raíz encontrado.
%   iteraciones: Número de iteraciones realizadas.
%   tiempo_ejecucion: Tiempo de ejecución del algoritmo.

    % Iniciar cronómetro
    tic;
    pkg load symbolic;
    % Declarar variable simbólica 'x' y convertir a función anónima
    syms x;
    f_num = matlabFunction(f, 'vars', {x});

    % --- Configuración de Parámetros ---
    MAX_ITER = 150;
    x_i_minus_1 = x0; % x_{i-1}
    x_i = x1;         % x_{i}
    error_rel_aprox = Inf;
    iteraciones = 0;

    % Almacenamiento para la evolución gráfica
    puntos_x = [x_i_minus_1, x_i];
    puntos_y = [f_num(x_i_minus_1), f_num(x_i)];

    % --- Gráfica Inicial y Dominio ---
    disp(' ');
    fprintf('Límites del dominio [a, b] para graficar la función: [%f, %f]\n', a, b);

    % Mostrar encabezado de la tabla
    disp(' ');
    disp('--- MÉTODO DE LA SECANTE ---');
    fprintf('%-8s | %-15s | %-15s | %-15s\n', 'Iteración', 'x_k', 'f(x_k)', 'Error Actual');
    disp(repmat('-', 1, 60));

    figure('Name', 'Evolución del Método de la Secante');
    fplot(f_num, [a b], 'b-');
    hold on;
    grid on;
    title('Evolución del Método de la Secante');
    xlabel('x');
    ylabel('f(x)');
    plot(a, 0, 'r.'); % Asegurar que el eje x se vea
    plot(b, 0, 'r.');

    % Graficar puntos iniciales
    plot(x_i_minus_1, f_num(x_i_minus_1), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
    plot(x_i, f_num(x_i), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);

    % --- Bucle de Iteración ---
    while iteraciones < MAX_ITER
        % Evaluar la función en los puntos
        f_xi_minus_1 = f_num(x_i_minus_1);
        f_xi = f_num(x_i);

        % Denominador de la fórmula de la Secante
        denominador = f_xi - f_xi_minus_1;

        % Verificar si el denominador es cercano a cero
        if abs(denominador) < eps('single')
            disp('¡ADVERTENCIA! Denominador muy cercano a cero. El método podría fallar.');
            raiz = x_i;
            tiempo_ejecucion = toc;
            return;
        end

        % Calcular el siguiente iterado (x_{i+1})
        x_siguiente = x_i - f_xi * ((x_i - x_i_minus_1) / denominador);

        % Calcular error relativo aproximado
        if x_siguiente ~= 0
            error_rel_aprox = abs((x_siguiente - x_i) / x_siguiente);
        end

        % Actualizar variables para la próxima iteración
        x_i_minus_1 = x_i;
        x_i = x_siguiente;
        iteraciones = iteraciones + 1;

        % Almacenar para la gráfica
        puntos_x = [puntos_x, x_i];
        puntos_y = [puntos_y, f_num(x_i)];

        % Mostrar fila en la tabla
        fprintf('%-8d | %-15.8f | %-15.8f | %-15.8e\n', iteraciones, x_i, f_num(x_i), error_rel_aprox);

        % Graficar el punto actual
        plot(x_i, f_num(x_i), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5);

        % Criterio de Parada Combinado
        if error_rel_aprox <= TOL || abs(f_num(x_i)) <= TOL
            break;
        end
    end

    % --- Finalización y Resultados ---
    raiz = x_i;
    tiempo_ejecucion = toc;

    fx_final = f_num(raiz);

    disp(repmat('-', 1, 60));
    fprintf('Algoritmo finalizado en %.4f segundos.\n', tiempo_ejecucion);
    fprintf('Raíz obtenida: x = %.10f\n', raiz);
    fprintf('Evaluación de la función en la raíz: f(x) = %.10e\n', fx_final);

    if error_rel_aprox <= TOL || abs(fx_final) <= TOL
        disp('Criterio de parada: Convergió por alcanzar un error o residuo aceptable (<= TOL).');
    else
        disp('Criterio de parada: Alcanzó el máximo de 150 iteraciones.');
    end

    % Graficar la raíz final con una leyenda clara
    plot(raiz, fx_final, 'gx', 'MarkerSize', 10, 'LineWidth', 2);
    legend('Función f(x)', 'Puntos Iniciales', 'Iterados (x_k, f(x_k))', 'Raíz Obtenida', 'Location', 'SouthEast');
    hold off;
% --- INICIO: Bloque de comparación con FZERO (PREGUNTA 4) ---
disp(' ');
disp('--- COMPARACIÓN CON FZERO ---');
try
    % La función ya tiene 'f_num' (el handle) y las variables 'a' y 'b'
    intervalo_fzero = [a, b]; 
    raiz_fzero = fzero(f_num, intervalo_fzero);
    
    fprintf('%-25s | %-15.10f\n', 'Raíz (Método Secante)', raiz);
    fprintf('%-25s | %-15.10f\n', 'Raíz (Control fzero)', raiz_fzero);
    
    diferencia = abs(raiz - raiz_fzero);
    fprintf('Diferencia absoluta: %.10e\n', diferencia);
    
catch ME
    disp('ERROR: fzero no pudo encontrar una raíz en el intervalo [a, b] dado.');
    disp(ME.message);
end
% --- FIN: Bloque de comparación con FZERO ---
end