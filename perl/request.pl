#!F:/Dwimperl/perl/bin/perl.exe
use strict;
use POSIX qw(strftime);
use Paytm::PaytmConstants;
use Paytm::PaytmEncDec;

print "Content-type: text/html\n\n";

my $key =Paytm::PaytmConstants::MERCHANT_KEY; 
my %post_variables = (
            "MID" => Paytm::PaytmConstants::MERCHANT_ID,
            "ORDER_ID" => int(rand(9999)),
            "CUST_ID" => 'Sanjay',
            "TXN_AMOUNT" => '10',
            "CHANNEL_ID" => Paytm::PaytmConstants::CHANNEL_ID,
            "INDUSTRY_TYPE_ID" => Paytm::PaytmConstants::INDUSTRY_TYPE_ID,
            "WEBSITE" => Paytm::PaytmConstants::WEBSITE
            );
						

my $checksum=Paytm::PaytmEncDec::getChecksumFromArray($key,%post_variables);

my $date= strftime "%Y-%m-%d %H:%M:%S", gmtime;
my $form=<<"EOL";
	
	<form action="$Paytm::PaytmConstants::paytm_pg_url" method="post" id="paytm_payment_form">
		<input type='hidden' name='MID' value="$post_variables{'MID'}"/>
		<input type='hidden' name='ORDER_ID' value="$post_variables{'ORDER_ID'}"/>
		<input type='hidden' name='WEBSITE' value="$post_variables{'WEBSITE'}"/>
		<input type='hidden' name='INDUSTRY_TYPE_ID' value="$post_variables{'INDUSTRY_TYPE_ID'}"/>
		<input type='hidden' name='CHANNEL_ID' value="$post_variables{'CHANNEL_ID'}"/>
		<input type='hidden' name='TXN_AMOUNT' value="$post_variables{'TXN_AMOUNT'}"/>
		<input type='hidden' name='CUST_ID' value="$post_variables{CUST_ID}"/>
		<input type='hidden' name='txnDate' value="$date" /> 
		<input type='hidden' name='CHECKSUMHASH' value="$checksum"/>		
		<input type='submit' name='submit' value="Confirm" />
	</form>
EOL
print $form;
