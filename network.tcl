set ns [new Simulator]
#
# Create a simple eight node topology:
#
#               s0             s5
#               |              |    
#       10Mb,5ms|              |10Mb,5ms
#               |              |   
#     10Mb,5ms  |  1.5Mb,15ms  |  10Mb,5ms
# s1------------r3 ------------s4--------------s6
#               | Q            |  
#       10Mb,5ms|              |10Mb,5ms  
#               |              |   
#               |              |
#	        s2             s7 
#
#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Pink

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Open the Trace file
set tf [open out.tr w]
$ns trace-all $tf

#Define a 'finish' procedure
proc finish {} {
        global ns nf tf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Close the Trace file
        close $tf
        #Execute NAM on the trace file
        #exec nam chapter5_sample1.nam &
        exit 0
}

set s0 [$ns node]
set s1 [$ns node]
set s2 [$ns node]
set s3 [$ns node]
set s4 [$ns node]
set s5 [$ns node]
set s6 [$ns node]
set s7 [$ns node]

$ns duplex-link $s0 $s3 10Mb 5ms DropTail 
$ns duplex-link $s1 $s3 10Mb 5ms DropTail 
$ns duplex-link $s2 $s3 10Mb 5ms DropTail
$ns duplex-link $s3 $s4 1.5Mb 15ms DropTail 
$ns duplex-link $s4 $s5 10Mb 5ms DropTail 
$ns duplex-link $s4 $s6 10Mb 5ms DropTail 
$ns duplex-link $s4 $s7 10Mb 5ms DropTail 

$ns duplex-link-op $s0 $s3 orient down
$ns duplex-link-op $s2 $s3 orient up
$ns duplex-link-op $s1 $s3 orient right
$ns duplex-link-op $s3 $s4 orient right
$ns duplex-link-op $s4 $s6 orient right
$ns duplex-link-op $s5 $s4 orient down
$ns duplex-link-op $s7 $s4 orient up

$ns queue-limit $s3 $s4 50
# $ns queue-limit $s4 $s3 50


$ns duplex-link-op $s3 $s4 queuePos 0.5

#Setup a TCP connection between TCP/Reno on node 0 to TCPSink on node 5
#set tcp0 [$ns create-connection TCP/Reno $s0 TCPSink $s5 0]
set tcp0 [$ns create-connection TCP/Reno $s0 TCPSink $s5 0]		;# fid_ := 0
$tcp0 set window_ 32
set ftp0 [$tcp0 attach-source FTP]
#$tcp0 set fid_ 0

set tcp1 [$ns create-connection TCP/Reno $s1 TCPSink $s6 1]	;# fid_ := 1
$tcp1 set window_ 64
set ftp1 [$tcp1 attach-source FTP]
#$tcp1 set fid_ 1

set tcp2 [$ns create-connection TCP/Reno $s2 TCPSink $s7 2]	;# fid_ := 2
$tcp2 set window_ 16
set ftp2 [$tcp2 attach-source FTP]
#$tcp2 set fid_ 2

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $s1 $udp
set null [new Agent/Null]
$ns attach-agent $s6 $null
$ns connect $udp $null
$udp set fid_ 3				;# fid_ := 3

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
#$cbr set packet_size_ 1000
$cbr set rate_ 1.5mb
$cbr set random_ false

$ns at 0.4 "$ftp0 start"
$ns at 0.6 "$ftp1 start"
$ns at 0.8 "$ftp2 start"
$ns at 7.0 "$cbr start"

$ns at 8.0 "$cbr stop"
$ns at 10.4 "$ftp0 stop"
$ns at 10.6 "$ftp1 stop"
$ns at 10.8 "$ftp2 stop"

$ns at 10.9 "finish"

$ns run
