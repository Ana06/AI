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

