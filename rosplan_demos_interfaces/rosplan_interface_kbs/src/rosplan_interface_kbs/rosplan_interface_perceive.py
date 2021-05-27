#!/usr/bin/env python3

import rospy
from rosplan_planning_system.ActionInterfacePy.RPActionInterface import RPActionInterface

class RPPerceive(RPActionInterface):
    def __init__(self):
        # call parent constructor
        RPActionInterface.__init__(self)

    def concreteCallback(self, action_msg):
        return True

def main():
    rospy.init_node('rosplan_interface_perceive', anonymous=False)
    rpp = RPPerceive()
    rpp.runActionInterface()
