% SISTEMA EXPERTO DE RECOMENDACIÓN DE ACTIVIDADES
% Usando clima en tiempo real con Open-Meteo

:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coordenadas de ciudades
coords(medellin,   6.2442, -75.5812).
coords(pereira,    4.8133, -75.6961).
coords(bogota,     4.6097, -74.0817).
coords(cali,       3.4372, -76.5225).
coords(cartagena, 10.3997, -75.5144).

% Códigos Open-Meteo 
traducir_codigo(0, soleado).
traducir_codigo(1, soleado).
traducir_codigo(2, nublado).
traducir_codigo(3, nublado).
traducir_codigo(45, nublado).
traducir_codigo(48, nublado).
traducir_codigo(Code, lluvioso) :- member(Code, [51,53,55,61,63,65,80,81,82]).
traducir_codigo(Code, nevado)   :- member(Code, [71,73,75,77,85,86]).
traducir_codigo(Code, tormenta) :- member(Code, [95,96,99]).
traducir_codigo(_, desconocido).
