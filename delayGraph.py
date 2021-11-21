import matplotlib.pyplot as plt
import sys
EVENT, TIME, FROM_NODE, TO_NODE, PACKET_TYPE, PACKET_SIZE, FLAGS, FID, SOURCE_ADDRESS, DST_ADDRESS, SEQ_NUM, PKT_ID = [i for i in range(12)]
CONDITIONS = {
    "tcp0": [{EVENT: '+', FROM_NODE: '0'}, {EVENT: 'r', TO_NODE: '5'}],
    "tcp1": [{EVENT: '+', FROM_NODE: '1', PACKET_TYPE: 'tcp'}, {EVENT: 'r', TO_NODE: '6', PACKET_TYPE: 'tcp'}],
    "tcp2": [{EVENT: '+', FROM_NODE: '2'}, {EVENT: 'r', TO_NODE: '7'}],
    "udp": [{EVENT: '+', FROM_NODE: '1', PACKET_TYPE: 'cbr'}, {EVENT: 'r', TO_NODE: '6', PACKET_TYPE: 'cbr'}]
}

def conditionSatisfied(condition, arr):
    for key, value in condition.items():
        if arr[key] != value:
            return False
    return True

if len(sys.argv) != 3:
    print("USAGE: python3 delayGraph <trace file> <connection name (tcp0 | tcp1 | tcp2 | udp)>")
else:
    file_name, connection = sys.argv[1], sys.argv[2] 
    if connection.lower() not in ("tcp0", "tcp1", "tcp2", "udp"):
        print("Invalid connection name. Connection name must be (tcp0 | tcp1 | tcp2 | udp)")
    else:
        connection = connection.lower()
        try:
            with open(file_name, "r") as f:
                data = f.readlines()
        except FileNotFoundError:
            print("Trace file does not exist")
        output, delay, mean, jitter, count, sum, rtime = ["Seq | Send_t | Rec_t | Delay | Mean_Delay | Jitter"], [], [], [], 0, 0, []
        startTime = {}
        for line in data:
            item = line.strip().split()
            if conditionSatisfied(CONDITIONS[connection][0], item) and item[PKT_ID] not in startTime.keys():
                startTime[item[PKT_ID]] = item[TIME]
            if conditionSatisfied(CONDITIONS[connection][1], item):
                delay.append(float(item[TIME]) - float(startTime[item[PKT_ID]]))
                count += 1
                rtime.append(float(item[TIME]))
                sum += delay[-1]
                mean.append(sum / count)
                jitter.append(delay[-1] - mean[-1])
                output.append(" ".join([item[PKT_ID], startTime[item[PKT_ID]], item[TIME], str(delay[-1]), str(mean[-1]), str(jitter[-1])]))
        for line in output:
            print(line)
        fig, ax = plt.subplots(figsize=(24, 10), dpi=100)
        plt.title(connection + " connection, Delay, Mean-Delay and Jitter vs Simulation Time")
        plt.plot(rtime, delay, 'r+', label='Delay')
        plt.plot(rtime, mean, 'b+', label="Mean delay")
        plt.plot(rtime, jitter, 'go', label="Jitter")
        plt.xlabel('Time')
        plt.ylabel('Delay')
        plt.legend()
        plt.show()