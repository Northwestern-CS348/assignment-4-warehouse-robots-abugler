(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (started ?s))(not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
       :parameters (?l1 - location ?l2 - location ?r -  robot)
       :precondition(and (no-robot ?l2) (at ?r ?l1) (or (connected ?l1 ?l2) (connected ?l2 ?l1)))
       :effect (and (not (at ?r ?l1)) (not (no-robot ?l2)) (at ?r ?l2) (no-robot ?l1))
   )
   
   (:action robotPickUpPallette
        :parameters (?l - location ?r - robot ?p - pallette)
        :precondition (and (free ?r) (at ?p ?l) (at ?r ?l))
        :effect (and (not (free ?r)) (has ?r ?p))
   )
   
   (:action robotDropPallette
        :parameters (?l - location ?r - robot ?p - pallette)
        :precondition (and (not (free ?r)) (has ?r ?p) (at ?p ?l) (at ?r ?l))
        :effect (and (free ?r) (not (has ?r ?p)))
   )
   
   (:action robotMoveWithPallette
        :parameters (?l1 - location ?l2 - location ?r -  robot ?p - pallette)
       :precondition(and (no-robot ?l2) (at ?r ?l1) (no-pallette ?l2) (at ?p ?l1) (has ?r ?p )(or (connected ?l1 ?l2) (connected ?l2 ?l1)))
       :effect (and (not (at ?r ?l1)) (not (at ?p ?l1))(not (no-robot ?l2))(not (no-pallette ?l2)) (at ?r ?l2)(at ?p ?l2) (no-robot ?l1)(no-pallette ?l1))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?ship - shipment ?sale - saleitem ?p - pallette  ?o - order)
        :precondition (and (packing-location ?l) (packing-at ?ship ?l) (not (includes ?ship ?sale)) (started ?ship) (not (complete ?ship)) (not (unstarted ?ship)) (ships ?ship ?o) (contains ?p ?sale) (at ?p ?l) (orders ?o ?sale))
        :effect (and (includes ?ship ?sale) (not (contains ?p ?sale)))
   )

    (:action completeShipment
        :parameters (?ship - shipment ?o - order ?l - location)
        :precondition (and (not (complete ?ship)) (started ?ship)(not (unstarted ?ship)) (packing-location ?l) (packing-at ?ship ?l) (ships ?ship ?o))
        :effect (and (not (packing-at ?ship ?l)) (available ?l) (not (started ?ship)) (complete ?ship))
    )
)
