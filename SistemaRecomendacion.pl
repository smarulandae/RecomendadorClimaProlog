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

% Obtener clima desde Open-Meteo
% get_weather(City, Weather).
% Weather -> etiqueta simplificada (soleado, nublado, lluvioso, nevado, tormenta)

get_weather(City, Weather) :-
    coords(City, Lat, Lon),
    format(string(URL),
           "https://api.open-meteo.com/v1/forecast?latitude=~w&longitude=~w&current_weather=true",
           [Lat, Lon]),
    http_open(URL, Stream, []),
    json_read_dict(Stream, Dict),
    close(Stream),
    Code = Dict.current_weather.weathercode,
    traducir_codigo(Code, Weather).
