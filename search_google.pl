#!/usr/bin/perl
#
use LWP::UserAgent;
use HTTP::Request;
use HTML::TreeBuilder;
use HTML::Element;
use URI::Escape;

my @this_is_it = qw /
  košík
  Obchodní
  podmínky
  legální
  objednávka
  účet
  nakupovat
  řád
  zboží
  Poštovné
  Slevy
  Obchod
  počet
  položek
  SKLADEM
  Balení
  czech
  česky
/;

#my $THIS_REG = '/' . join("|", @this_is_it) . '/';
#print $THIS_REG;

my $drug;

my $REGEXP = '^[a-zA-Z0-9,-]{1,100}$';

if ($ARGV[0] =~ /$REGEXP/) {
  $drug = $ARGV[0];
}
else {
  print STDERR "Invalid input";
  exit (0);
}

if ($ARGV[1]) {
  $drug .= ' ' . $ARGV[1] if ($ARGV[1] =~ /$REGEXP/);
}

if ($ARGV[2]) {
  $drug .= ' ' . $ARGV[2] if ($ARGV[2] =~ /$REGEXP/);
}

print "$drug\n";

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/8.0"); # pretend we are very capable browser

my $start=0;
my $i=0;
my $j=0;

for ($start=0; $start<=110; $start=$start+10) {
  print "$start\n";
  search();
}

sub search {
  my $req = HTTP::Request->new(GET => "https://www.google.com/search?q=$drug&start=$start");
  $req->header('Accept' => 'text/html');

  # send request
  $res = $ua->request($req);

  # check the outcome
  if ($res->is_success) {
  #   print $res->content;
  } else {
     print "Error: " . $res->status_line . "\n";
  }

  my $root = HTML::TreeBuilder->new_from_content($res->content);

  my @results = $root->find_by_attribute('id', 'ires')->find_by_attribute('class', 'r');

  foreach (@results) {
    my $link = uri_unescape(
      $_->find('a')->attr('href')
    );
    $link =~ s/^\/url\?q=(.*)\&sa=U.*$/\1/;

    next
      if ($link =~ /(wikipedia.org|wiktionary.org|youtube.com\/|\.onlineprodej.cz\/|inzerce\d\.cz\/|juklislab\.com\/)/) ||
        ($link =~ /^\/images/) ||
        ( $link =~ /^http(s)?\:\/\/(www\.facebook\.com\/|www\.topix\.com\/|juklislab\.com\/)/ ) ||
        ($link =~ /\.pdf$/);

    $i++;

    print "Fetching website: $link\n";

    $req = HTTP::Request->new(GET => $link);

    # send request
    $res = $ua->request($req);

    my $content;
    # check the outcome
    if ($res->is_success) {
      $content = $res->content;
    } else {
       print "Error: " . $res->status_line . "\n";
       next;
    }

    my $obchod=0;

    foreach (@this_is_it) {
      if ( $content =~ /$_/i ) {
        print "\npossible obchod: $link keyword: $_\n";
        $obchod = 1;
      }
    }

    if ($obchod == 1) {
      $j++;
    }
  }

  print "\nlinks: $i\nobchod: $j\n";
}

