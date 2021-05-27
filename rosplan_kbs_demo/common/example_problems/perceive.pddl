(define (problem task)
(:domain kbs_demo)
(:objects
    start left_table right_table - waypoint
    mobipick - robot
    cylinder - object
)

(:init
    (robot_at mobipick start)
    (object_at cylinder left_table)
)

(:goal (and
    (object_perceived cylinder)
    ; (robot_at mobipick left_table)
))

)
