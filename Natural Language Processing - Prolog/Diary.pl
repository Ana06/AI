
% Realizado por Ana María Martínez Gómez y Víctor Adolfo Gallego Alcalá

%gramática

consulta:- 
	nl, write('Escribe frase entre corchetes separando palabras con comas '), nl,
	write('o lista vacía para parar '), nl,
	read(F), trata(F).

% tratamiento final
trata([]):- write('Hasta pronto.').

% tratamiento caso general

%caso de añadir
trata(F) :- frase(añadir,Dia,Mes,Hora,Minutos,Persona, F, []), \+ (cita(Dia,Mes,Hora,Minutos,_,_)),
 assert(cita(Dia, Mes, Hora, Minutos, -1, Persona)), escribe_cita1(Dia, Mes, Hora, Minutos, -1, Persona),!,consulta. 
 %El corte se explica en la memoria.
 
trata(F) :- frase(añadir,Dia,Mes,Hora,Minutos,Duracion,Persona, F, []), \+ (cita(Dia,Mes,Hora,Minutos,_,_)),
 assert(cita(Dia, Mes, Hora, Minutos, Duracion, Persona)), escribe_cita1(Dia, Mes, Hora, Minutos, Duracion, Persona),!,consulta. 
 %El corte se explica en la memoria.
 
trata(F) :- (frase(añadir,_,_,_,_,_, F, []); frase(añadir,_,_,_,_,_,_, F, [])), write('Imposible añadir la reunión, hay otra a la misma hora.'), nl,!,consulta.
 
%caso de borrar
trata(F) :- frase(borrar,Dia,Mes,Hora,Minutos, F, []),
 retract(cita(Dia, Mes, Hora, Minutos, Duracion, Persona)), escribe_cita2(Dia, Mes, Hora, Minutos, Duracion, Persona),!,consulta. 
 %El corte se explica en la memoria.

trata(F) :- frase(borrar,Persona, F, []),
 retract(cita(Dia, Mes, Hora, Minutos, Duracion, Persona)), escribe_cita2(Dia, Mes, Hora, Minutos, Duracion, Persona),!,consulta. 
 %El corte se explica en la memoria.
 
trata(F) :- (frase(borrar,_,_,_,_, F, []);frase(borrar,_, F, [])), write('Imposible borrar la reunión, no existe.'), nl, !,consulta.

%caso de consultar

trata(F) :- frase(consultar,Dia,Mes, F,[]),cita(Dia, Mes, Hora, Minutos, Duracion, _), not(consulta_actual(_,_,_,_,_)),
			assert(consulta_actual(Dia, Mes, Hora, Minutos, Duracion)),
			forall(cita(Dia, Mes, Hora1, Minutos1, _,Persona1), escribe_cita3(Dia, Mes, Hora1, Minutos1, Persona1)),
			!,consulta.
			
trata(F) :- frase(consultar,Dia,Mes, F,[]),cita(Dia, Mes, Hora, Minutos, Duracion, _),retract(consulta_actual(_,_,_,_,_)),
			assert(consulta_actual(Dia, Mes, Hora, Minutos, Duracion)),
			forall(cita(Dia, Mes, Hora1, Minutos1, _,Persona1), escribe_cita3(Dia, Mes, Hora1, Minutos1, Persona1)),
			!,consulta.

trata(F) :- frase(consultar,Dia,Mes,Hora,Minutos, F,[]),cita(Dia, Mes, Hora, Minutos, Duracion, Persona),not(consulta_actual(_,_,_,_,_)), 
			assert(consulta_actual(Dia, Mes, Hora, Minutos, Duracion)),
			escribe_cita3(Dia, Mes, Hora, Minutos, Persona),
			!, consulta . 	
			
trata(F) :- frase(consultar,Dia,Mes,Hora,Minutos, F,[]),cita(Dia, Mes, Hora, Minutos, Duracion, Persona),retract(consulta_actual(_,_,_,_,_)), 
			assert(consulta_actual(Dia, Mes, Hora, Minutos, Duracion)),
			escribe_cita3(Dia, Mes, Hora, Minutos, Persona),
			!, consulta . 			

trata(F) :- (frase(consultar,_,_,F,[]) ; frase(consultar,_,_,_,_,F,[])), nl,write('No hay ninguna reunión en esa fecha'),nl,!, consulta. 
 
%caso de durar
trata(F) :- frase(durar,Dia,Mes,Persona, F,[]),cita(Dia, Mes, _,_, -1, Persona),write('Dato desconocido.'),!, consulta . 	

trata(F) :- frase(durar,Dia,Mes,Persona, F,[]),cita(Dia, Mes, _,_, Duracion, Persona),write('Dura '), write(Duracion), write(' horas'),!, consulta . 

trata(F) :- frase(durar,_,_,_, F,[]),nl,write('No hay ninguna reunión en esa fecha'),nl,!,consulta.

%caso de elipsis

trata(F) :- (frase(elipsis,_,_,F,[]) ; frase(elipsis,F,[])),not(consulta_actual(_,_,_,_,_)), write('Accion no reconocida.'), nl, consulta.

trata(F) :- frase(elipsis,Hora,Minutos,F,[]),consulta_actual(Dia, Mes, _, _, Duracion),
			cita(Dia, Mes, Hora, Minutos, _, Persona), escribe_cita3(Dia, Mes, Hora, Minutos, Persona),
			retract(consulta_actual(Dia, Mes, _, _, Duracion)),
			assert(consulta_actual(Dia,Mes,Hora,Minutos,Duracion)),!,consulta.

trata(F) :- frase(elipsis,F,[]),consulta_actual(_, _, _, _, Duracion),escribe_cita4(Duracion),nl,!,consulta.
						
trata(F) :- frase(elipsis,_,_,F,[]),nl,write('No hay ninguna reunión en esa fecha'),nl,!,consulta.
%otro caso

trata(_) :- write('Accion no reconocida.'), nl, consulta.
 
%Escritura de reuniones.
escribe_cita1(Dia, Mes, Hora, Minutos, Duracion,Persona) :- write('Se ha añadido una reunión con '), escribe_cita(Dia, Mes, Hora, Minutos, Persona),escribe_duracion(Duracion), write('.'), nl.

escribe_cita2(Dia, Mes, Hora, Minutos, Persona) :- write('Se ha eliminado la reunión con '), escribe_cita(Dia, Mes, Hora, Minutos, Persona), write('.'), nl.
	
escribe_cita3(Dia, Mes, Hora, Minutos, Persona) :- write('Tienes una reunión con '),escribe_cita(Dia, Mes, Hora, Minutos,Persona), write('.'), nl.

escribe_cita4(-1):- write('No se sabe').
escribe_cita4(Duracion):- write(Duracion), write(' horas'),nl.

escribe_cita(Dia, Mes, Hora, Minutos, Persona) :- 
	write(Persona), write(' el día '),write(Dia), write(' de '), write(Mes), 
	escribe_hora(Hora), write(':'), escribe_minutos(Minutos).
	
escribe_hora(1):- write(' a la 1').
escribe_hora(Hora) :-write(' a las '), write(Hora).

escribe_minutos(Minutos):- Minutos <10, write(0), write(Minutos).
escribe_minutos(Minutos):- write(Minutos).

escribe_duracion(-1).
escribe_duracion(Duracion):- write(' con una duración de '), write(Duracion), write(' horas').


frase(elipsis) -->
	reconoce_accion(elipsis),
	aux,
	[Cuanto],
	{es_palabra_duracion(Cuanto)},
	aux.

frase(Accion, Persona) -->
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_persona(Persona),
	aux.
	
frase(Accion, Hora, Minutos) -->
	reconoce_accion(Accion),
	aux,
	reconoce_tiempo(Hora, Minutos),
	aux.


frase(Accion,Dia,Mes) -->
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_fecha(Dia,Mes),
	aux.
	

frase(Accion,Dia,Mes,Persona) -->
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_persona(Persona),
	aux,
	reconoce_fecha(Dia,Mes),
	aux.
	
frase(Accion,Dia,Mes,Hora,Minutos) -->
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_fecha(Dia,Mes),
	aux,
	reconoce_tiempo(Hora,Minutos),
	aux.
	
 frase(Accion,Dia,Mes,Hora,Minutos,Persona) --> 
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_persona(Persona),
	aux,
	reconoce_fecha(Dia,Mes),
	aux,
	reconoce_tiempo(Hora,Minutos),
	aux.
	
frase(Accion,Dia,Mes,Hora,Minutos,Duracion,Persona) --> 
	aux,
	reconoce_accion(Accion),
	aux,
	reconoce_persona(Persona),
	aux,
	reconoce_fecha(Dia,Mes),
	aux,
	reconoce_tiempo(Hora,Minutos),
	aux,
	reconoce_duracion(Duracion),
	aux.

