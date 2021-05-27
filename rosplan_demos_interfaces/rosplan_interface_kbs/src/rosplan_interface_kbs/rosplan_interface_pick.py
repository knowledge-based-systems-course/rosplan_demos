#!/usr/bin/env python3

import rospy
from rosplan_planning_system.ActionInterfacePy.RPActionInterface import RPActionInterface
from high_level_robot_api import robot as robot_class

class RPPick(RPActionInterface):
    def __init__(self):
        # call parent constructor
        RPActionInterface.__init__(self)
        # instantiating Robot object
        self.robot = robot_class.Robot(enabled_components=['manipulation'])

    def concreteCallback(self, action_msg):
        # pick
        object_to_be_picked = None
        for param in action_msg.parameters:
            if param.key == 'obj':
                object_to_be_picked = param.value
        if not object_to_be_picked:
            rospy.logerr('cannot find object to the picked inside action parameters, obj? key does not exist')
            return False
        rospy.loginfo(f'picking object: {object_to_be_picked}')
        return self.robot.manipulation.pick(object_to_be_picked)

def main():
    rospy.init_node('rosplan_interface_pick', anonymous=False)
    rpp = RPPick()
    rpp.runActionInterface()
