# Type: perl throughput.pl <trace file> <flow id> <required node> > <output trace file>
# ----------------------------------------------------------------------------------------
$infile=$ARGV[0];
$flow_id=$ARGV[1];
$tonode=$ARGV[2];

$start_time=0;
$end_time=0;
$throughput_kbit=0;

# To compute how many bytes of "flow id" were received at the "required node"
# during simulation time
# -----------------------------------------------------------------------------------------
$sum=0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
	@x = split(' ');
	#checking if the event corresponds to a reception
	if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
		$end_time = $x[1];
		$sum=$sum+$x[5];

		if ($start_time == 0) {
		    $start_time=$x[1];
				next;
		}

		$throughput_kbit=$sum/($end_time - $start_time)*8/1024;
		print STDOUT "$end_time $throughput_kbit\n";
	}
}
# -----------------------------------------------------------------------------------------
close DATA;
exit(0);
