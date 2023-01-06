function ta = arribo(ti,lambda)
    u = 1e6*rand()/1e6;
    nuevoTiempo = -(1/lambda)*log(1-u)
    ta = nuevoTiempo + ti;
end