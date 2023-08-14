#!/usr/bin/env bash

iptables-save > iptables_$(date +%F_%H-%M).rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X


