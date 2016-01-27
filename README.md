# Usage of CheckSum Utility:
## Kindly include the below mentioned packages:
 1. use POSIX qw(strftime);
 2. use Paytm::PaytmConstants;
 3. use Paytm::PaytmEncDec;

## Generate CheckSum API as well as Verify CheckSum API are available as follows:
 1. Subroutine to generate checksum:
    - sub getChecksumFromArray {    }
 2. Subroutine to verify checksum:
    - sub verifychecksum_e{      } 

## Use the following code snippet for Generating the CheckSum:
```sh
my $key =Paytm::PaytmConstants::MERCHANT_KEY; 
my %post_variables = (
            "MID" => Paytm::PaytmConstants::MERCHANT_ID,
            "ORDER_ID" => 1234,
            "CUST_ID" => 'ABCD123',
            "TXN_AMOUNT" => '10',
            "CHANNEL_ID" => Paytm::PaytmConstants::INDUSTRY_TYPE_ID,
            "INDUSTRY_TYPE_ID" => Paytm::PaytmConstants::INDUSTRY_TYPE_ID,
            "WEBSITE" => Paytm::PaytmConstants::WEBSITE
            );
             my $checksum=Paytm::PaytmEncDec::getChecksumFromArray($key,%post_variables);
```
## Use the following code snippet for Verifying the CheckSum:
```sh
my($buffer,@pairs,%post_data);
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST"){
  read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
}
@pairs = split(/&/,$buffer);


foreach $pair (@pairs){
	($name, $value) = split(/=/, $pair);
  $value =~ tr/+/ /;
  $value =~ s/%(..)/pack("C", hex($1))/eg;
	$post_data{$name} = $value;
}
$checksumrec =  $post_data{'CHECKSUMHASH'}; 
my $key =Paytm::PaytmConstants::MERCHANT_KEY;
if(Paytm::PaytmEncDec::verifychecksum_e($key,$checksumrec,%post_data)){
print "<h2>Match</h2>";
  }else{
  	print "<h2>MisMatch</h2>";
  }
//Verify all parameters received from Paytm pg to your application. Like MID received from paytm pg is same as your application’s MID, TXN_AMOUNT and ORDER_ID are same as what was sent by you to Paytm PG for initiating transaction etc.
$isValidChecksum = Paytm::PaytmEncDec::verifychecksum_e($key,$checksumrec,%post_data) // it will return 0 for checkmismatch  and 1 for checksum match.
```
