use utf8;
use Spreadsheet::WriteExcel;

use LWP::UserAgent;
use HTTP::Request;
use HTML::TreeBuilder;
use HTML::Element;
use URI::Escape;

use Encode qw(encode decode);
my $enc = 'utf-8';

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new('kratom8.xls');

# Add a worksheet
my $worksheet = $workbook->add_worksheet();

#  Add and define a format
my $format = $workbook->add_format(); # Add a format
$format->set_bold();

$worksheet->set_column(0, 22, 30);
$worksheet->set_row(0, 25);

# Write a formatted and unformatted string, row and column notation.
$worksheet->write(0, 0, 'Date of search', $format);
$worksheet->write(0, 1, 'Search engine used?', $format);
$worksheet->write(0, 2, 'Search string(s) used?', $format);
$worksheet->write(0, 3, 'URL', $format);
$worksheet->write(0, 4, 'Name of shop', $format);
$worksheet->write(0, 5, "Contact information\n(full address)", $format);
$worksheet->write(0, 6, "Contact information\n(country code)", $format);
$worksheet->write(0, 7, 'IP Address', $format);
$worksheet->write(0, 8, 'IP address country code', $format);
$worksheet->write(0, 9, "Web page popularity 1\n(Alexa Traffic Rank)", $format);
$worksheet->write(0, 10, "Web page popularity 2\n(websitetrafficspy.com)", $format);
$worksheet->write(0, 11, "Web page popularity 3\n(http://www.pageranking.org)", $format);
$worksheet->write(0, 12, "Web page popularity 4\n(http://www.checkpagerank.net)", $format);
$worksheet->write(0, 13, "Web page popularity 5\n(http://www.prchecker.info)", $format);
$worksheet->write(0, 14, 'Apparent country', $format);
$worksheet->write(0, 15, "Product info -\nProduct name", $format);
$worksheet->write(0, 16, "Product info -\nProduct chemical name", $format);
$worksheet->write(0, 17, "Product info -\nMinimum quantity for sale?", $format);
$worksheet->write(0, 18, "Product info -\nMaximum quantity for sale", $format);
$worksheet->write(0, 19, "Product info -\nPrice (for minimum quantity)", $format);
$worksheet->write(0, 20, "Product info -\nPrice (for maximum quantity)", $format);
$worksheet->write(0, 21, "Product info -\nQuantity measure (grams, litres, etc.)", $format);
$worksheet->write(0, 22, "Product info -\nprice currency (Kč, EUR, etc.)", $format);

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/8.0"); # pretend we are very capable browser

sub get_anchors {
  my ($url) = @_;
  my $req = HTTP::Request->new(GET => $url);
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

  return $root->find_by_attribute('class', 'wareCell');
}

my @results = (
  get_anchors('http://botanic.cz/smartshop/cs/kratom'),
  get_anchors('http://botanic.cz/smartshop/cs/kratom?page=2')
);


my $row = 1;
foreach (@results) {
  my $link = uri_unescape(
    $_->find('h2')->find('a')->attr('href')
  );

  print "$link\n";
  $req = HTTP::Request->new(GET => $link);

  # send request
  $res = $ua->request($req);

  # check the outcome
  if ($res->is_success) {
  } else {
     print "Error: " . $res->status_line . "\n";
     next;
  }

  my $page = HTML::TreeBuilder->new_from_content($res->content);

  my $name = decode($enc, $page->find_by_attribute('id', 'ctl07_wareDetailHeader')->as_trimmed_text());

  print "$name\n";

  $variants = $page->find_by_attribute('class', 'tblVariants');

  my @trs = $variants->find('tr');

  my $min_tr = $trs[2];
  my $max_tr = $trs[(scalar @pole-1)];

  my @min_tds = $min_tr->find('td');
  my @max_tds = $max_tr->find('td');

  my $min_g = $min_tds[0]->as_trimmed_text();
  my $min_price = $min_tds[3]->find_by_attribute('class', 'priceDigits')->as_trimmed_text();
  my $max_g = $max_tds[0]->as_trimmed_text();
  my $max_price = $max_tds[3]->find_by_attribute('class', 'priceDigits')->as_trimmed_text();

  print "$min_g\t$min_price\t$max_g\t$max_price\n";

  $min_g =~ s/g//g;
  $max_g =~ s/g//g;

  my $kus;

  if ($min_g =~ /kus/ ) {
    $kus = 'kus';

    $min_g = $max_g = 1;
  }

  print "$min_g\t$max_g\n";

  print "\n";

  $worksheet->set_row($row, 25);
  $worksheet->write($row, 0, '13/10/2012');
  $worksheet->write($row, 1, 'seznam.cz, metacrawler');
  $worksheet->write($row, 2, 'kratom');
  $worksheet->write($row, 3, 'http://botanic.cz');
  $worksheet->write($row, 4, 'Botanic.cz');
  $worksheet->write($row, 5, 'Walt International s.r.o.
Mírové náměstí 6, Jablonec nad Nisou 46601
');
  $worksheet->write($row, 6, 'CZ');
  $worksheet->write($row, 7, '81.2.209.223');
  $worksheet->write($row, 8, 'CZ');
  $worksheet->write($row, 9, '1,857,727');
  $worksheet->write($row, 10, '1,857,727');
  $worksheet->write($row, 11, '2');
  $worksheet->write($row, 12, '2/10');
  $worksheet->write($row, 13, '2/10');
  $worksheet->write($row, 14, 'Czech Republic');
  $worksheet->write($row, 15, $name);
  $worksheet->write($row, 16, $name);
  $worksheet->write($row, 17, $min_g);
  $worksheet->write($row, 18, $max_g);
  $worksheet->write($row, 19, $min_price);
  $worksheet->write($row, 20, $max_price);
  $worksheet->write($row, 21, $kus // 'grams');
  $worksheet->write($row, 22, 'Kč');

  $row++;
}

$workbook->close() or die "Error closing file: $!";
