function [node_id, nodo_grado] = nodoInformacion(nodo_aleatorio_func)
    fprintf('-----Consulta a nodo: \n');
    
    global nodo
    
    node_id = nodo(nodo_aleatorio_func).id;
    nodo_grado = nodo(nodo_aleatorio_func).grado;
end