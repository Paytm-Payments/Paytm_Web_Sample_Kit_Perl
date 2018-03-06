package Paytm::PaytmConstants;
use constant ENVIRONMENT    => 'T';
use constant MERCHANT_KEY    => 'kbzk1DSbJiV_O3p5';
use constant MERCHANT_ID    => 'WorldP64425807474247';
use constant INDUSTRY_TYPE_ID    => 'Retail';
use constant WEBSITE    => 'worldpressplg';
use constant CHANNEL_ID    => 'WEB';


if (ENVIRONMENT eq "P"){
	$paytm_pg_url = 'https://securegw.paytm.in/theia/processTransaction';
}else{
	$paytm_pg_url = 'https://securegw-stage.paytm.in/theia/processTransaction';
}


1;
