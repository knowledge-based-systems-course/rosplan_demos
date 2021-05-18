(define (problem task)
(:domain kbs_demo)
(:objects
    wp0 wp1 wp2 wp3 wp4 wp5 - waypoint
    mobipick - robot
)
(:init
    (robot_at mobipick wp0)
)
(:goal (and
    ; (robot_at mobipick wp1)
))
)
