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
