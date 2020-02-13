my $first=0;
my $firstSentence=0;
open(INPUT,"<:encoding(utf-8)",$ARGV[0]);
open(OUTPUT,">:encoding(utf-8)","TALISMANE-3208.xml");
print OUTPUT "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
print OUTPUT "<basetalismane>\n";
my $type="";
while (my $ligne=<INPUT>) {
	next if ($ligne=~/^$/);
	if ($ligne =~/^\#\# (titre|description) : (.+)$/) {
		$type=$1;
		my $file=$2;
		chomp($file);
		$file=~s/ +$//;
		if ($first != 0) {
			#print OUTPUT "</p>\n";
			print OUTPUT "</file>\n"
		}
		else {
			$first++;
		}
		print OUTPUT "<file type=\"$type\" name=\"$file\">\n";
		
	}
	if ($ligne=~/^([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)	([^\t]*)$/) {
		my $a1=$1;
		my $a2=$2;
		my $a3=$3;
		my $a4=$4;
		my $a5=$5;
		my $a6=$6;
		my $a7=$7;
		my $a8=$8;
		my $a9=$9;
		my $a10=$10;
		chomp($a1);chomp($a2);chomp($a3);chomp($a4);chomp($a5);chomp($a6);chomp($a7);chomp($a8);chomp($a9);chomp($a10);
		#print "<",$a2,">\n";
		if ($a2=~/debuttitre/) {
			print OUTPUT "<titre>\n";
			print OUTPUT "<p type=\"titre\">\n";
			$firstSentence=0;
		}
		elsif ($a2=~/fintitre/) {
			print OUTPUT "</p>\n";
			print OUTPUT "</titre>\n";
		}
		elsif ($a2=~/debutdescription/) {
			print OUTPUT "<description>\n";
			print OUTPUT "<p type=\"description\">\n";
			$firstSentence=0;
		}
		elsif ($a2=~/findescription/) {
			print OUTPUT "</p>\n";
			print OUTPUT "</description>\n";
		}
		else {
			$a1=~s/&/&amp;/g;
			$a2=~s/&/&amp;/g;
			$a3=~s/&/&amp;/g;
			$a4=~s/&/&amp;/g;
			$a5=~s/&/&amp;/g;
			$a6=~s/&/&amp;/g;
			$a7=~s/&/&amp;/g;
			$a8=~s/&/&amp;/g;
			$a9=~s/&/&amp;/g;
			$a10=~s/&/&amp;/g;
			if ($a1 == 1) {
				if ($firstSentence != 0) {
					print OUTPUT "</p>\n";
					print OUTPUT "<p type=\"description\">\n";
				}
				else {
					$firstSentence++;
				}
				#print OUTPUT "<p>\n";
			}
			print OUTPUT "<item><a>$a1</a><a>$a2</a><a>$a3</a><a>$a4</a><a>$a5</a><a>$a6</a><a>$a7</a><a>$a8</a><a>$a9</a><a>$a10</a></item>\n";
		}
	}
}
close(INPUT);
#print OUTPUT "</p>\n";
#print OUTPUT "</file>\n";
print OUTPUT "</basetalismane>\n";
close(OUTPUT);