use utf8;
use Spreadsheet::WriteExcel;
use Socket;
use Net::Whois::IP qw/whoisip_query/;

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new('34dmmc4.xls');

# Add a worksheet
my $worksheet = $workbook->add_worksheet();

#  Add and define a format
my $format = $workbook->add_format(); # Add a format
$format->set_bold();

$worksheet->set_column(0, 46, 31);
$worksheet->set_row(0, 72);
$worksheet->set_row(1, 30);
$worksheet->set_row(2, 40);

my $row = 1;
my $host = 'www.rc-chem.eu';
my $date = '31/10/2012';
my $search_engine = 'seznam.cz, metacrawler';
my $string = '3,4-dmmc';
my $website_url ='http://' . $host;
my $website_name = 'RC-CHEM.EU';
my $contact = '';
my $country = '';

my $webaddress = gethostbyname($host);
my $ip = inet_ntoa($webaddress);
my $ip_country = whoisip_query($ip,"",["Country"])->{country};
my $republic = ($ip_country eq 'CZ') ? 'Czech Republic' : 'XXX';

use Data::Dumper;
print Dumper $ip;
print Dumper $ip_country;
print Dumper $republic;

$worksheet->write($row, 0, $date);
$worksheet->write($row, 1, $search_engine);
$worksheet->write($row, 2, $string);
$worksheet->write($row, 3, $website_url);
$worksheet->write($row, 4, $website_name);
$worksheet->write($row, 9, $contact);
$worksheet->write($row, 10, $country);
$worksheet->write($row, 11, $ip);
$worksheet->write($row, 12, $ip_country);
$worksheet->write($row, 13, "10,941,371");
$worksheet->write($row, 14, "10,941,371");
$worksheet->write($row, 15, "0");
$worksheet->write($row, 16, "0/10");
$worksheet->write($row, 17, "0/10");
$worksheet->write($row, 18, $republic);
$worksheet->write($row, 26, "3,4-DMMC rekrystalizovaný");
$worksheet->write($row, 27, "1-(3,4-dimethylphenyl)-2-(methylamino)propan-1-one");
$worksheet->write($row, 30, "1");
$worksheet->write($row, 31, "100");
$worksheet->write($row, 32, "250");
$worksheet->write($row, 33, "8000");
$worksheet->write($row, 34, "grams");
$worksheet->write($row, 35, "Kč");

$row++;

$worksheet->write($row, 0, $date);
$worksheet->write($row, 1, $search_engine);
$worksheet->write($row, 2, $string);
$worksheet->write($row, 3, $website_url);
$worksheet->write($row, 4, $website_name);
$worksheet->write($row, 9, $contact);
$worksheet->write($row, 10, $country);
$worksheet->write($row, 11, $ip);
$worksheet->write($row, 12, $ip_country);
$worksheet->write($row, 13, "10,941,371");
$worksheet->write($row, 14, "10,941,371");
$worksheet->write($row, 15, "0");
$worksheet->write($row, 16, "0/10");
$worksheet->write($row, 17, "0/10");
$worksheet->write($row, 18, $republic);
$worksheet->write($row, 26, "3,4-DMMC pelety");
$worksheet->write($row, 27, "1-(3,4-dimethylphenyl)-2-(methylamino)propan-1-one");
$worksheet->write($row, 30, "3");
$worksheet->write($row, 31, "100");
$worksheet->write($row, 32, "300");
$worksheet->write($row, 33, "4100");
$worksheet->write($row, 34, "ks");
$worksheet->write($row, 35, "Kč");
$worksheet->write($row, 36, '1 peleta obsahuje:   400 mg 1-(3,4-dimethylphenyl)-2-(methylamino)propan-1-one');

$workbook->close() or die "Error closing file: $!";
