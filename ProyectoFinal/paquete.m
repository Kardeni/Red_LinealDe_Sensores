classdef paquete 
    properties
        %del paquete
        id;
        grado;
        %del nodo que tiene el paquete
        nodo_id;
        nodo_grado;
        %estampas de tiempo del paquete
        tiempoGeneracion;
        tiempoEntradaBuffer;
        tiempoInicioBuffer;
        tiempoTx;
        estado;
        apuntador;
    end
    methods
        function obj=paquete()
            
        end
    end
end