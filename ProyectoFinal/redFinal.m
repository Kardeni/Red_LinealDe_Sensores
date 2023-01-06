close all
clear all
clc

global nodo;
nodo = Nodos;

global paquet;
paquet = paquete;

numGrados = [1 2 3 4 5 6 7]; %observa que el cero es el sink y son 7 grados
gradoActual = 7; %I 
s=15; %Tamaño de buffer
nodosPorGrado = 10;
W=16;
n=0; %aux
gradoN = 0;

%Tiempos 
DIFS = 10e-3; %Distributed Interframe Space
SIFS = 5e-3; %Short Interframe Space
RTS = 11e-3;%Ready to send
CTS = 11e-3;%Clear to send
ACK = 11e-3;%Acknowledge
DATA = 43e-3; %Sending data
Gamma = 1e-3; %Miniranura
shi = 18; %Número de ranuras de sleeping
lambda = 0.0003; 

array_retardo1 = zeros(1,gradoActual); %cuenta el retardo desde que entra al buffer hasta que llega al header, por grados
array_retardo2 = zeros(1,gradoActual); %cuenta el retardo desde que llega al header hasta que sale del buffer, por grados
contador_retardo1 = 0;
c_r2 = 0;

ciclos = 1000; %numero de ciclos 

%%%Aqui se generan todos los nodos nodosPorGrado*numGrados%%%
for i = 1:length(numGrados)
    for i2=1:nodosPorGrado
        n=n+1;
        nodo(n).id = n; %%se agrega el id
        nodo(n).grado = i-1; %%se agrega el grado
        nodo(n).orden = i2; %%orden auxiliar para la rx

    end
end

%%Con estas variables administro los paquetes%%
global contadorPaquetes_red;
contadorPaquetes_red = 0; %contador de los paquetes en la red

global contadorPaquetes_generados;
contadorPaquetes_generados =0; %contador de los paquetes generados (sin importar que se pierdan)
contador_Paquetes_perdidos=0;
contador_Paquetes_transmitidos=0;
array_paquetes_perdidos=0;
array_paquetes_totales=0;

%%%Generando los tiempos%%%
lambda2 = lambda*nodosPorGrado*gradoActual;%tasa de generacion de paquetes
T = Gamma*W+ DIFS + (3*SIFS) + RTS + CTS + DATA + ACK; %tiempo de ranura
Tc = T*(shi+2); %tiempo de ciclo

t_sim = 0; %tiempo de simulacion
ta = 0; %tiempo de arribo
t_txt=0; % tiempo de transmision


%%% Generacion primer paquete%%% 
nodo_aleatorio = randi([1,nodosPorGrado*gradoActual]); 
%incrementamos contadores
contadorPaquetes_red = contadorPaquetes_red + 1; %Observa que este contador cambiara conforme los pkts dejen la red
contadorPaquetes_generados = contadorPaquetes_generados + 1; 
%Consultar info del nodo al pkt
[paquet(1).nodo_id, paquet(1).nodo_grado] = nodoInformacion(nodo_aleatorio);
%Asignando id de pkt a nodo
[nodo(nodo_aleatorio).buffer ,nodo(nodo_aleatorio).buffer_c] = agregarPaquete(nodo(nodo_aleatorio).buffer ,nodo(nodo_aleatorio).buffer_c,contadorPaquetes_generados);
paquet(1).tiempoEntradaBuffer = t_sim;
paquet(1).tiempoInicioBuffer = t_sim;
paquet(1).estado = -1; 
%Ajuste para funcion
% contadorPaquetes_red = contadorPaquetes_red + 1; 
% contadorPaquetes_generados = contadorPaquetes_generados + 1;
% 






%%%Se inicializan los ciclos %%%
for e = 1:ciclos
     for gradoActual = (length(numGrados)):-1:1
         %%LA TRANSMISION%%
            [ganadorValor, nodosColisionados] = contienda(gradoActual, W);
            if(ganadorValor)%Nadie transmite, bufferes vacios
                %No hay nada que hacer
            elseif(length(nodosColisionados)>1)%Hay colisiones
                nodosColisionados;
                for a=1:length(nodosColisionados)
                    contador_Paquetes_perdidos = contador_Paquetes_perdidos + 1;
                    %array_paquetes_perdidos(gradoActual) = array_paquetes_perdidos(gradoActual)+ 1;
                    for s = 1:contadorPaquetes_red
                              if(paquet(s).id == nodo(nodosColisionados(a)).buffer(1))
                                apuntador = s;
                              end
                              if(paquet(s).id == nodo(nodosColisionados(a)).buffer(2))
                                siguiente = s;
                              end
                    end
                    contadorPaquetes_red = contadorPaquetes_red -1;
                    nodo(nodosColisionados(a)).buffer_c = nodo(nodosColisionados(a)).buffer_c -1;
                    %%Aqui se reescribe el buffer del paquete
                    nodo(nodosColisionados(a)).buffer = sacar_paquete(nodo(nodosColisionados(a)).buffer);
                    %%Se elimina el paquete
                    paquet(apuntador).estado = -3;
                end 
            elseif(length(nodosColisionados)==1)%Hay un nodo ganador
                %a=1;
                nodo(nodosColisionados).buffer_c = nodo(nodosColisionados).buffer_c-1; %disminuye el contador de espacios ocupados del buffer del nodo ganador
                for j = 1:contadorPaquetes_red
                          if(paquet(j).id == nodo(nodosColisionados).buffer(1))
                            apuntador = j;
                          end
                          if(paquet(j).id == nodo(nodosColisionados).buffer(2))
                            siguiente = j;
                          end
                end
                       paquet(apuntador).tiempoTx = t_sim; %guardamos el instante en el que el paquete sale del buffer
                       tiempoTx = t_sim;
                       [nodo(nodosColisionados(a)).buffer, id] = sacar_paquete(nodo(nodosColisionados(a)).buffer);%libera el espacio del paquete en el buffer del nodo ganador
                       contador_Paquetes_transmitidos = contador_Paquetes_transmitidos +1;
                       
                if(nodo(nodosColisionados(a)).buffer_c > 0)%si aun hay paquete a transmitir
                     paquet(siguiente).t_stamp3 = t_sim; %liberamos el paquete y despues se guarda la posicion del paquete que viene (al principio)
                     array_retardo1(gradoActual) = array_retardo1(gradoActual) + abs(paquet(siguiente).tiempoInicioBuffer - paquet(siguiente).tiempoEntradaBuffer); %aumenta los retardo1 del grado x
                     contador_retardo1 = contador_retardo1+1;
                end
                %EL paquete va a pasar al nodo sink
                id_paquetes_tx = -1;                   
                nodo_siguiente = -1;
                paquet(apuntador) = [];%se elimina el paquete de la red, ya que no es necesario seguir almacenándolo
                contadorPaquetes_red = contadorPaquetes_red-1;
                t_sim = t_sim + T;%Aqui se acaba la ranura de tx
            end
         
        
            
    %%LA RECEPCION%%
        while (ta<= t_sim && t_sim ~= 0)
            %%%Aqui se generan los paquetes%%% 
            nodo_aleatorio = randi([1,nodosPorGrado*gradoActual]); %un nodo aleatorio
            contadorPaquetes_generados = contadorPaquetes_generados+1; 
            
            array_paquetes_totales(floor((nodo_aleatorio-1)/nodosPorGrado)+1) = array_paquetes_totales(floor((nodo_aleatorio-1)/nodosPorGrado)+1) + 1; %aumenta el contador de nodos en el grado
            if (nodo(nodo_aleatorio).buffer_c < 15)%checamos que haya espacio en el buffer
                generarPaquetes(nodo(nodo_aleatorio).id,ta);
                
               if(nodo(nodo_aleatorio).buffer_c == 1) %si ya se encuentra en el header del buffer
                  paquet(contadorPaquetes_red).tiempoInicioBuffer = ta; %tiempo en el que llega al header del buffer
                  array_retardo1(gradoActual) = array_retardo1(gradoActual) + abs(paquet(contadorPaquetes_red).tiempoInicioBuffer - paquet(contadorPaquetes_red).tiempoEntradaBuffer);%aumenta los retardo1 del grado x
                  contador_retardo1 = contador_retardo1+1;
               end
               else %si no hay espacio se pierde un paquete
         
                contador_Paquetes_perdidos = contador_Paquetes_perdidos +1; 
                array_paquetes_perdidos(floor((nodo_aleatorio-1)/N)+1) = array_paquetes_perdidos(floor((nodo_aleatorio-1)/N)+1)+ 1;
            end
               ta = arribo(ta,lambda); %genera un nuevo tiempo de arribo
        end      
     end
     %paquet
     %pause;
     
end        
             %%%%RESULTADOS%%%%


