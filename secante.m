function [raiz, tiempo_ejecucion] = secante(f, f_str, x0, x1, error_permitido, max_iteraciones, dominio_grafica)
    % secante: Encuentra una raíz de una función usando el método de la secante.
    %
    % Entradas:
    %   f:               Function handle de la función a evaluar (ej: @(x) x^3 - x - 2).
    %   f_str:           String con la función para mostrar en el título del gráfico.
    %   x0:              Primer valor inicial.
    %   x1:              Segundo valor inicial.
    %   error_permitido: Tolerancia para los criterios de parada.
    %   max_iteraciones: Límite de iteraciones para evitar bucles infinitos.
    %   dominio_grafica: Vector de 2 elementos con el dominio para graficar la función [min, max].
    % Salidas:
    %   raiz:            La raíz aproximada encontrada. Retorna NaN si falla.
    %   tiempo_ejecucion: Tiempo que tardó el algoritmo en ejecutarse.
    
    tic; % Iniciar cronómetro
    
    % La preparación de la función (conversión de string a function handle)
    % ahora se realiza en el script principal que llama a esta función.
    
    % -- Sección de Gráfica --
    % -- Algoritmo de la Secante --
    fprintf('\nTabla de Iteraciones del Método de la Secante:\n');
    fprintf('----------------------------------------------------------------------------------\n');
    fprintf('Iter. |      x_i     |     f(x_i)    | Error Relativo |   |f(x_i)| < TOL? \n');
    fprintf('----------------------------------------------------------------------------------\n');
    
    x2 = x1; % Inicializar x2 para el bucle
    
    for i = 1:max_iteraciones
        fx0 = f(x0);
        fx1 = f(x1);
        
        % Criterio de parada: |f(x1)| es suficientemente pequeño
        if abs(fx1) < error_permitido
            raiz = x1;
            fprintf('Convergencia por |f(x)| < TOL en %d iteraciones.\n', i-1);
            break; % Salir del bucle
        end
        
        % Prevenir división por cero en la fórmula de la secante
        if abs(fx1 - fx0) < eps
            disp('Error: División por cero detectada (f(x1) y f(x0) son muy cercanos).');
            raiz = NaN;
            tiempo_ejecucion = toc;
            return;
        end
        
        % Fórmula del método de la secante
        x2 = x1 - (fx1 * (x1 - x0)) / (fx1 - fx0);
        
        % Calcular el error relativo aproximado
        error_relativo = abs((x2 - x1) / x2);
        
        % Preparar el string para la tabla
        if (abs(f(x2)) < error_permitido)
            converged_str = 'true';
        else
            converged_str = 'false';
        end
        % Mostrar la evolución en la tabla
        fprintf('%5d | %12.6f | %13.6f | %14.6f | %15s\n', i, x2, f(x2), error_relativo, converged_str);

        % -- Graficación por Iteración --
        figure; % Crea una nueva figura para cada iteración
        hold on;
        grid on;
        
        % Dibuja la función original (usando plot en lugar de fplot para compatibilidad con Octave)
        x_vals = linspace(dominio_grafica(1), dominio_grafica(2), 200); % Genera 200 puntos en el dominio
        % Se evalúa la función punto por punto para evitar errores de vectorización.
        y_vals = zeros(size(x_vals)); % Pre-asigna memoria para y_vals
        for k = 1:length(x_vals)
            y_vals(k) = f(x_vals(k));
        end
        plot(x_vals, y_vals, 'LineWidth', 2, 'DisplayName', ['f(x) = ' f_str]);

        
        % Dibuja la línea secante usada en esta iteración
        plot([x0, x1], [fx0, fx1], '--r', 'DisplayName', 'Línea Secante');
        
        % Marca los puntos usados para la secante
        plot([x0, x1], [fx0, fx1], 'o', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black', 'DisplayName', 'Puntos para secante');
        
        % Marca el nuevo punto calculado
        plot(x2, f(x2), 'p', 'MarkerSize', 15, 'MarkerFaceColor', 'magenta', 'DisplayName', 'Nuevo iterado x_i');
        
        % Configura el título y las etiquetas con la información de la iteración
        title_str = sprintf('Iteración: %d | x_i = %.6f | f(x_i) = %.2e | Error rel. = %.2e', i, x2, f(x2), error_relativo);
        title(title_str);
        xlabel('x');
        ylabel('f(x)');
        % Se usa una llamada a legend compatible con Octave para evitar warnings.
        legend('Location', 'northeast');
        hold off;
        
        % Criterio de parada: error relativo es suficientemente pequeño
        if error_relativo < error_permitido
            raiz = x2;
            fprintf('Convergencia por Error Relativo < TOL en %d iteraciones.\n', i);
            break; % Salir del bucle
        end
        
        % Actualizar los valores para la siguiente iteración
        x0 = x1;
        x1 = x2;
        
        % Criterio de parada: máximo de iteraciones
        if i == max_iteraciones
            raiz = x2;
            disp('Se alcanzó el número máximo de iteraciones.');
            break;
        end
    end
    
    % -- Sección de Resultados --
    % El último cuadro de la animación ya muestra la raíz encontrada.
    % Se actualiza el título para reflejar que es el resultado final.
    final_title_str = sprintf('Raíz encontrada en %d iteraciones!', i);
    title(final_title_str);

    
    fprintf('\nResultado final:\n');
    fprintf('El valor de la raíz es: %f\n', raiz);
    fprintf('El valor de f(raíz) es: %e\n', f(raiz));
    
    tiempo_ejecucion = toc; % Detener cronómetro
end
