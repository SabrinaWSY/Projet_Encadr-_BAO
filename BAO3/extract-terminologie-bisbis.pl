#!/usr/bin/perl
<<DOC;
Format d\'entree : un texte étiqueté et lemmatisé par Talismane + un fichier de patrons syntaxiques avec un patron par ligne (ex: DET NC ADJ)
Format de sortie : un fichier avec pour chaque patron sa liste de termes triés par fréquence
DOC
use utf8;
use Time::HiRes qw(gettimeofday tv_interval);
my $timepg = [gettimeofday];

my $listePatron;
open my $fileTer,"<:encoding(UTF-8)",$ARGV[1];
while (my $patron=<$fileTer>) {
	chomp($patron);
    push(@{$listePatron},[split(/ +/,$patron)])
}
close($fileTer);

my %dicoPatron=();
my $nbTerme=0;
my @WORDS;
my @POS;	

open my $fileT,"<:encoding(UTF-8)",$ARGV[0];
while (my $ligne=<$fileT>) {
	if (($ligne!~/^1\t££/) and ($ligne!~/^\#\#/) and ($ligne!~/^$/)){
		my @TMPLIGNE=split(/\t/,$ligne);
		push(@WORDS,$TMPLIGNE[1]);
		push(@POS,$TMPLIGNE[3]);
	}
}
close($fileT);

my $lg=0;
while (my $pos=$POS[$lg]) {
	foreach my $patron (@{$listePatron}) {
		if ($pos eq $patron->[0] ) {
			my $indice=1;
			my $longueur=1;
			my $stop=1;
			while (($indice <= scalar @$patron) and ($stop == 1)) {
				if ($POS[$indice+$lg] eq $patron->[$indice]) {
					$longueur++;
					$indice++;
				}
				else {
					$stop=0;
				}
			}
			if ($longueur == scalar @$patron) {
				$dicoPatron{join(" ",@{$patron})}->{join(" ",@WORDS[$indice+$lg-scalar @$patron..$indice+$lg-1])}++;
				$nbTerme++;
			}
		}
	}
	$lg++;
}
open my $fileResu,">:encoding(UTF-8)","perlIsTheBigOneBis.txt";
print $fileResu "$nbTerme éléments trouvés\n";
foreach my $patron (keys %dicoPatron) {
	print $fileResu "\nType de pattern: ".$patron." \n\n";
	foreach my $terme (sort {$dicoPatron{$patron}->{$b} <=> $dicoPatron{$patron}->{$a} } keys %{$dicoPatron{$patron}}) {
		print $fileResu $dicoPatron{$patron}->{$terme}."\t".$terme."\n";
	}
}
print $fileResu "\nScript execution time: " . tv_interval($timepg) . " seconds.";
close($fileResu);
exit;
