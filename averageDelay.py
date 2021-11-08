import sys

EVENT, TIME, FROM_NODE, TO_NODE, PACKET_TYPE, PACKET_SIZE = 0, 1, 2, 3, 4, 5
FLAGS, FID, SOURCE_ADDRESS, DST_ADDRESS, SEQ_NUM, PKT_ID = 6, 7, 8, 9, 10, 11
START_CONDITION = {
    "tcp0": {FROM_NODE: '0', TO_NODE: '3', EVENT: '+'},
    "tcp1": {FROM_NODE: '1', TO_NODE: '3', EVENT: '+', PACKET_TYPE: 'tcp'},
    "tcp2": {FROM_NODE: '2', TO_NODE: '3', EVENT: '+'},
    "udp": {FROM_NODE: '1', TO_NODE: '3', EVENT: '+', PACKET_TYPE: 'cbr'},
}
END_CONDITION = {
    "tcp0": {FROM_NODE: '4', TO_NODE: '5', EVENT: 'r'},
    "tcp1": {FROM_NODE: '4', TO_NODE: '6', EVENT: 'r', PACKET_TYPE: 'tcp'},
    "tcp2": {FROM_NODE: '4', TO_NODE: '7', EVENT: 'r'},
    "udp": {FROM_NODE: '4', TO_NODE: '6', EVENT: 'r', PACKET_TYPE: 'cbr'},
}
ACK_START_CONDITION = {
    "tcp0": {FROM_NODE: '5', TO_NODE: '4', EVENT: '+'},
    "tcp1": {FROM_NODE: '6', TO_NODE: '4', EVENT: '+'},
    "tcp2": {FROM_NODE: '7', TO_NODE: '4', EVENT: '+'},
}
ACK_END_CONDITION = {
    "tcp0": {FROM_NODE: '3', TO_NODE: '0', EVENT: 'r'},
    "tcp1": {FROM_NODE: '3', TO_NODE: '1', EVENT: 'r'},
    "tcp2": {FROM_NODE: '3', TO_NODE: '2', EVENT: 'r'},
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

def getDelayAndAmount(data, startCondition, endCondition):
    sentPackets = filterPackets(data, startCondition)
    startTime = {}
    for item in sentPackets:
        startTime[item[PKT_ID]] = float(item[TIME])
    receivedPackets = filterPackets(data, endCondition)
    totalDelay = 0
    for item in receivedPackets:
        totalDelay += float(item[TIME]) - startTime[item[PKT_ID]]
    return len(receivedPackets), totalDelay

if len(sys.argv) < 3:
    print("Usage: python3 averageDelay.py [TRACE FILE NAME] [CONNECTION NAME]")
elif sys.argv[2].lower() not in ["tcp0", "tcp1", "tcp2", "udp"]:
    print("Invalid connection name!")
else:
    fileName = sys.argv[1]
    try:
        with open(fileName, "r") as f:
            data = f.readlines()
        connectionName = sys.argv[2].lower()
        count, delay = getDelayAndAmount(data, START_CONDITION[connectionName], END_CONDITION[connectionName])
        if connectionName.startswith("tcp"):
            ackCount, ackDelay = getDelayAndAmount(data, ACK_START_CONDITION[connectionName], ACK_END_CONDITION[connectionName])
            count += ackCount
            delay += ackDelay
        averageDelay = delay / count
        print("Average packets delay of", connectionName, "=", averageDelay)
    except FileNotFoundError:
        print("File", sys.argv[1], "doesn't exist! Exited")