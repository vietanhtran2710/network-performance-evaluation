# Type: perl throughput.pl <trace file> <flow id> <required node> <granularity> > <output trace file>
# ----------------------------------------------------------------------------------------
$infile = $ARGV[0];
$flow_id = $ARGV[1];
$tonode = $ARGV[2];
$granularity = $ARGV[3];

$time = 0;

# To compute how many bytes of "flow id" were received at the "required node"
# during simulation time
# -----------------------------------------------------------------------------------------
$sum = 0;
$exist = 0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
	@x = split(' ');
	if ($time == 0) {$time = $x[1];}
	if ($x[1]-$time <= $granularity) {
		#checking if the event corresponds to a reception
		if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
			$sum = $sum + $x[5];
			$exist = 1;
		}
	} else {
		$throughput_kbit = $sum/$granularity*8/1024;
		if ($exist == 1) {
			print STDOUT "$x[1] $throughput_kbit\n";
		}
		$time = $time+$granularity;
		$sum = 0;
	}
}
# -----------------------------------------------------------------------------------------
close DATA;
exit(0);
