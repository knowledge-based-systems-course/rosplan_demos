#!/usr/bin/env python3

import rospy, tf, actionlib
import actionlib_msgs.msg

from rosplan_planning_system.ActionInterfacePy.RPActionInterface import RPActionInterface
from std_srvs.srv import Empty
from geometry_msgs.msg import PoseStamped
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal

from high_level_robot_api import robot as robot_class

class RPMoveBasePy(RPActionInterface):
    def __init__(self):
        # call parent constructor
        RPActionInterface.__init__(self)
        # get waypoints reference frame from param server
        self.waypoint_frameid = rospy.get_param('~waypoint_frameid', 'map')
        self.wp_namespace = rospy.get_param('~wp_namespace', '/rosplan_demo_waypoints/wp')
        # instantiating Robot object
        self.robot = robot_class.Robot(enabled_components=['navigation', 'manipulation'])
        # symbolic, subymbolic dictionary
        # x, y, z, q1, q2, q3, q4
        self.dic = {'left_table': [18.022, 4.014, 0.0, 0.0, 0.0, 1.0, 0.008],
                    'right_table': [20.0, 8.0, 0.0, 0.0, 0.0, -0.9999762992466819, 0.006884834414179017] }

    def concreteCallback(self, action_msg):
        symbolic_pose = None
        for param in action_msg.parameters:
            if param.key == 'to':
                symbolic_pose = param.value
        if not symbolic_pose:
            rospy.logerr('cannot find navigation goal inside action parameters, to? key does not exist')
            return False
        subsymbolic_pose = self.dic[symbolic_pose]
        # move arm to a pose within the robot footprint
        self.robot.manipulation.go_to_pose('transport', wait=True)
        # send navigation goal
        if self.robot.navigation.go_to_2d_pose(x=subsymbolic_pose[0], y=subsymbolic_pose[1], quaternion=subsymbolic_pose[3:], timeout=40.0):
            rospy.loginfo('goal was achieved!')
            return True
        else:
            rospy.loginfo('goal was not achieved')
            return False

def main():
    rospy.init_node('rosplan_interface_movebase', anonymous=False)
    rpmb = RPMoveBasePy()
    rpmb.runActionInterface()
