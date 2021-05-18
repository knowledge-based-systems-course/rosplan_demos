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
        self.robot = robot_class.Robot(enabled_components=['navigation'])

    def wpIDtoPoseStamped(self, wpID):
        result = None
        if rospy.has_param(self.wp_namespace + '/' + wpID):
            wp = rospy.get_param(self.wp_namespace + '/' + wpID)
            if wp:
                if len(wp) == 3:
                    result = PoseStamped()
                    result.header.frame_id = self.waypoint_frameid
                    # result.header.stamp = rospy.Time.now()
                    result.pose.position.x = wp[0]
                    result.pose.position.y = wp[1]
                    result.pose.position.z = 0.0

                    q = tf.transformations.quaternion_from_euler(0, 0, wp[2])
                    result.pose.orientation.x = q[0]
                    result.pose.orientation.y = q[1]
                    result.pose.orientation.z = q[2]
                    result.pose.orientation.w = q[3]
                else:
                    rospy.logerr('wp size must be equal to 3 : (x, y, and theta)')
        return result

    def concreteCallback(self, msg):
        # send navigation goal
        quaternion = [0.0, 0.0, 1.0, 0.008]
        if self.robot.navigation.go_to_2d_pose(x=18.022, y=4.014, quaternion=quaternion, timeout=40.0):
            rospy.loginfo('goal was achieved!')
            return True
        else:
            rospy.loginfo('goal was not achieved')
            return False

def main():
    rospy.init_node('rosplan_interface_movebase', anonymous=False)
    rpmb = RPMoveBasePy()
    rpmb.runActionInterface()
