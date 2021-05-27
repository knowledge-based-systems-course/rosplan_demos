#!/usr/bin/env python3

import rospy
from rosplan_planning_system.ActionInterfacePy.RPActionInterface import RPActionInterface

from high_level_robot_api import robot as robot_class

class RPPlace(RPActionInterface):
    def __init__(self):
        # call parent constructor
        RPActionInterface.__init__(self)
        self.robot = robot_class.Robot(enabled_components=['manipulation'])

    def concreteCallback(self, action_msg):
        self.robot.manipulation.go_to_pose('place', wait=True)
        # open gripper
        self.robot.manipulation.open_gripper()
        # retract arm
        self.robot.manipulation.go_to_pose('home', wait=True)
        return True

def main():
    rospy.init_node('rosplan_interface_place_object', anonymous=False)
    rpp = RPPlace()
    rpp.runActionInterface()
