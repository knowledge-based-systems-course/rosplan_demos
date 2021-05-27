# rosplan_kbs_demo

The mobipick robot transports a cylinder between different tables. Involves navigation, perception, manipulation and task planning with PDDL 2.1 and ROSPlan.

# Commands to launch

        roscore
        roslaunch mobipick_pick_n_place pick_and_place_all_components.launch
        roslaunch rosplan_kbs_demo rosplan_mobipick.launch
        rqt --standalone rosplan_rqt.esterel_plan_viewer.ROSPlanEsterelPlanViewer --force-discover
        rqt --standalone rosplan_rqt.dispatcher.ROSPlanDispatcher
        rosrun rviz rviz -d $(rospack find mir_navigation)/rviz/navigation.rviz __ns:="mobipick"

Manually add a goal to KB, to navigate to a target waypoint.

Run planning components using convenient script:

        rosrun rosplan_kbs_demo run.sh
