(mapclass Usuario)
(mapclass Alojamiento)
(mapclass Cadena)
(mapclass Destino)
(mapclass Pais)
(mapclass Region)
(mapclass Transporte)
(mapclass Viaje)
(mapclass ViajeDeseado)


(defrule RtipoClienteJoven
(object(is-a Usuario) (OBJECT ?u)(edad ?edad))
(test (< ?edad 30))
    =>
(assert (tipoCliente ?u joven)))

(defrule RtipoClienteMayor
(object(is-a Usuario) (OBJECT ?u)(edad ?edad))
(test (>= ?edad 30))
    =>
(assert (tipoCliente ?u mayor)))

(defrule RtipoClientePobre 
(object (is-a Usuario) (OBJECT ?u)(num_pasajeros ?m)) 
(object (is-a ViajeDeseado) (usuario ?u) (duracion ?d) (presupuesto ?p)) 
(test (<= (/ (/ ?p ?m) ?d) 5000)) 
   => 
(assert (tipoCliente ?u pobre)))

(defrule RtipoClienteRico
(object (is-a Usuario) (OBJECT ?u)(num_pasajeros ?m)) 
(object (is-a ViajeDeseado) (usuario ?u) (duracion ?d) (presupuesto ?p))
(test (> (/ (/ ?p ?m) ?d) 5000))
    =>
(assert (tipoCliente ?u rico)))


(defrule Rcategoria1
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u)(prefiere $? deportivo $?))
(tipoCliente ?u joven)
    =>
 (assert (tipoViaje ?u aventura))
 )
 
 (defrule Rcategoria2
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere $? culinario $? ))
(tipoCliente ?u joven)
    =>
 (assert (tipoViaje ?u experienciaGastronomica))
 )

(defrule Rcategoria3
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere $? descanso $? ))
(tipoCliente ?u joven)
    =>
 (assert (tipoViaje ?u playa))
 )

(defrule Rcategoria4
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere  $? urbano $? ))
(tipoCliente ?u joven)
    =>
 (assert (tipoViaje ?u compras))
 )
 
 (defrule Rcategoria5
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere  $? deportivo $? ))
(tipoCliente ?u mayor)
    =>
 (assert (tipoViaje ?u deporte))
 )

(defrule Rcategoria6
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere  $? culinario $? ))
(tipoCliente ?u mayor)
    =>
 (assert (tipoViaje ?u altaCocina))
 )

(defrule Rcategoria7
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere  $? descanso $? ))
(tipoCliente ?u mayor)
    =>
 (assert (tipoViaje ?u relax))
 )

(defrule Rcategoria8
(object (is-a Usuario) (OBJECT ?u)) 
(object (is-a ViajeDeseado)(usuario ?u) (prefiere  $? urbano $? ))
(tipoCliente ?u mayor)
    =>
 (assert (tipoViaje ?u cultura))
 )

(defrule Rrecomendacion
(object (is-a Usuario)(OBJECT ?u)(nombre_usuario ?n)(num_pasajeros ?num)(viajes_recomendados $?viajes))
(object (is-a ViajeDeseado)(usuario ?u)(duracion ?dur)(clima ?c)(origen ?o)(regimen_comida_deseado ?regUser)(presupuesto ?pre))
(tipoCliente ?u pobre)
(tipoViaje ?u ?t)
(object (is-a Alojamiento)(OBJECT ?h)(id_alojamiento ?id1)(localizacion_alojamiento  ?loc)(nombre_alojamiento ?naloj)(precio_alojamiento_dia_persona ?p1)(regimen_alojamiento $? ?regUser $?))
(object (is-a Destino)(OBJECT ?loc)(nombre_destino ?des)(clima ?c)(tipo_destino $? ?t $?))
(object (is-a TransporteTurista)(OBJECT ?tIda)(id_transporte ?id2)(origen_transporte ?o)(destino_transporte ?loc)(precio_transporte_persona ?p2))
(object (is-a TransporteTurista)(OBJECT ?tVuelta)(id_transporte ?id3)(origen_transporte ?loc)(destino_transporte ?o)(precio_transporte_persona ?p3))
(test (<= (*(+(* ?p1 ?dur) ?p2 ?p3) ?num) ?pre))
(not (viajeRecomendado ?u ?id1 ?id2 ?id3))
	=>
(assert (viajeRecomendado ?u ?id1 ?id2 ?id3))
(slot-set ?u viajes_recomendados (insert$ ?viajes (calcula (*(+(* ?p1 ?dur) ?p2 ?p3) ?num) ?viajes) (make-instance of Viaje(nombre_viaje (str-cat ?n ?des ?naloj ?id2 ?id3))(alojamiento_viaje ?h)(destino_viaje ?loc)(origen_viaje ?o)(duracion_viaje ?dur)(num_viajeros ?num)(precio (*(+(* ?p1 ?dur) ?p2 ?p3) ?num))(recomendado_a ?u)(medio_transporte_viaje_ida ?tIda)(medio_transporte_viaje_vuelta ?tVuelta))))
)

(defrule Rrecomendacion2
(object (is-a Usuario)(OBJECT ?u)(nombre_usuario ?n)(num_pasajeros ?num)(viajes_recomendados $?viajes))
(object (is-a ViajeDeseado)(usuario ?u)(duracion ?dur)(clima ?c)(origen ?o)(regimen_comida_deseado ?regUser)(presupuesto ?pre))
(tipoCliente ?u rico)
(tipoViaje ?u ?t)
(object (is-a Alojamiento)(OBJECT ?h)(id_alojamiento ?id1)(localizacion_alojamiento  ?loc)(nombre_alojamiento ?naloj)(precio_alojamiento_dia_persona ?p1)(regimen_alojamiento $? ?regUser $?))
(object (is-a Destino)(OBJECT ?loc)(nombre_destino ?des)(clima ?c)(tipo_destino $? ?t $?))
(object (is-a TransporteVIP)(OBJECT ?tIda)(id_transporte ?id2)(origen_transporte ?o)(destino_transporte ?loc)(precio_transporte_persona ?p2))
(object (is-a TransporteVIP)(OBJECT ?tVuelta)(id_transporte ?id3)(origen_transporte ?loc)(destino_transporte ?o)(precio_transporte_persona ?p3))
(test (<= (*(+(* ?p1 ?dur) ?p2 ?p3) ?num) ?pre))
(not (viajeRecomendado ?u ?id1 ?id2 ?id3))
	=>
(assert (viajeRecomendado ?u ?id1 ?id2 ?id3))
(slot-set ?u viajes_recomendados (insert$ ?viajes (calcula (*(+(* ?p1 ?dur) ?p2 ?p3) ?num) ?viajes) (make-instance of Viaje(nombre_viaje (str-cat ?n ?des ?naloj ?id2 ?id3))(alojamiento_viaje ?h)(destino_viaje ?loc)(origen_viaje ?o)(duracion_viaje ?dur)(num_viajeros ?num)(precio (*(+(* ?p1 ?dur) ?p2 ?p3) ?num))(recomendado_a ?u)(medio_transporte_viaje_ida ?tIda)(medio_transporte_viaje_vuelta ?tVuelta))))
)

(defrule RlimitacionHabitantesPais
(object (is-a Usuario)(OBJECT ?u)(nacionalidad ?nac))
(object (is-a Pais)(OBJECT ?nac)(num_habitantes ?num))
(object (is-a Viaje)(OBJECT ?v)(recomendado_a ?u)(destino_viaje ?dest))
(object (is-a Destino)(OBJECT ?dest)(region_destino ?reg))
(object (is-a Region)(OBJECT ?reg)(pais_region ?pais))
(object (is-a Pais)(OBJECT ?pais)(num_habitantes ?num2))
(test (< ?num (/ ?num2 3)))
=>
(unmake-instance ?v)
)

(defrule RalojamientoIntimo
(object (is-a Viaje)(OBJECT ?v)(alojamiento_viaje ?aloj))
(object (is-a Usuario)(OBJECT ?u)(sexo mujer)(viajes_recomendados $? ?v $?))
(object (is-a Alojamiento)(OBJECT ?aloj)(tipo_alojamiento hotel)(propiedad_de ?cad))
(object (is-a Cadena)(OBJECT ?cad)(numero_empleados ?num))
(test (> ?num 1000))
=>
(unmake-instance ?v)
)

(defrule Rborrado
(declare (salience -1))
(object (is-a Usuario)(OBJECT ?u)(viajes_recomendados $?x))
(test (>(length$ ?x) 4))
=>
(slot-set ?u viajes_recomendados (delete$ ?x 5 (length$ ?x)))
)

(deffunction calcula (?p $?viajes)
(bind ?indice 1)
(foreach ?viaje ?viajes
(if (< (slot-get ?viaje precio) ?p) then (return ?indice))
(bind ?indice (+ 1 ?indice)))
(return ?indice)
)


 (reset)
 (run)
 