#!/usr/bin/env python

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

# for your packages to be recognized by python
d = generate_distutils_setup(
  packages=['rosplan_interface_kbs'],
  package_dir={'rosplan_interface_kbs': 'src/rosplan_interface_kbs'}
)

setup(**d)
