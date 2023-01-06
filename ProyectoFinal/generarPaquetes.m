function [] = generarPaquetes(numNodo, ta)
    fprintf('------- Generando paquetes: \n');
    
    global nodo
    global paquet
    global contadorPaquetes_generados
    global contadorPaquetes_red
    
    [paquet(contadorPaquetes_generados).nodo_id, paquet(contadorPaquetes_generados).nodo_grado] = nodoInformacion(nodo_aleatorio); 
    [nodo(numNodo).buffer ,nodo(numNodo).buffer_c] = agregarPaquete(nodo(numNodo).buffer ,nodo(numNodo).buffer_c,contadorPaquetes_generados);
    paquet(contadorPaquetes_generados).tiempoGeneracion=t_sim;
    paquet(contadorPaquetes_generados).tiempoEntradaBuffer=t_sim;
    paquet(contadorPaquetes_generados).tiempoInicioBuffer;
    paquet(contadorPaquetes_generados).estado=-1;
    
    contadorPaquetes_red = contadorPaquetes_red + 1; 
    contadorPaquetes_generados = contadorPaquetes_generados + 1;
end