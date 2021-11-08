set ns [new Simulator]

$ns color 1 Red
$ns color 2 Brown
$ns color 3 Green
$ns color 4 Blue

set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open out.tr w]
$ns trace-all $tf

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf
	exec nam out.nam &
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
$ns duplex-link $s5 $s4 10Mb 5ms DropTail
$ns duplex-link $s7 $s4 10Mb 5ms DropTail
$ns duplex-link $s6 $s4 10Mb 5ms DropTail
$ns duplex-link $s3 $s4 1.5Mb 15ms DropTail

# 0.5 = 90, 1 = -180, 1.5 = -270, 2 = 0

# $ns queue-limit $n2 $n3 10

$ns duplex-link-op $s0 $s3 orient down
$ns duplex-link-op $s1 $s3 orient right
$ns duplex-link-op $s2 $s3 orient up
$ns duplex-link-op $s3 $s4 orient right
$ns duplex-link-op $s5 $s4 orient down
$ns duplex-link-op $s7 $s4 orient up
$ns duplex-link-op $s6 $s4 orient left

# $ns duplex-link-op $n2 $n3 queuePos 0.5

set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$tcp0 set window_ 32; # Default = 20 (pkts)
$ns attach-agent $s0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $s5 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1

set udp [new Agent/UDP]
$ns attach-agent $s1 $udp
set null [new Agent/Null]
$ns attach-agent $s6 $null
$ns connect $udp $null
$udp set fid_ 2

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$tcp1 set window_ 64
$ns attach-agent $s1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $s6 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 3

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$tcp2 set window_ 16
$ns attach-agent $s2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $s7 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 4

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

set cbr [new Application/Traffic/CBR]
$cbr set type_ CBR
$cbr set packetSize_ 1000
$cbr set rate_ 1.5mb
# $cbr set random_ false
$cbr attach-agent $udp

$ns at 0.4 "$ftp0 start"
$ns at 0.6 "$ftp1 start"
$ns at 0.8 "$ftp2 start"
$ns at 7.0 "$cbr start"
$ns at 8.0 "$cbr stop"
$ns at 10.4 "$ftp0 stop"
$ns at 10.6 "$ftp1 stop"
$ns at 10.8 "$ftp2 stop"
# $ns at 4.5 "$ns detach-agent $n0 $tcp0; $ns detach-agent $n3 $sink0" 
$ns at 11.0 "finish"

# puts "CBR packet size = [$cbr0 set packet_size_]"

$ns run
