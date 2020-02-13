#/usr/bin/perl
#-----------------------------------------------------------
<<DOC; 
 Lara DUNUAN et Siyu WANG
 Project Encadré: Mai 2019
 usage : perl parcours-arborescence-fichiers repertoire-a-parcourir rubrique
 Le programme prend en entrée le nom du répertoire contenant les fichiers
 à traiter et le nom de la rubrique à traiter (via une suite de chiffres)
 Le programme construit en sortie 3 fichiers :
 - deux fichier TXT
 - un fichier structuré en XML 

DOC
#-----------------------------------------------------------
use utf8;
use open ':utf8';
binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");

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
open(OUT, ">:encoding(utf-8)", "sortie-$rubrique-regexp.txt");
open(OUTXML, ">:encoding(utf-8)", "sortie-$rubrique-regexp.xml");
open(TALI, ">:encoding(utf-8)", "sortie-$rubrique-regexp-talisman.txt");
print OUTXML "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print OUTXML "<racine>\n";

#----------------------------------------
#on recurse
&parcoursarborescencefichiers($rep);
#on ferme tout les fichiers outputs	
close OUT;
print OUTXML "</racine>\n";
close OUTXML;
close TALI;
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
				open(FIC, "<:encoding(utf-8)", $file);
				my $tout_le_texte="";
				while (my $ligne = <FIC>) {
					chomp $ligne;
					$tout_le_texte = $tout_le_texte . $ligne . " ";
				}
				close FIC;
				# créer une chaîne vide pour préparer la concaténation pour talisman
            	my $concat_talisman = "";

            	#on parcourt tout l'ensemble pour trouver les balises title et description et on mémorise leur contenu
				while ($tout_le_texte =~ /<item>.*?<title>([^<]*)<\/title>.*?<description>([^<]*)<\/description>.*?<\/item>/g) {
					my $titre = $1;
					my $description = $2;
					my $date = $file;
					$date =~ s/,1-0,0.xml/ /g;
					my ($titrenettoye,$descriptionnettoye) = &nettoyage($titre,$description);
					#pour traiter les doublons
					if (exists $doublons{$titrenettoye}) {
						$doublons{$titrenettoye}++;
					}
					else {

						$doublons{$titrenettoye}=1;
	                    my $titre_net_talis = $titrenettoye;
	                    my $description_net_talis = $descriptionnettoye;
	                    $titre_net_talis =~ s/([…\.\?\!]+)/$1\n/g;
	                    $description_net_talis =~ s/([…\.\?\!]+)/$1\n/g;
	                    $concat_talisman = $concat_talisman . "\n££debuttitre££\n" . $titre_net_talis . "\n££fintitre££\n££debutdescription££\n" . $description_net_talis . "\n££findescription££";
						# print OUT "DATE: $date\n";
						print OUT "## titre : $titrenettoye\n";
						print OUT "## description : $descriptionnettoye\n";
						print OUTXML "<date>$date</date>";
						print OUTXML "<item>\n";
	                    # traitement tree-tagger 
	                    # d'abord faire un wordlist avec un mot par ligne
	                    my ($titre_TT, $description_TT) = &etiq_treetagger($titrenettoye, $descriptionnettoye);
						print OUTXML "<titre>$titre_TT</titre>\n";
						print OUTXML "<description>$description_TT</description>\n";
						print OUTXML "</item>\n";
					}
				}
				my $etiq_Ta = &etiq_talisman($concat_talisman);
            	print TALI $etiq_Ta;
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

sub etiq_treetagger {
	
	#pour recupérer le premier element de la liste: $titrenettoye
	my $var = $_[0]; #my ($tit, $des) = @_;
	#pour recupérer le 2e element de la liste: $descriptionnettoye
	my $var1 = $_[1];

	#on ouvre le fichier temp.txt pour tous les $titrenettoye
	open(TMP, ">:encoding(utf-8)", "temp.txt");
	print TMP $var;
	close TMP;

	#on execute les programmes tokenise-utf8.pl et tree-tagger
	system("perl tokenise-utf8.pl -f temp.txt | ./tree-tagger -token -lemma -no-unknown french-utf8.par > temp_tag.txt");
	#on execute les programme treetagger2xml-utf8.pl
	system("perl treetagger2xml-utf8.pl temp_tag.txt utf8");

	#on ouvre le fichier temp_tag.txt.xml pour recupérer $titretagge
	local $/=undef;
	open(FIC1, "<:encoding(utf8)", "temp_tag.txt.xml");
	my $titretagge = <FIC1>;
	close FIC1;
	$titretagge =~ s/<\?xml.+?>//;

	#on ouvre le fichier temp.txt pour tous les $descriptionnettoye
	open(TMP, ">:encoding(utf-8)", "temp.txt");
	print TMP $var1;
	close TMP;

	#on execute les programmes tokenise-utf8.pl et tree-tagger
	system("perl tokenise-utf8.pl -f temp.txt | ./tree-tagger -token -lemma -no-unknown french-utf8.par > temp_tag.txt");
	#on execute les programme treetagger2xml-utf8.pl
	system("perl treetagger2xml-utf8.pl temp_tag.txt utf8");

	#on ouvre le fichier temp_tag.txt.xml pour recupérer $descriptiontagge
	open(FIC1, "<:encoding(utf8)", "temp_tag.txt.xml");
	my $descriptiontagge = <FIC1>;
	close FIC1;
	$descriptiontagge =~ s/<\?xml.+?>//;

	#on renvoie $titretagge, $descriptiontagge
	return $titretagge, $descriptiontagge;

}

sub etiq_talisman {
	#pour recupérer le premier element de la liste: $concat_talisman
    my $var = shift @_;

    #on ouvre le fichier bao1_test.txt pour contenir $concat_talisman
    open(TMP, ">:encoding(utf8)", "bao1_test.txt");
    print TMP $var;
    close TMP;

    #on execute les programmes pour talisman
    system("java -Xmx1G -Dconfig.file=../TALISMANE/TALISMANE-BAO2019-DISTRIB/talismane-fr-5.0.4.conf -jar ../TALISMANE/TALISMANE-BAO2019-DISTRIB/talismane-core-5.1.2.jar --analyse --sessionId=fr --encoding=UTF8 --inFile=bao1_test.txt --outFile=bao1_test.tal");
    local $/=undef; #eliminer la lecture ligne à ligne

    #on ouvre le fichier bao1_test.tal pour recupérer $fil_talis
    open(FIC1, "<:encoding(utf8)", "bao1_test.tal");
    my $fil_talis = <FIC1>;
    close FIC1;

    #on renvoie $fil_talis
    return $fil_talis;
}

#----------------------------------------------
