(define (domain kbs_demo)

(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions)

(:types
	waypoint 
	robot
)

(:predicates
	(robot_at ?r - robot ?wp - waypoint)
)

; Move between any two waypoints
(:durative-action move_base
	:parameters (?r - robot ?from ?to - waypoint)
	:duration ( = ?duration 10)
	:condition (and
		(at start (robot_at ?r ?from)))
	:effect (and
		(at start (not (robot_at ?r ?from)))
		(at end (robot_at ?r ?to)))
)

)
