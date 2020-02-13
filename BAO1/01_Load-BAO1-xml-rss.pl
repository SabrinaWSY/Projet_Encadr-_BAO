#/usr/bin/perl
#-----------------------------------------------------------
<<DOC; 
 Lara DUNUAN et Siyu WANG
 Project Encadré: Mai 2019
 usage : perl parcours-arborescence-fichiers repertoire-a-parcourir rubrique
 Le programme prend en entrée le nom du répertoire contenant les fichiers
 à traiter et le nom de la rubrique à traiter (via une suite de chiffres)
 Le programme construit en sortie 2 fichiers :
 - un fichier TXT
 - un fichier structuré en XML 
 Les 2 fichiers contiennent les zones textuelles extraites des fils RSS
DOC
#-----------------------------------------------------------
use XML::RSS;
use utf8;
use open ':utf8';
binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");
#-----------------------------------------------------------
#on récupère le nom du répertoire, fourni en argument au programme
my $rep="$ARGV[0]";
#on récupère le nom du  identifiant rubrique, fourni en argument au programme
my $rubrique="$ARGV[1]";
# on s'assure que le nom du répertoire ne se termine pas par un "/"
$rep=~ s/[\/]$//;
#compteur de $file
my $i=0;
#hashage pour traiter les doublons
my %doublons;
#on crée les fichiers outputs
open(OUT, ">:encoding(utf-8)", "sortie-$rubrique-xmlrss.txt");
open(OUTXML, ">:encoding(utf-8)", "sortie-$rubrique-xmlrss.xml");
print OUTXML "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print OUTXML "<racine>\n";

#----------------------------------------
#on recurse
&parcoursarborescencefichiers($rep);
#on ferme tout les fichiers outputs	
close OUT;
print OUTXML "</racine>\n";
close OUTXML;
exit;

#----------------------------------------------
sub parcoursarborescencefichiers {
	#on récupère le nom du répertoire fourni en arg de la fonction
    my $path = shift(@_);
    #on ouvre le répertoire fourni en arg
    opendir(DIR, $path) or die "can't open $path: $!\n";
    #on lit le répertoire grâce à readdir
    my @files = readdir(DIR);
    closedir(DIR);
    foreach my $file (@files) {
		next if $file =~ /^\.\.?$/;
		$file = $path."/".$file;
		#on teste s'il s'agit d'un répertoire
		if (-d $file) {
		    print "on entre dans $file \n";
			&parcoursarborescencefichiers($file);	#recurse!
		}
		#on teste s'il s'agit d'un fichier
		if (-f $file) {
		    if ($file=~/$rubrique.+\.xml$/) {			
				print $i++," : $file \n";
				my $rss=new XML::RSS;
				#traitement des fichiers XML
				eval {$rss->parsefile($file); };
				if( $@ ) {
					$@ =~ s/at \/.*?$//s;               # remove module line number
					print STDERR "\nERROR in '$file':\n$@\n";
				} 
				else {
					foreach my $item (@{$rss->{'items'}}) {
						my $description=$item->{'description'};
						my $titre=$item->{'title'};
						my $date = $file;
						$date =~ s/,1-0,0.xml/ /g;
						my ($titrenettoye,$descriptionnettoye) = &nettoyage($titre,$description);
						#pour traiter les doublons
						if (exists $doublons{$titrenettoye}) {
							$doublons{$titrenettoye}++;
						}
						else {
							$doublons{$titrenettoye}=1;
							print OUT "DATE: $date\n";
							print OUT "## $titrenettoye\n";
							print OUT "## $descriptionnettoye\n";
							print OUTXML "<article>\n";
							print OUTXML "<titre>$titrenettoye</titre>\n";
							print OUTXML "<description>$descriptionnettoye</description>\n";
							print OUTXML "</article>\n";
						}
					}
				}		
			}
		}
    }
}

#----------------------------------------------

sub nettoyage {

	my ($tit, $des) = @_;
	#my $t = shift @_; pour recupérer le premier element de la liste et le supprimer de la liste d'origine
	#my $d = shift @_; pour recupérer le 2eme
	$tit = $tit . "."; #$tit .= ".";
	$des = $des;
    
    $tit=~s/&lt;.+?&gt;//g;
	$tit=~s/&#38;#39;/'/g;
	$tit=~s/&#38;#34;/"/g;
	$tit=~s/&amp;/&/g;
	$tit=~s/ / /g;
	$tit=~s/ //g;

    $des=~s/&lt;.+?&gt;//g;#on veut supprimer les succession de balises transcodées $lt; &gt;	
	$des=~s/&#38;#39;/'/g;#on veut également remplacer les apostrophes transcodées &#38;#39;	
	$des=~s/&#38;#34;/"/g;#remplacement des guillemets doubles &#38;#34;
	$des=~s/&amp;/&/g;
	$des=~s/ / /g; #on remplace les espaces insécables par des espaces 'normaux'
	$des=~s/ //g;
    
	return $tit, $des;
}
#----------------------------------------------

