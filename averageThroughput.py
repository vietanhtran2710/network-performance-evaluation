import sys

EVENT, TIME, FROM_NODE, TO_NODE, PACKET_TYPE, PACKET_SIZE = 0, 1, 2, 3, 4, 5
FLAGS, FID, SOURCE_ADDRESS, DST_ADDRESS, SEQ_NUM, PKT_ID = 6, 7, 8, 9, 10, 11
CONDITIONS = {
    "tcp0": {TO_NODE: '5', EVENT: 'r'},
    "tcp1": {TO_NODE: '6', EVENT: 'r', PACKET_TYPE: 'tcp'},
    "tcp2": {TO_NODE: '7', EVENT: 'r'},
    "udp": {TO_NODE: '6', EVENT: 'r', PACKET_TYPE: 'cbr'},
}
ACK_CONDITIONS = {
    "tcp0": {FROM_NODE: '5', TO_NODE: '4', EVENT: '+'},
    "tcp1": {FROM_NODE: '6', TO_NODE: '4', EVENT: '+'},
    "tcp2": {FROM_NODE: '7', TO_NODE: '4', EVENT: '+'},
}

def filterPackets(data, condition):
    result = []
    for line in data:
        items = line.split()
        conditionSatisfied = True
        for key, value in condition.items():
            if items[key] != value:
                conditionSatisfied = False
                break
        if conditionSatisfied:
            result.append(items)
    return result

def getTotalPacketsSize(connection):
    return sum([int(packets[PACKET_SIZE]) for packets in connection])

if len(sys.argv) < 3:
    print("Usage: python3 averageThroughput.py [TRACE FILE NAME] [CONNECTION NAME]")
elif sys.argv[2].lower() not in ["tcp0", "tcp1", "tcp2", "udp"]:
    print("Invalid connection name!")
else:
    fileName = sys.argv[1]
    try:
        with open(fileName, "r") as f:
            data = f.readlines()
        connectionName = sys.argv[2].lower()
        condition = CONDITIONS[connectionName]
        totalPacketSize = getTotalPacketsSize(filterPackets(data, condition))
        if connectionName.startswith("tcp"):
            ackCondition = ACK_CONDITIONS[connectionName]
            totalPacketSize += getTotalPacketsSize(filterPackets(data, ackCondition))
        duration = 10 if connectionName.startswith("tcp") else 1
        averageThroughput = totalPacketSize / duration
        print("Average throughput of", connectionName, "=", averageThroughput)
    except FileNotFoundError:
        print("File", sys.argv[1], "doesn't exist! Exited")