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