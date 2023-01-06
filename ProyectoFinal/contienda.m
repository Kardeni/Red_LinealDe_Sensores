function [ganador, nodosGanadores] = contienda(grado, W)

gradoOriginal = grado;
grado = grado -1;
%Limites de cada uno de los grados
%%la var grado tendra el grado que se esta trabajando
limiteAux5 = (grado*5)+1;
limiteFin5 = limiteAux5+4;
limiteAux10 = grado*10;
limiteFin10 = limiteAux10+10;
limiteAux15 = grado*15;
limiteFin15 = limiteAux15+15;
limiteAux20 = grado*20;
limiteFin20 = limiteAux20+20;

%Auxiliares para las ranuras de tiempo
vectorDeAnalisis = 0;
vectorDeAnalisis2 = 0;

global nodo

fprintf('\n--- Contienda en Grado: %d \n', gradoOriginal);

%Deteccion de numeros de Nodos
if( length(nodo)==35 ) %Entramos al caso de 5 Nodos por grado
    if(grado == 0)
        for aux=1:5
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    else
        for aux = (limiteAux5):limiteFin5
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    end
    gradoAux=limiteAux5-1;
elseif(length(nodo)==70) %Entramos al caso de 10 Nodos por grado
    if(grado == 0)
        for aux=1:10
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    else
        for aux = (limiteAux10+1):limiteFin10
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    end
    gradoAux=limiteAux10;
elseif(length(nodo)==105) %Entramos al caso de 15 Nodos por grado
    if(grado == 0)
        for aux=1:15
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    else
        for aux = (limiteAux15+1):limiteFin15
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    end
    gradoAux=limiteAux15;
    
elseif(length(nodo)==140) %Entramos al caso de 20 Nodos por grado
    if(grado == 0)
        for aux=1:20
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    else
        for aux = (limiteAux20+1):limiteFin20
            vectorDeAnalisis2 = vectorDeAnalisis2 + 1;
            if( ~isempty(nodo(aux).buffer))
                nodo(aux).backOff = ceil((W-1)*rand);
                vectorDeAnalisis(vectorDeAnalisis2) = nodo(aux).backOff;
            end
        end
    end
    gradoAux=limiteAux20;
end

%Aqui seleccionamos el nodo ganador
%vectorDeAnalisis
ganador = min(vectorDeAnalisis);

n = 0; %contador para nodos con Backoff iguales

for i=1:length(vectorDeAnalisis)
    if(ganador == vectorDeAnalisis(i))
        n = n + 1;
        nodosGanadores(n) = gradoAux + i;
    end
end

fprintf('n: %d nodos con Backoff iguales\n', n);

if(n == 1)
    fprintf('Tx exitosa en nodo: %d\n', nodosGanadores);
else
    fprintf('Tx fallida en nodo: %d\n', nodosGanadores);
end

end
