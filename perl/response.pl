#!F:/Dwimperl/perl/bin/perl.exe
package main;
use strict;
use POSIX qw(strftime);
use Paytm::PaytmConstants;
use Paytm::PaytmEncDec;
use vars qw($buffer @pairs %post_data $pair $name $value $key $checksumrec);
print "Content-type: text/html\r\n\r\n";
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
if ($post_data{'RESPCODE'} eq "01"){
	$checksumrec =  $post_data{'CHECKSUMHASH'}; 
	my $key =Paytm::PaytmConstants::MERCHANT_KEY;
	if(Paytm::PaytmEncDec::verifychecksum_e($key,$checksumrec,%post_data)){
  	print "<h2>Match</h2>";
  }else{
  	print "<h2>MisMatch</h2>";
  }
}else{
	print "<h2>MisMatch</h2>";
}
print "<br />";
foreach $key (sort keys %post_data){
	print  $key . ":  " . $post_data{$key} . "<br />";
}
 


1;