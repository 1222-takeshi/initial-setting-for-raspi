#!/bin/bash

sysctl -w net.ipv4.ipfrag_time=3
sysctl -w net.ipv4.ipfrag_high_thresh=134217728
sysctl -w net.core.rmem_max=2147483647
sysctl -w net.core.rmem_default=8388608
ifconfig lo multicast
