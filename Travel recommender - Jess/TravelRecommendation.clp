;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Grupo01 Ana María Martínez Gómez - Víctor Adolfo Gallego Alcalá
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module MAIN

(deftemplate usuario
	(slot nombre)
    (slot edad)
    (slot sexo)
    (slot nacionalidad)
    (slot tipoAcompañantes (default ninguno))
    (slot numPasajeros (default 1)))

(deftemplate viajeDeseado
    (slot cliente)
    (slot duracion)
	(slot tipo)
    (slot clima)
    (slot comida)
    (slot presupuesto (default 100000000)))

(deftemplate destino
	(slot nombre)
    (slot climaDestino)
    (slot precioBase)
    (slot extension) ;en km
    (slot densidad) ;de población
    (slot museos) ;numero de museos
    (slot idiomas) ;numero de idiomas
    (slot medallistas) ;numero de medallistas en las olimpidas de ese pais
    (slot costa) ;en km
    (slot michelin) ;estrellas michelin
   )

(deftemplate hotel
  	(slot nombreHotel)
    (slot localizacion)
    (multislot regimenComidas)
    (slot precioDia)
)
(deftemplate compañia
    (slot nombre)
    (slot precioPer)
    (multislot destinos)
    (multislot caracteristicas)
)



(deffacts ini
    (usuario (nombre Ana)(edad 21)(sexo mujer)(nacionalidad española)(tipoAcompañantes negocios)(numPasajeros 5))
    (viajeDeseado (cliente Ana)(duracion 6)(tipo urbano)(clima calido)(comida ninguno))
    (usuario (nombre Victor)(edad 40)(sexo hombre)(nacionalidad china)(tipoAcompañantes pareja)(numPasajeros 2))
    (viajeDeseado (cliente Victor)(duracion 2)(tipo descanso)(clima frio)(comida desayuno)(presupuesto 5000))
    (destino (nombre Barcelona)(climaDestino calido)(precioBase 100)(extension 98)(densidad 16316)(museos 55)(idiomas 2)(medallistas 133)(costa 4)(michelin 28))
    (destino (nombre Maldivas)(climaDestino calido)(precioBase 2000)(extension 298)(densidad 1171)(museos 8)(idiomas 1)(medallistas 0)(costa 2002)(michelin 0))
    (destino (nombre Bogota)(climaDestino calido)(precioBase 1200)(extension 307)(densidad 4336)(museos 58)(idiomas 1)(medallistas 19)(costa 0)(michelin 0))
    (destino (nombre Moscu)(climaDestino frio)(precioBase 700)(extension 2511)(densidad 4822)(museos 60)(idiomas 2)(medallistas 1725)(costa 0)(michelin 0))
    (hotel (nombreHotel TorreCatalunya)(localizacion Barcelona)(regimenComidas ninguno desayuno)(precioDia 200))
    (hotel (nombreHotel MercerHotel)(localizacion Barcelona)(regimenComidas ninguno)(precioDia 220))
    (hotel (nombreHotel ArtsBarcelona)(localizacion Barcelona)(regimenComidas ninguno desayuno mediaPension pensionCompleta todoIncluido)(precioDia 400))
    (hotel (nombreHotel BigHotel)(localizacion Moscu)(regimenComidas ninguno)(precioDia 220))
    (hotel (nombreHotel MoscuHotel)(localizacion Moscu)(regimenComidas ninguno desayuno mediaPension)(precioDia 400))
    (hotel (nombreHotel Sol)(localizacion Bogota)(regimenComidas ninguno)(precioDia 150))
    (hotel (nombreHotel BogotaHotel)(localizacion Bogota)(regimenComidas ninguno desayuno pensionCompleta todoIncluido)(precioDia 300))
    (hotel (nombreHotel Maldivas)(localizacion Maldivas)(regimenComidas ninguno desayuno mediaPension pensionCompleta todoIncluido)(precioDia 500))
    (compañia (nombre Iberia)(precioPer 200)(destinos Barcelona Moscu Bogota Maldivas)(caracteristicas entretenimiento gastronomia ))
    (compañia (nombre Emirates)(precioPer 10000)(destinos Barcelona Moscu Bogota Maldivas)(caracteristicas intimidad higiene entretenimiento gastronomia))
    (compañia (nombre AllNipponAirways)(precioPer 200)(destinos Barcelona Moscu Maldivas)(caracteristicas intimidad entretenimiento))
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modulo CLASIFICACION USUARIO-VIAJE

(defmodule ClasificacionUsuarioViaje)


; El hecho tipoCliente determina si el cliente es joven o mayor.

(defrule RtipoClienteJoven
(usuario (nombre ?n)(edad ?edad))
(test (< ?edad 30))
    =>
(assert (tipoCliente ?n joven)))

(defrule RtipoClienteMayor
(usuario (nombre ?n)(edad ?edad))
(test (>= ?edad 30))
    =>
(assert (tipoCliente ?n mayor)))
  
;exigeEnVuelo determina las caracteristica que debe tener la compañia de vuelo para este usuario

(defrule Rexigencias1
(usuario (nombre ?n) (numPasajeros 1))
=>
    (assert (exigeEnVuelo ?n intimidad))
)

(defrule Rexigencias2
(usuario (nombre ?n) (numPasajeros ?num))
(tipoCliente ?n joven)
(test (<= ?num 6))
=>
    (assert (exigeEnVuelo ?n entretenimiento))
)

(defrule Rexigencias3
(usuario (nombre ?n) (sexo mujer))
=>
    (assert (exigeEnVuelo ?n higiene))
)

(defrule Rexigencias4
(tipoViaje ?n culinario)
=>
    (assert (exigeEnVuelo ?n gastronomia))
)

; El hecho tipoViaje determina qué tipo de destino va a ser asociado a un cliente

(defrule Rcategoria1
(viajeDeseado (cliente ?n) (tipo deportivo))
(tipoCliente ?n joven)
    =>
 (assert (tipoViaje ?n aventura))
 )

(defrule Rcategoria2
(viajeDeseado (cliente ?n) (tipo culinario))
(tipoCliente ?n joven)
    =>
 (assert (tipoViaje ?n expGastronomica))
 )

(defrule Rcategoria3
(viajeDeseado (cliente ?n) (tipo descanso))
(tipoCliente ?n joven)
    =>
 (assert (tipoViaje ?n playa))
 )

(defrule Rcategoria4
(viajeDeseado (cliente ?n) (tipo urbano))
(tipoCliente ?n joven)
    =>
 (assert (tipoViaje ?n compras))
 )

(defrule Rcategoria5
(viajeDeseado (cliente ?n) (tipo deportivo))
(tipoCliente ?n mayor)
    =>
 (assert (tipoViaje ?n deporte))
 )

(defrule Rcategoria6
(viajeDeseado (cliente ?n) (tipo culinario))
(tipoCliente ?n mayor)
    =>
 (assert (tipoViaje ?n altaCocina))
 )

(defrule Rcategoria7
(viajeDeseado (cliente ?n) (tipo descanso))
(tipoCliente ?n mayor)
    =>
 (assert (tipoViaje ?n relax))
 )

(defrule Rcategoria8
(viajeDeseado (cliente ?n) (tipo urbano))
(tipoCliente ?n mayor)
    =>
 (assert (tipoViaje ?n cultura))
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modulo CLASIFICACION DESTINOS

(defmodule ClasificacionDestinos)

;Clasificación de destinos


(defrule RcategoriaDestinoPlaya
    (destino (nombre ?d) (costa ?costa) (climaDestino calido))
    (test (>= ?costa 4))
    => (assert (tipoDestino ?d playa))
    )

(defrule RcategoriaDestinoRelax
    (destino (nombre ?d) (densidad ?den))
    (test (< ?den 5000))
    => (assert (tipoDestino ?d relax))
    )

(defrule RcategoriaDestinoCultura
    (destino (nombre ?d) (museos ?m) (idiomas ?i))
    (test (>= ?m 60))
    (test (>= ?i 2))
    => (assert (tipoDestino ?d cultura))
    )

(defrule RcategoriaDestinoCompras
    (destino (nombre ?d) (extension ?ext) (densidad ?den))
    (test (< ?ext 300))
    (test (> ?den 5000))
    => (assert (tipoDestino ?d compras))
    )

(defrule RcategoriaDestinoDeporte
    (destino (nombre ?d) (climaDestino calido) (medallistas ?m))
    (test (> ?m 130))
    => (assert (tipoDestino ?d deporte))
    )

(defrule RcategoriaDestinoAventura
    (destino (nombre ?d) (costa ?costa) (extension ?ext))
    (test (> ?costa 10))
     (test (> ?ext 200))
    => (assert (tipoDestino ?d aventura))
    )

(defrule RcategoriaDestinoExpGastronomica
    (destino (nombre ?d)(idiomas ?i) (densidad ?den))
    (test (>= ?i 2))
     (test (> ?den 200))
    => (assert (tipoDestino ?d experienciaGastronomica))
    )

(defrule RcategoriaDestinoAltaCocina
    (destino (nombre ?d) (michelin ?m))
    (test (>= ?m 25))
    => (assert (tipoDestino ?d altaCocina))
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modulo RECOMENDACION DESTINO

(defmodule RecomendacionDestino)

;Reglas para recomendar destino

(defrule RrecoDestino
    (usuario (nombre ?n) (numPasajeros ?num))
    (viajeDeseado (cliente ?n) (clima ?clima)(duracion ?dur))
    (destino (nombre ?d) (climaDestino ?clima))
    (ClasificacionUsuarioViaje::tipoViaje ?n ?t)
    (ClasificacionDestinos::tipoDestino ?d ?t)
    => (assert (destinoRecomendado ?n ?d ))
    )

(defrule RrecoHotel
    (usuario (nombre ?n) (numPasajeros ?num))
    (viajeDeseado (cliente ?n) (comida ?comida)(duracion ?dur))
    (destino (nombre Barcelona) (precioBase ?pBase))
    (destinoRecomendado ?n ?destino)
    (hotel (nombreHotel ?h) (localizacion ?destino)(regimenComidas $? ?comida $?)(precioDia ?pDia))
    =>
    (assert (hotelRecomendado ?n ?destino ?h (* ?num  (+ ?pBase (* ?dur ?pDia)))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modulo RECOMENDACION Transporte

(defmodule RecomendacionTransporte)

; Reglas para recomendar compañía aérea

(defrule RrecoAerea
    (usuario (nombre ?n)(numPasajeros ?num))
    (RecomendacionDestino::destinoRecomendado ?n ?d)
    (compañia (nombre ?nomComp)(destinos $? ?d $?)(precioPer ?p))
    => (assert (compañiaAreaRecomendada ?n ?d ?nomComp (* ?p ?num)))
    )

(defrule RrecoAreaCaracteristicas
    (ClasificacionUsuarioViaje::exigeEnVuelo ?n ?car)
    (compañia (nombre ?nomComp))
    (not (compañia (nombre ?nomComp) (caracteristicas $? ?car $?)))
    ?h <- (compañiaAreaRecomendada ?n ? ?nomComp ? )
    => (retract ?h)
    )
(defrule RrecoAereaArabe
    (usuario (nombre ?n)(nacionalidad arabe))
    ?h <- (compañiaAreaRecomendada ?n ? ?nomComp ?)
    (test (or (= ?nomComp AllNipponAirways) (= ?nomComp Iberia)))
    => (retract ?h)
    )

(defrule RrecoAereaChino
    (usuario (nombre ?n)(nacionalidad china))
    ?h <- (compañiaAreaRecomendada ?n ? Iberia ?)
    => (retract ?h)
    )


; Reglas para traslados desde y hasta el aeropuerto

(defrule RrecoTransporte1
    (usuario (nombre ?n) (tipoAcompañantes pareja))
    => (assert (transporteRecomendado ?n limusina 1500))
    )

(defrule RrecoTransporte2
    (usuario (nombre ?n) (sexo hombre)(numPasajeros ?num)(tipoAcompañantes amigos))
    (ClasificacionUsuarioViaje::tipoCliente ?n joven)
    (test (<= ?num 5))
    => (assert (transporteRecomendado ?n cocheDeportivo 3000))
    )

(defrule RrecoTransporte22
    (usuario (nombre ?n) (sexo hombre)(numPasajeros ?num)(tipoAcompañantes amigos))
    (ClasificacionUsuarioViaje::tipoCliente ?n joven)
    (test (> ?num 5))
    => (assert (transporteRecomendado ?n cocheDeportivo 6000))
    )

(defrule RrecoTransporte3
    (usuario (nombre ?n) (sexo mujer)(tipoAcompañantes amigos))
    (ClasificacionUsuarioViaje::tipoCliente ?n joven)
    => (assert (transporteRecomendado ?n limusina 1500))
    )

(defrule RrecoTransporte4
    (usuario (nombre ?n)(numPasajeros ?num)(tipoAcompañantes amigos))
    (ClasificacionUsuarioViaje::tipoCliente ?n mayor)
    (test (<= ?num 5))
    => (assert (transporteRecomendado ?n turismo 100))
    )

(defrule RrecoTransporte42
    (usuario (nombre ?n)(numPasajeros ?num)(tipoAcompañantes amigos))
    (ClasificacionUsuarioViaje::tipoCliente ?n mayor)
    (test (> ?num 5))
    => (assert (transporteRecomendado ?n turismo 200))
    )

(defrule RrecoTransporte5
    (usuario (nombre ?n)(numPasajeros ?num)(tipoAcompañantes negocios))
    (test (<= ?num 4))
    => (assert (transporteRecomendado ?n taxi 100))
    )

(defrule RrecoTransporte52
    (usuario (nombre ?n)(numPasajeros ?num)(tipoAcompañantes negocios))
    (test (> ?num 4))
    => (assert (transporteRecomendado ?n taxi 200))
    )

(defrule RrecoTransporte6
    (usuario (nombre ?n)(tipoAcompañantes familia)(numPasajeros 5))
    => (assert (transporteRecomendado ?n turismo 100))
    )

(defrule RrecoTransporte7
    (usuario (nombre ?n)(tipoAcompañantes familia)(numPasajeros ?num))
    (test (< ?num 5))
    => (assert (transporteRecomendado ?n taxi 100))
    )

(defrule RrecoTransporte72
    (usuario (nombre ?n)(tipoAcompañantes familia)(numPasajeros ?num))
    (test (> ?num 5))
    => (assert (transporteRecomendado ?n taxi 200))
    )

(defrule RrecoTransporte8
    (usuario (nombre ?n)(tipoAcompañantes ninguno)(numPasajeros 1))
    => (assert (transporteRecomendado ?n taxi 100))
        (assert (transporteRecomendado ?n turismo 100))
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modulo RECOMENDACION FINAL
(defmodule RecomendacionFinal)

;Regla final de la recomendación del viaje

(defrule viaje
  (viajeDeseado (cliente ?n) (presupuesto ?pMax))
  (RecomendacionDestino::hotelRecomendado ?n ?d ?h ?p1)
  (RecomendacionTransporte::compañiaAreaRecomendada ?n ?d ?compVuelo ?p2)
  (RecomendacionTransporte::transporteRecomendado ?n ?trans ?p3)
  (test (< (+ ?p1 ?p2 ?p3) ?pMax))
	=>
    (assert (viaje ?n ?d ?h ?compVuelo ?trans (+ ?p1 ?p2 ?p3)))
)



(reset)
(focus ClasificacionUsuarioViaje ClasificacionDestinos RecomendacionDestino RecomendacionTransporte RecomendacionFinal)
(run)
(facts *)
