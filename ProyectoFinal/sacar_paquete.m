function [buffer_nuevo,id] = sacar_paquete(buffer)
    id = buffer(1);
    aux = buffer(2:end);
    buffer_nuevo = [aux 0];
end