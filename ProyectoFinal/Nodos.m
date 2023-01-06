% close all
% clear all

classdef Nodos
   properties
        id {mustBeNumeric};
        grado;
        %Notese que este buffer debe ser un arreglo de enteros que contenga el ID los pkts
        buffer(1,15); 
        buffer_c; %Espacios ocupados del Buffer
        backOff;
        orden;
   end
   methods
        function obj=Nodos()
        end
    end
end