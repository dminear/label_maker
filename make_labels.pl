#!/usr/bin/perl -w
# Make a PDF file from data to print out labels.
# Copyright (C) 2015  Daniel Minear
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#use DBI;
use PDF::API2;
#use encoding 'utf8';
use Data::Dumper;
use CGI;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

# "id	name	address	city	stateUs	zip	country",
# id	name	address	city	stateUs	zip	country
my @addresslist = (
"1	Mr. & Mrs. Parker	308 Cabaret 	El Paso	TX	79912	",
"2	Lippold Family	6211 Jean Dr	Huntington Beach	CA	92647	",
"3	Pauly Family	14266 Uxbridge St	Westminster	CA	92683	",
"4	Ron and Nancy Minear	8211 Lambert Dr	Huntington Beach	CA	92647	",
"5	Jacky Gegenworth	3836 Linden Avenue	Long Beach	CA	90807	",
"6	Griffith Family	8212 Lambert Drive	Huntington Beach	CA	92647	",
"7	Rush Family	5242 Bryant Circle	Westminster	CA	92683	",
"8	Dan & Gwen Stattner 	1802 E.Co.Rd.1000S.	Cloverdale	IN	46120	",
"9	The Chrisman Family	28452 SASSETTA WAY	PORTOLA HILLS	CA	92679	",
"10	Eric and Stacey Uglum	20770 Ottawa St	Hesperia	CA	92308	",
"11	Chris & Carrie Carbajal	21466 Kirkwall Ln	Lake Forest	CA	92630	",
"12	Monica & Steve Riccomini	251 Pinyon Hills Dr	Chico	CA	95928	",
"13	Theresa and Rob Culley	7329 Lakota Springs Dr	West Chester	OH	45069	",
"14	Samantha Minear	1861 San Francisco Ave #1	Long Beach	CA	90806	",
"15	Charles and Dawn Parker	75 Bryan Hill Rd	Milford	CT	06460	",
"16	Mary Shuster	3569 Ivy Hill Circle S.  Unit E	Coryland	OH	44410	",
"17	Aubertin Family	2621 Wildwood Ct	Langley	B.C.	V2Y 1E8	Canada",
"18	Brown Family	23207 N. 23rd Place	Phoenix	AZ	85024	",
"19	Bonanno Family	157 NW Apollo Rd.	Prineville	OR	97754	",
"20	Patsy Morris	Box 457	Joshua	TX	76058	",
"21	Diana Barber	15002 St. Cloud	Houston	TX	77062	",
"22	Montegani Family	7312 Judson Ave	Westminster	CA	92683	",
"23	Omori Family	27 Shea Ridge	Rancho Sta Marg	CA	92688	",
"24	Mary France & Robert Bowden	P.O. Box 2144	Crosby	TX	77532	",
"25	Margaret Minear	26250 Imperial Harbor Blvd.	Bonita Springs	FL	34135	",
"26	Jean Gordon	3102 105th St	Lubbock	TX	79423	",
"27	Bill & Deloras Elmore	6660 Henderson Creek	Casper	WY	82604	",
"28	Mr & Mrs Dennis	3111 River Place Dr	Belton	TX	76513	",
"29	Penny Parker	1603 Loving Trail	Belton	TX	76513	",
"30	Fran Slate	7713 Le Conte Dr.	El Paso	TX	79912	",
"31	Ann Silberman	3805 Duran Circle	Sacramento	CA	95821	",
"32	Mary Kaczmarski 	310 Regal Drive	Murfreesboro	TN	37129	",
"33	Edna Huelsenbeck	141 Orchard Rd	Orinda	CA	94563	",
"34	Chantel Rush	444 W Willis St Apt 201	Detroit	MI	48201	",
"35	Herbert Family	PO Box 8	Florence	OR	97439	",
"36	Dianne Cook 	14 Emmet St.	Marlboro	MA	01752	",
"37	Beck Schwers	23826 Verde River	San Antonio	TX	78255	",
"38	Ferne Black	Box 115	Pilot Point	TX	76258	",
"39	Jones Family	116 Stoneledge Pl NE	Leesburg	VA	20176	",
"40	McFarland Family	10478 Labrador Loop	Manassas	VA	20112	",
"41	Mike & Lisa Goeke 	101 Greenstone Dr.	St.Charles	MO	63303-1509	",
"42	Chris & Anissa Voss	2171 Hillcrest Dr.	Twin Falls	ID	83301	",
"43	Rezner Family	1448 N. Pine St.	Orange	CA	92867	",
"44	Scott & Dawn Griffith	3317 Robin Hill Ct. E	Columbus	OH	43223	",
"45	Mark & Cheryl Wahlgren	26 Strathmore Road	Methuen	MA	01844	",
"46	Tammy Moyer & Family	509 White St	Weissport	PA	18235	",
"47	Marilyn & Jaba Brennan 	9821 Nicole Road	Pineville	LA	71360	",
"48	Vicki Perez	915 W. Obispo Ave	Mesa	AZ	85210	",
"49	The Nguyen Family	17392 Encino Cir.	Huntington Beach	CA	92647	",
"50	Chilvers Family	6731 Lafayette Dr	Huntington Beach	CA	92647	",
"51	Garant Family	200 Manville Hill Rd. Apt 21	Cumberlander	RI	02864	",
"52	W H (Bill) Black	11509 FM 730 N	Azle	TX	76020	",
"53	Lavallee Family	14261 Uxbridge St	Westminster	CA	92683	",
"54	Giambone Family	19886 Waterview Lane	Huntington Beach	CA	92648	",
"55	Nunley Family	5521 Serene Dr	Huntington Beach	CA	92649	",
"56	Jennifer Layman	310 N Janss St.	Anaheim	CA	92805	",
"57	Baker Family	6451 Weber Circle	Huntington Beach	CA	92647	",
"58	Clarke Family	5392 Vanguard Ave	Garden Grove	CA	92845	",
"59	Day Family	8871 Cliffside Dr	Huntington Beach	CA	92646	",
"60	Pecoraro Family	9594 Pettswood Dr.	Huntington Beach	CA	92646	",
"61	Diehl Family	8395 Bluff Circle	Huntington Beach	CA	92646	",
"62	Rosenkranz Family	6921 Lawn Haven Dr.	Huntington Beach	CA	92648	",
"63	The Trani Family	6556 Morningside Dr	Huntington Beach	CA	92648	",
"64	Page Family	16331 Jody Circle	Westminster	CA	92683	",
"65	Romero Family	19105 Shoreline Lane #7	Huntington Beach	CA	92648	",
"66	Poletti Family	16091 Whitecap Ln	Huntington Beach	CA	92649	",
"67	Christiane Velez	10 Buckeye Dr	Old Bridge	NJ	08857-2906	",
"68	Souter Family	2419 Candlewood	Lakewood	CA	90712	",
"69	Ed and Jacky Myers	25241 Earhart Rd	Laguna Hills	CA	92653	",
"70	Lorthioir Family	16255 Tisbury Cir	Huntington Beach	CA	92649	",
"71	West Family	16291 Waikiki Ln	Huntington Beach	CA	92647	",
"72	Hicks Family	5672 Larkmont Dr.	Huntington Beach	CA	92649	",
"73	The Stravos Family	16832 Marina Bay Dr	Huntington Beach	CA	92649	",
"74	The McCray Family	6201 Camphor Ave	Westminster	CA	92683	",
"75	The Wong Family	16641 Wanderer Ln	Huntington Beach	CA	92649	",
"76	The Jones Family	16342 Niantic	Huntington Beach	CA	92649	",
"77	The Jones Family	19645 Meadowood Cir	Huntington Beach	CA	92648	",
"78	The Espinosa Family	5497 E. Appian Way	Long Beach	CA	90803	",
"79	The Bushey Family	6362 Heil Avenue	Huntington Beach	CA	92647	",
"80	The Hoppe Family	16311 Mandalay Cir	Huntington Beach	CA	92649	",
"81	The Kaess Family	6711 Shannon Dr	Huntington Beach	CA	92647	",
"82	The Tait Family	6251 Farinella Dr.	Huntington Beach	CA	92647	",
"83	The Karnowski Family	6131 Gumm Dr. 	Huntington Beach	CA	92647	",
"84	Wendl Family	17442 Suffolk Lane	Huntington Beach	CA	92649	",
"85	Shrum Family	5502 Wendy Cir	Huntington Beach	CA	92649	",
"86	Hayward Family	6202 Oakbrook Circle	Huntington Beach	CA	92648	",
"87	Kimmel Family	PSC 1005 Box 37	FPO	AE	09593-0001	",
"88	Denise Merhoff	8501 Lamar Dr.	Huntington Beach	CA	92647	",
"89	The Williams Family	17366 Elm Street	Fountain Valley	CA	92708	",
"90	Fronek Family	5081 Churchill Ave	Westminster	CA	92683	",
"91	Kris & Abby Koerkenmeier	4444 Paula Ave	Lskewood	CA	90713	",
"92	Duey Family	16581 Trudy Ln	Huntington Beach	CA	92647	",
"93	Nguyen Family	7011 Candlelight Circle	Huntington Beach	CA	92647	",
"94	Hoang Family	6151 Softwind Dr	huntington Beach	CA	92647	",
"95	Miller Family	17082 Twain Lane	Huntington BeachH	CA	92649	",
);


my $rows = [];

foreach my $i (@addresslist) {
	my @larry = split /\t/, $i;
	push @$rows, { "id" => $larry[0], 
			"name" => $larry[1],
			"address" => $larry[2],
			"city" => $larry[3],
			"stateUs" => $larry[4],
			"zip" => $larry[5],
			"country" => $larry[6],
			};
}
 
=comment
my $dbh = DBI->connect( 'DBI:mysql:christmas_labels', 'mychristmaslabel', 'gobackx') or die "Error: Could not connect to database: " . DBI ->errstr;

my $sth = $dbh->prepare( 'SELECT * FROM labels' ) or die "Could not prepare statement: " . $dbh->errstr;
# $sth->execute() or die "Could not execute statement: " . $sth->errstr;

# grab the whole thing into a ref array of hashes
if (@$rows == 0 ) {
	$rows = $dbh->selectall_arrayref( 'SELECT * FROM labels', { Slice => {} });
}
=cut

# figure out how many labels
my $numlabels = @$rows;
print "There are $numlabels labels to be printed.\n";

my $pdf = PDF::API2->new;
#my $fnt = $pdf->corefont('Helvetica-Bold');
my $fnt = $pdf->corefont('Helvetica',    -encoding => 'latin1');

# precalculate the point starts for the 30 labels
my $xoffset = 3/16/in + 12;		# right & left margins plus 12 points to shift text
my $yoffset = 0.5/in + 24;		# top & bottom margins plus 12 points to shift text down plus 12 because the anchor point is at the lower left of the text
my $xcolwidth = (2 + 5/8 + 1/8 )/in;	# 2 5/8 in plus a column gap of 1/8 in.
my $yrowheight = 1/in;			# each label right on top of other
my @label_position = ();
for (my $x = 0; $x < 3; $x++)
	{
	for (my $y = 0; $y < 10; $y++)
		{
		my $xpos = $xoffset + $x * $xcolwidth;
		my $ypos = 11/in - $yoffset - $y * $yrowheight;

		# now push the coords onto the array
		my $pos = {x => $xpos, y => $ypos };
		push @label_position,  $pos;
		}
	}

#print Dumper( @label_position );

my $page = $pdf->page;
$page->mediabox( 8.5/in, 11/in );
my $gfx = $page->gfx;

my $idx = 0;
my $ycharhgt = 14;		# should be 12, but 14 looks better with more space between lines

foreach my $label (@$rows)
	{
	$gfx->textlabel( $label_position[$idx]->{x}, $label_position[$idx]->{y}, $fnt, 12, $label->{name} );
	$gfx->textlabel( $label_position[$idx]->{x}, $label_position[$idx]->{y} - $ycharhgt, $fnt, 12, $label->{address} );
	$gfx->textlabel( $label_position[$idx]->{x}, $label_position[$idx]->{y} - 2 * $ycharhgt, $fnt, 12, $label->{city} . ", " . $label->{stateUs} . "  " . $label->{zip} ) if $label->{city} ne '';
	$gfx->textlabel( $label_position[$idx]->{x}, $label_position[$idx]->{y} - 3 * $ycharhgt, $fnt, 12, uc ($label->{country} || " ") );

	$idx++;

	if (! exists( $label_position[$idx] ))		# make a new page
		{
		$idx = 0;
		$page = $pdf->page;
		$page->mediabox( 8.5/in, 11/in );
		$gfx = $page->gfx;
		}
	}

$pdf->saveas('document.pdf');


#my $pdfdoc = $pdf->stringify;
$pdf->end;

my $q = new CGI;
print $q->redirect('document.pdf');
#print $q->header(-type=>'application/pdf');
#print "Content-type: application/pdf\n\n";
#print "Content-type: text/html\n\n";
#print "\n";
#print $q->start_html('lables');
#print $pdfdoc;
#print $q->p( "hello");
#print $q->end_html;

