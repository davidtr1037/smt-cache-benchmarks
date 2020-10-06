#!/bin/bash

make -C m4 all
make -C make all
make -C sqlite all
make -C test_driver.bc
make -C libxml2 test_driver.bc
make -C expat test_driver.bc
make -C bash all
make -C json test_driver.bc
make -C libosip test_driver.bc
make -C libyaml test_driver.bc
make -C coreutils all
