#!/usr/bin/env python

import psutil
from time import sleep
from sys import stdout

if __name__ == "__main__":
    last_cpu_usage = 0
    last_cpu_temp = 0
    last_mem_usage = 0

    while True:
        cpu_usage = psutil.cpu_percent()
        cpu_temp = round(psutil.sensors_temperatures()["coretemp"][0].current)
        mem_usage = psutil.virtual_memory().percent

        if cpu_usage != last_cpu_usage or cpu_temp != last_cpu_temp:
            last_cpu_usage = cpu_usage
            last_cpu_temp = cpu_temp
            print("{\"CPU\":{\"usage\":" + str(cpu_usage) + ",\"temp\":"
                + str(cpu_temp) + "}}")

        if mem_usage != last_mem_usage:
            last_mem_usage = mem_usage
            print("{\"RAM\":{\"usage\":" + str(mem_usage) + "}}")

        stdout.flush()
        sleep(0.5)
