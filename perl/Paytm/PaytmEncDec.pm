package Paytm::PaytmEncDec;
use Digest::SHA qw(sha256_hex);
use Crypt::CBC;
use MIME::Base64;



sub encrypt_e{
	my($input,$key) = @_;
  my $cipher = Crypt::CBC->new({
    'key'         => $key, # 256 bits
    'cipher'      => "Crypt::Rijndael",
    'iv'          => '@@@@&&&&####$$$$',
    'literal_key' => 1,
    'header'      => "none",
    'keysize'     => 16 
  });
   
  my $encrypted = $cipher->encrypt($input);  
  $encrypted = encode_base64($encrypted);
  chomp($encrypted);
	return $encrypted;
}

sub decrypt_e{
	my ($checksumvalue, $key)= @_;
	$checksumvalue = decode_base64($checksumvalue);
	my $cipher = Crypt::CBC->new({
    'key'         => $key, # 256 bits
    'cipher'      => "Crypt::Rijndael",
    'iv'          => '@@@@&&&&####$$$$',
    'literal_key' => 1,
    'header'      => "none",
    'keysize'     => 16 
  });
   
  my $decrypted = $cipher->decrypt($checksumvalue);    
  chomp($decrypted);
	return $decrypted;
}

sub generateSalt_e{
	my $random,$data;
	my $length = shift;
  
  
  $data = "AbcDE123IJKLMN67QRSTUVWXYZ";
  $data .= "aBCdefghijklmn123opq45rs67tuv89wxyz";
  $data .= "0FGH45OP89";
  
  for ($i = 0; $i < $length; $i++) {
      $random .= substr $data, (int(rand(999999)) % (length $data)), 1;
  }
  
  return $random;
}

sub checkString_e{
	my $value = shift;
  if ($value eq 'null'){
    $value = '';
	}
  return $value;
}

sub getChecksumFromArray{
	my $checksum,$str,$salt,$finalString,$hash,$hashString;	
	($key,%arrayList)= @_;
  
	$n = keys %arrayList;
	if ( $n> 0 ){		
		$str = getArray2Str(%arrayList);
		$salt= generateSalt_e(4);
		$finalString = $str . "|" . $salt;	
    $hash = sha256_hex($finalString);
		$hashString  = $hash . $salt;
    $checksum    = encrypt_e($hashString, $key);
	} 
	$checksum =~ s/[\n\r]//g;
	return $checksum;
}

sub getChecksumFromStr{
	my ($key, $str) = @_;
	$salt= generateSalt_e(4);
	$finalString = $str . "|" . $salt;	
    $hash = sha256_hex($finalString);
	$hashString  = $hash . $salt;
    $checksum    = encrypt_e($hashString, $key);
	
	return $checksum;
}

sub verifychecksum_e{
	my ($key, $checksumvalue,%arrayList) = @_;
	%arrayList = removeCheckSumParam(%arrayList);
	$str = getArray2Str(%arrayList);
	$paytm_hash = decrypt_e($checksumvalue, $key);
	$salt       = substr $paytm_hash, -4;
	$finalString = $str . "|" . $salt;
	$website_hash = sha256_hex($finalString);
	$website_hash .= $salt;
	
	if($website_hash eq $paytm_hash){
		return 1;
	}else{
		return 0;
	}
	
}

sub getArray2Str{
	my %arrayList = @_;
	my ($paramStr);
	my $flag     = 1;
	if ( (keys %arrayList) > 0){
		foreach $key (sort keys %arrayList){
			if($flag){
				$flag = 0;
				$paramStr .=  checkString_e($arrayList{$key});
			}else{
				$paramStr .= "|" . checkString_e($arrayList{$key});
			}			
		}
	}  
  return $paramStr;
}


sub removeCheckSumParam{
	my %arrayList = @_;
	if( exists( $arrayList{'CHECKSUMHASH'})){
	  delete $arrayList{'CHECKSUMHASH'};
	}
	return %arrayList;
}


1;
