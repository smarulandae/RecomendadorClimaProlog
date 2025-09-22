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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actividades disponibles
% actividad(Nombre, Tipo, ClimasViables).

actividad(futbol, exterior, [soleado, nublado]).
actividad(basquetbol, exterior, [soleado, nublado]).
actividad(cine, interior, [lluvioso, nublado, tormenta, nevado]).
actividad(lectura, interior, [lluvioso, nublado, tormenta, nevado]).
actividad(correr, exterior, [soleado, nublado]).
actividad(natacion, interior, [soleado, lluvioso, nublado, tormenta, nevado]).
actividad(parque, exterior, [soleado, nublado]).
actividad(videojuegos, interior, [soleado, lluvioso, nublado, tormenta, nevado]).

% Preferencias de los usuarios
% prefiere(Usuario, Actividad).

prefiere(diego, futbol).
prefiere(diego, lectura).
prefiere(diego, parque).

prefiere(santiago, cine).
prefiere(santiago, videojuegos).
prefiere(santiago, natacion).

prefiere(esteban, correr).
prefiere(esteban, basquetbol).
prefiere(esteban, lectura).

prefiere(camilo, correr).
prefiere(camilo, natacion).
prefiere(camilo, cine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reglas lógicas
% Una actividad es viable si su clima está permitido

viable(Actividad, Clima) :-
    actividad(Actividad, _, ListaClimas),
    member(Clima, ListaClimas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recomendación final
% recomendar(Usuario, Ciudad, Actividad).

recomendar(Usuario, Ciudad, Actividad) :-
    get_weather(Ciudad, Clima),
    prefiere(Usuario, Actividad),
    viable(Actividad, Clima).

