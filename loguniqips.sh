#!/bin/bash

awk '{ips[$3] = ips[$3]+1}END{for(ip in ips){print ip": " ips[ip]}}' < ebs.log
