
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



:- dynamic cita/6 . %cita(día, mes, hora, minuto, duración, persona).
:- dynamic consulta_actual/5 . %consulta_actual(día, mes, hora, minuto, duración).

aux --> [].
aux --> [Aux],aux, {
	not(es_palabra_accion(Aux,_)),
	not(es_palabra_duracion(Aux)),
	not(integer(Aux)), %porque sino no sabemos donde empieza un día.
	not(es_persona(Aux)),
	not(es_mes(Aux))}.

reconoce_accion(Accion) --> [Palabra] , {es_palabra_accion(Palabra,Accion)}.

reconoce_persona(Persona) --> [Persona] , {es_persona(Persona)}.

reconoce_fecha(Dia,Mes) --> [hoy], {hoy(Dia,Mes)}.
reconoce_fecha(Dia,Mes) --> [mañana], {mañana(Dia,Mes)}.
reconoce_fecha(Dia,Mes) --> 
	reconoce_dia(Dia),
	aux,
	reconoce_mes(Mes).

reconoce_fecha(Dia,Mes) --> reconoce_dia(Dia), {mes_actual(Mes)}.

reconoce_fecha(Dia,Mes) --> {hoy(Dia,Mes)}.
	
reconoce_dia(Dia) --> [Dia] , {integer(Dia), Dia < 32}.

reconoce_mes(Mes) --> [de, Mes] , {es_mes(Mes)}.

reconoce_tiempo(Hora,Minutos) --> ([a];[de]),reconoce_hora(Hora),(reconoce_minutos(Minutos) ; reconoce_minutos_puntos(Minutos)).
reconoce_tiempo(Hora,Minutos) --> ([a];[de]),reconoce_hora(HoraAux),reconoce_minutos_menos(Minutos) , {Hora is HoraAux-1}.
reconoce_tiempo(Hora,0) --> ([a];[de]) , reconoce_hora(Hora).
reconoce_tiempo(Hora,Minutos) --> ([a];[de]) , (reconoce_minutos(Minutos) ; reconoce_minutos_menos(Minutos)), {hora_actual(Hora)}.

reconoce_hora(1) --> [la] , ([una] ; [1]).
reconoce_hora(Hora) --> [las, Hora] , {integer(Hora), Hora > -1, Hora <24}.
reconoce_hora(HoraNumerica) --> [las, HoraLetra], {es_numero_hora(HoraLetra, HoraNumerica), HoraNumerica <24}.

reconoce_minutos(Minutos) --> [y, Minutos] , {integer(Minutos), Minutos > 0, Minutos < 60}.
reconoce_minutos(MinutoNumerico) --> [y], [MinutoLetra] , {es_minuto_exp(MinutoLetra, MinutoNumerico), MinutoNumerico < 60}.

reconoce_minutos_menos(Resultado) --> [menos, Minutos] , {integer(Minutos), Minutos > 0, Minutos < 60, Resultado is 60-Minutos}.
reconoce_minutos_menos(Resultado) --> [menos], [MinutoLetra] , {es_minuto_exp(MinutoLetra, MinutoNumerico), MinutoNumerico < 60, Resultado is 60-MinutoNumerico}.

reconoce_minutos_puntos(Minutos) --> [:,Minutos] , {integer(Minutos), Minutos > -1, Minutos < 60}.

reconoce_duracion(Duracion)  --> [Duracion], {integer(Duracion), Duracion>0}.

% DICCIONARIO


es_palabra_accion(añade, añadir).
es_palabra_accion(pon, añadir).
es_palabra_accion(borra, borrar).
es_palabra_accion(quita, borrar).
es_palabra_accion(consulta, consultar).
es_palabra_accion(tengo, consultar).
es_palabra_accion(hay, consultar).
es_palabra_accion(cuanto, durar).
es_palabra_accion(cuánto, durar).
es_palabra_accion(y, elipsis).

es_palabra_duracion(cuanto).
es_palabra_duracion(cuánto).


es_persona(ana).
es_persona(víctor).
es_persona(carmen).
es_persona(maría).
es_persona(carlos).
es_persona(juan).
es_persona(nuria).

es_mes(enero).
es_mes(febrero).
es_mes(marzo).
es_mes(abril).
es_mes(mayo).
es_mes(junio).
es_mes(julio).
es_mes(agosto).
es_mes(septiembre).
es_mes(octubre).
es_mes(noviembre).
es_mes(diciembre).

% es_numero_hora son los numeros del 2 al 12 escritos con letra
es_numero_hora(dos,2).
es_numero_hora(tres, 3).
es_numero_hora(cuatro, 4).
es_numero_hora(cinco, 5).
es_numero_hora(seis, 6).
es_numero_hora(siete, 7).
es_numero_hora(ocho, 8).
es_numero_hora(nueve, 9).
es_numero_hora(diez, 10).
es_numero_hora(once, 11).
es_numero_hora(doce, 12).

% es_minuto_exp transforma expresiones numericas en numeros
es_minuto_exp(Exp,Num) :- es_minuto(Exp,Num).
es_minuto_exp(cuarto, 15).
es_minuto_exp(media, 30).

% es_minuto tiene los numeros del 1 al 59
es_minuto(uno, 1).
es_minuto(dos, 2).
es_minuto(tres, 3).
es_minuto(cuatro, 4).
es_minuto(cinco,5).
es_minuto(seis, 6).
es_minuto(siete, 7).
es_minuto(ocho, 8).
es_minuto(nueve, 9).
es_minuto(diez,10).
es_minuto(once, 11).
es_minuto(doce, 12).
es_minuto(trece, 13).
es_minuto(catorce, 14).
es_minuto(quince,15).
es_minuto(dieciseis, 16).
es_minuto(diecisiete, 17).
es_minuto(dieciocho, 18).
es_minuto(diecinueve, 19).
es_minuto(veinte, 20).
es_minuto(veintiuno, 21).
es_minuto(veintidos, 22).
es_minuto(veintitres, 23).
es_minuto(veinticuatro, 24).
es_minuto(veinticinco, 25).
es_minuto(veintiseis, 26).
es_minuto(veintisiete, 27).
es_minuto(veintiocho, 28).
es_minuto(veintinueve, 29).
es_minuto(treinta, 30).

hoy(22,X):-mes_actual(X).
mañana(23,X):-mes_actual(X).
hora_actual(19).
mes_actual(mayo).
