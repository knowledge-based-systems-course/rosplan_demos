(HybridHTNDomain MobipickDomain)

(MaxArgs 5)
(MaxIntegerArgs 2)

(PredicateSymbols

  # Robot state:
  mobipick_at              # waypoint
  mobipick_has_arm_posture # arm_posture
  mobipick_holding         # physical_object
  
  # Environment
  reachable_from           # area waypoint
  on                       # physical_object area
  
  # Worker
  worker_at                # worker_entity waypoint
  worker_holding           # worker_entity physical_object
  
  
  # Operators
  !mobipick_pick           # ?obj ?grasp_type
  !mobipick_place          # ?obj ?goal_area
  !mobipick_move_arm       # ?named_pose ?keep_gripper_orientation:Boolean
  !mobipick_handover_give  # ?obj ?worker_entity
  !mobipick_handover_get   # ?obj ?worker_entity
  !mobipick_move_base      # ?goal_waypoint
  !mobipick_trigger_object_recognition  # only starts the object recognition (no movement involved)
  !mobipick_detect_user    # trigger user detection
  !mobipick_perceive_object # perceive an object when the robot is standing in front of it
  !replan                  # trigger replanning

  mobipick_adapt_arm       # ?goal_posture
  mobipick_drive           # ?waypoint
  mobipick_get_object      # ?obj ?grasp_type
  mobipick_put_object      # ?obj ?area
  mobipick_move_object     # ?obj ?area
)

################################
#########  RESOURCES ###########
################################

(Resource mobipick_arm_man_capacity 1)

################################
#########  STATE VARIABLES #####
################################

(StateVariable mobipick_has_arm_posture 2 n)

################################
#########  OPERATORS ###########
################################

######### !mobipick_pick #######

(:operator
 (Head !mobipick_pick(?obj ?grasptype))
 (Pre p0 mobipick_at(?mobi_wp))
 (Constraint During(task,p0))
 (Pre p1 on(?obj ?from_area))
 (Del p1)
 (Pre p2 mobipick_holding(nothing))
 (Del p2)
 (Pre p3 reachable_from(?from_area ?mobi_wp))
 (Pre p4 mobipick_has_arm_posture(?old_posture))
 (Del p4)
 (Add e0 mobipick_has_arm_posture(undefined_posture)) # resulting posture depends on action and monitor implementation
 (Add e1 mobipick_holding(?obj))

 (Constraint Duration[3000,INF](task))
 (ResourceUsage
    (Usage mobipick_arm_man_capacity 1))
)

######### !mobipick_place #######

 # place_object
(:operator
 (Head !mobipick_place(?obj ?goal_area))
 (Pre p0 mobipick_at(?mobi_wp))
 (Constraint During(task,p0))
 (Pre p1 reachable_from(?goal_area ?mobi_wp))
 # TODO check if goal_area is free???
 (Pre p2 mobipick_holding(?obj))
 (Del p2)
 (Pre p3 mobipick_has_arm_posture(?old_arm_posture))
 (Del p3)
 (Add e1 mobipick_holding(nothing))
 (Add e2 on(?obj ?goal_area))
 (Add e3 mobipick_has_arm_posture(undefined_posture)) # depends on the action implementation

 (Constraint Duration[4000,INF](task))
 (ResourceUsage
    (Usage mobipick_arm_man_capacity 1))
)


 ######### !mobipick_move_arm #######

(:operator
 (Head !mobipick_move_arm(?new_posture ?keep_gripper_orientation))
 (Pre p0 mobipick_has_arm_posture(?old_arm_posture))
 (Del p0)
 (Add e0 mobipick_has_arm_posture(?new_posture))

 (Constraint Duration[4000,INF](task))
 (ResourceUsage
    (Usage mobipick_arm_man_capacity 1))
)


######### !mobipick_handover_give #######

(:operator
 (Head !mobipick_handover_give(?obj ?worker))
 (Pre p0 mobipick_holding(?obj))
 (Del p0)
 (Pre p1 mobipick_has_arm_posture(?old_arm_posture))
 (Del p1)
 (Pre p2 worker_holding(?worker nothing))
 (Pre p3 mobipick_at(?mobi_wp))
 (Pre p4 worker_at(?worker ?mobi_wp))
 (Add e1 mobipick_holding(nothing))
 (Add e2 mobipick_has_arm_posture(undefined_posture))
 (Add e3 worker_holding(?worker ?obj))
 
 (Constraint Duration[3000,INF](task))
 (ResourceUsage
    (Usage mobipick_arm_man_capacity 1))
)


######### !mobipick_handover_get #######

(:operator
 (Head !mobipick_handover_get(?obj ?worker))
 (Pre p0 mobipick_holding(nothing))
 (Del p0)
 (Pre p1 worker_holding(?obj))
 (Del p1)
 (Pre p2 mobipick_at(?mobi_wp))
 (Pre p3 worker_at(?worker ?mobi_wp))
 (Add e1 mobipick_holding(?obj))
 (Add e2 mobipick_has_arm_posture(undefined_posture))
 (Add e3 worker_holding(?worker nothing))
 
 (Constraint Duration[3000,INF](task))
 (ResourceUsage
    (Usage mobipick_arm_man_capacity 1))
)


######### !mobipick_move_base #######

(:operator
 (Head !mobipick_move_base(?goal_wp))
 (Pre p0 mobipick_has_arm_posture(?arm_posture))
 (Values ?arm_posture tucked_posture transport_posture)
 (Pre p1 mobipick_at(?start_wp))
 (Del p1)
 (Add e1 mobipick_at(?goal_wp))

 # Check connectivity of start and goal?
 # Use duration estimation meta constraint?
)


######### !mobipick_recognize_objects #######

(:operator
 (Head !mobipick_trigger_object_recognition())
 (Constraint Duration[1000,INF](task))
)

######### !mobipick_perceive_object #######
# does this move the arm???
(:operator
 (Head !mobipick_perceive_object(?obj))
 (Pre p0 mobipick_at(?mobi_wp))
 (Constraint During(task,p0))
 (Pre p1 on(?obj ?obj_area))
 (Pre p2 reachable_from(?obj_area ?mobi_wp))
 (Pre p4 mobipick_has_arm_posture(?old_posture))
 (Del p4)
 (Add e0 mobipick_has_arm_posture(undefined_posture)) # resulting posture depends on action and monitor implementation
 (Constraint Duration[3000,INF](task))
)


######### !mobipick_detect_user #######

(:operator
 (Head !mobipick_detect_user())
 (Constraint Duration[1000,INF](task))
)

######### !replan #######

(:operator
 (Head !replan())
 (Constraint Duration[1000,INF](task))
)


################################
#########  METHODS #############
################################

######### mobipick_adapt_arm #######m

# Arm is already there. Nothing to do.
(:method
 (Head mobipick_adapt_arm(?goal_posture))
 (Pre p1 mobipick_has_arm_posture(?goal_posture))
 (Constraint During(task,p1))
)

# Not holding an object: keep_gripper_orientation=false
(:method
 (Head mobipick_adapt_arm(?goal_posture))
 (Pre p0 mobipick_holding(nothing))
 (Pre p1 mobipick_has_arm_posture(?start_posture))
 (VarDifferent ?goal_posture ?start_posture)
 (Sub s1 !mobipick_move_arm(?goal_posture false))
 (Constraint Equals(s1,task))
)

# Holding an object: keep_gripper_orientation=true
(:method
 (Head mobipick_adapt_arm(?goal_posture))
 (Pre p0 mobipick_holding(?obj))
 (NotValues ?obj nothing)
 (Pre p1 mobipick_has_arm_posture(?start_posture))
 (VarDifferent ?goal_posture ?start_posture)
 (Sub s1 !mobipick_move_arm(?goal_posture true))
 (Constraint Equals(s1,task))
)


######### mobipick_drive #######

# Mobipick is already there
(:method
 (Head mobipick_drive(?goal_wp))
  (Pre p1 mobipick_at(?goal_wp))
  (Constraint During(task,p1))
)

# Arm is tucked or in transport posture. Only move_base.
(:method
 (Head mobipick_drive(?goal_wp))
 (Pre p0 mobipick_at(?start_wp))
 (VarDifferent ?start_wp ?goal_wp)

 (Pre p1 mobipick_has_arm_posture(?arm_posture))
 (Values ?arm_posture tucked_posture transport_posture)

 (Sub s0 !mobipick_move_base(?goal_wp))
)

# Mobipick is holding nothing. -> Tuck arm.
(:method
 (Head mobipick_drive(?goal_wp))
 (Pre p0 mobipick_at(?start_wp))
 (VarDifferent ?start_wp ?goal_wp)
 (Pre p1 mobipick_holding(nothing))
 (Pre p2 mobipick_at(?start_wp))
 (VarDifferent ?start_wp ?goal_wp)
 (Pre p3 mobipick_has_arm_posture(?arm_posture))
 (NotValues ?arm_posture tucked_posture transport_posture)
 (Sub s1 mobipick_adapt_arm(tucked_posture))
 (Constraint Starts(s1,task))
 (Sub s2 !mobipick_move_base(?goal_wp))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

# Mobipick is holding an object. -> transport posture.
(:method
 (Head mobipick_drive(?goal_wp))
 (Pre p0 mobipick_at(?start_wp))
 (VarDifferent ?start_wp ?goal_wp)
 (Pre p1 mobipick_holding(?obj))
 (NotValues ?obj nothing)
 (Pre p2 mobipick_at(?start_wp))
 (VarDifferent ?start_wp ?goal_wp)
 (Pre p3 mobipick_has_arm_posture(?arm_posture))
 (NotValues ?arm_posture tucked_posture transport_posture)
 (Sub s1 mobipick_adapt_arm(transport_posture))
 (Constraint Starts(s1,task))
 (Sub s2 !mobipick_move_base(?goal_wp))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

######### mobipick_get_object #######m

# TODO maybe add "empty_hand"

## nothing to do as we are already holding the object
(:method
 (Head mobipick_get_object(?obj ?grasp_type))
 (Pre p0 mobipick_holding(?obj))
)

# Not holding an object
(:method
 (Head mobipick_get_object(?obj ?grasp_type))
 (Pre p0 mobipick_holding(nothing)) # not really necessary as it is also checked by subtask
 (Pre p1 on(?obj ?obj_area))
 (Pre p2 reachable_from(?obj_area ?obj_area_wp))
 (Sub s1 mobipick_drive(?obj_area_wp))
 (Sub s2 !mobipick_perceive_object(?obj))
 (Sub s3 !mobipick_pick(?obj ?grasp_type))
 (Constraint Starts(s1,task))
 (Constraint Before(s1,s2))
 (Constraint Before(s2,s3))
 (Ordering s1 s2)
 (Ordering s2 s3)
)

######### mobipick_put_object #######m

(:method
 (Head mobipick_put_object(?obj ?area))
 (Pre p0 mobipick_holding(?obj)) # not really necessary as it is also checked by subtask
 (Pre p1 reachable_from(?area ?area_wp))
 (Sub s1 mobipick_drive(?area_wp))
 # TODO maybe recognize area
 (Sub s2 !mobipick_place(?obj ?area))
 (Constraint Starts(s1,task))
 (Constraint Before(s1,s2))
 (Ordering s1 s2)
)

######### mobipick_move_object #######m

(:method
 (Head mobipick_move_object(?obj ?area))
 (Sub s1 mobipick_get_object(?obj))
 (Sub s2 mobipick_put_object(?obj ?area))
 (Constraint Starts(s1,task))
 (Constraint Before(s1,s2))
 (Ordering s1 s2)
)
