#!/usr/bin/env bash
rake build
rsync -avz -e "ssh -p 58422" ./build/ betauser@192.168.215.170:~/entdev/dpmerchant