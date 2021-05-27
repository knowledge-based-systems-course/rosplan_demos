(define (domain kbs_demo)

(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions :negative-preconditions)

(:types
	waypoint
	robot
	object
)

(:predicates
	(robot_at ?r - robot ?wp - waypoint)
	(object_at ?obj - object ?wp - waypoint)
	(object_perceived ?obj - object)
	(object_grasped ?obj - object)
	(static ?r - robot) ; robot is not moving
)

; Move between any two waypoints
(:durative-action move_base
	:parameters (?r - robot ?from ?to - waypoint)
	:duration ( = ?duration 10)
	:condition (and
		(at start (robot_at ?r ?from)))
	:effect (and
			(at start (not (robot_at ?r ?from)))
			(at end (robot_at ?r ?to))

			(at start (not (static ?r)))
			(at end (static ?r))
		)
)

; perceive object
(:durative-action perceive_object
    :parameters (?obj - object ?r - robot ?wp - waypoint)
    :duration ( = ?duration 2)
    :condition (and (at start (robot_at ?r ?wp))
    				(at start (object_at ?obj ?wp))
               )
    :effect (and (at end (object_perceived ?obj))
            )
)

; pick object
(:durative-action pick_object
    :parameters (?obj - object ?r - robot ?wp - waypoint)
    :duration ( = ?duration 5)
    :condition (and (at start (robot_at ?r ?wp))
    				(at start (object_at ?obj ?wp))
    				(at start (object_perceived ?obj))
    				(over all (static ?r))
               )
    :effect (and (at end (not (object_at ?obj ?wp)))
    			 (at end (object_grasped ?obj))
            )
)

; place object
(:durative-action place_object
    :parameters (?obj - object ?r - robot ?wp - waypoint)
    :duration ( = ?duration 5)
    :condition (and (at start (robot_at ?r ?wp))
    				(at start (object_grasped ?obj))
               )
    :effect (and (at end (object_at ?obj ?wp))
            )
)

)
