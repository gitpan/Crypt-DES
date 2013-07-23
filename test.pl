BEGIN { push @INC, qw(. .. ../lib ../../lib ../../../lib) }

#
# Extended testing is Copyright (C) 2000 W3Works, LLC
# All rights reserved.
#
#
# Copyright (C) 1995, 1996 Systemics Ltd (http://www.systemics.com/)
# All rights reserved.
#

package Crypt::DES;

require Exporter;
require DynaLoader;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

@ISA = (Exporter, DynaLoader);

# Items to export into callers namespace by default
@EXPORT =	qw();

# Other items we are prepared to export if requested
@EXPORT_OK =	qw();

$VERSION = '2.07';
bootstrap Crypt::DES;

use strict;
use Carp;

sub usage
{
    my ($package, $filename, $line, $subr) = caller(1);
	$Carp::CarpLevel = 2;
	croak "Usage: $subr(@_)"; 
}

sub blocksize { 8; }
sub keysize   { 8; }

sub new
{
	usage("new DES key") unless @_ == 2;
	my($type,$key) = @_;

	my $self = {}; 
	bless $self, $type;

	$self->{'ks'} = Crypt::DES::expand_key($key);

	return $self;
}

sub encrypt
{
	usage("encrypt data[8 bytes]") unless @_ == 2;

	my ($self,$data) = @_;
	return Crypt::DES::crypt($data, $data, $self->{'ks'}, 1);
}

sub decrypt
{
	usage("decrypt data[8 bytes]") unless @_ == 2;

	my ($self,$data) = @_;
	return Crypt::DES::crypt($data, $data, $self->{'ks'}, 0);
}




package main;

use Data::Dumper;
use Benchmark;

#
#	Adding the above tests into this program is
#	left as an exercise for the reader
#

#
#	Some test values...
#
#                KEY                 PLAINTEXT           CIPHERTEXT
my $testval = [
	       ['0101010101010101', '95f8a5e5dd31d900', '8000000000000000'],
	       ['0101010101010101', 'dd7f121ca5015619', '4000000000000000'],
	       ['0101010101010101', '2e8653104f3834ea', '2000000000000000'],
	       ['0101010101010101', '4bd388ff6cd81d4f', '1000000000000000'],
	       ['0101010101010101', '20b9e767b2fb1456', '0800000000000000'],
	       ['0101010101010101', '55579380d77138ef', '0400000000000000'],
	       ['0101010101010101', '6cc5defaaf04512f', '0200000000000000'],
	       ['0101010101010101', '0d9f279ba5d87260', '0100000000000000'],
	       ['0101010101010101', 'd9031b0271bd5a0a', '0080000000000000'],
	       ['0101010101010101', '424250b37c3dd951', '0040000000000000'],
	       ['0101010101010101', 'b8061b7ecd9a21e5', '0020000000000000'],
	       ['0101010101010101', 'f15d0f286b65bd28', '0010000000000000'],
	       ['0101010101010101', 'add0cc8d6e5deba1', '0008000000000000'],
	       ['0101010101010101', 'e6d5f82752ad63d1', '0004000000000000'],
	       ['0101010101010101', 'ecbfe3bd3f591a5e', '0002000000000000'],
	       ['0101010101010101', 'f356834379d165cd', '0001000000000000'],
	       ['0101010101010101', '2b9f982f20037fa9', '0000800000000000'],
	       ['0101010101010101', '889de068a16f0be6', '0000400000000000'],
	       ['0101010101010101', 'e19e275d846a1298', '0000200000000000'],
	       ['0101010101010101', '329a8ed523d71aec', '0000100000000000'],
	       ['0101010101010101', 'e7fce22557d23c97', '0000080000000000'],
	       ['0101010101010101', '12a9f5817ff2d65d', '0000040000000000'],
	       ['0101010101010101', 'a484c3ad38dc9c19', '0000020000000000'],
	       ['0101010101010101', 'fbe00a8a1ef8ad72', '0000010000000000'],
	       ['0101010101010101', '750d079407521363', '0000008000000000'],
	       ['0101010101010101', '64feed9c724c2faf', '0000004000000000'],
	       ['0101010101010101', 'f02b263b328e2b60', '0000002000000000'],
	       ['0101010101010101', '9d64555a9a10b852', '0000001000000000'],
	       ['0101010101010101', 'd106ff0bed5255d7', '0000000800000000'],
	       ['0101010101010101', 'e1652c6b138c64a5', '0000000400000000'],
	       ['0101010101010101', 'e428581186ec8f46', '0000000200000000'],
	       ['0101010101010101', 'aeb5f5ede22d1a36', '0000000100000000'],
	       ['0101010101010101', 'e943d7568aec0c5c', '0000000080000000'],
	       ['0101010101010101', 'df98c8276f54b04b', '0000000040000000'],
	       ['0101010101010101', 'b160e4680f6c696f', '0000000020000000'],
	       ['0101010101010101', 'fa0752b07d9c4ab8', '0000000010000000'],
	       ['0101010101010101', 'ca3a2b036dbc8502', '0000000008000000'],
	       ['0101010101010101', '5e0905517bb59bcf', '0000000004000000'],
	       ['0101010101010101', '814eeb3b91d90726', '0000000002000000'],
	       ['0101010101010101', '4d49db1532919c9f', '0000000001000000'],
	       ['0101010101010101', '25eb5fc3f8cf0621', '0000000000800000'],
	       ['0101010101010101', 'ab6a20c0620d1c6f', '0000000000400000'],
	       ['0101010101010101', '79e90dbc98f92cca', '0000000000200000'],
	       ['0101010101010101', '866ecedd8072bb0e', '0000000000100000'],
	       ['0101010101010101', '8b54536f2f3e64a8', '0000000000080000'],
	       ['0101010101010101', 'ea51d3975595b86b', '0000000000040000'],
	       ['0101010101010101', 'caffc6ac4542de31', '0000000000020000'],
	       ['0101010101010101', '8dd45a2ddf90796c', '0000000000010000'],
	       ['0101010101010101', '1029d55e880ec2d0', '0000000000008000'],
	       ['0101010101010101', '5d86cb23639dbea9', '0000000000004000'],
	       ['0101010101010101', '1d1ca853ae7c0c5f', '0000000000002000'],
	       ['0101010101010101', 'ce332329248f3228', '0000000000001000'],
	       ['0101010101010101', '8405d1abe24fb942', '0000000000000800'],
	       ['0101010101010101', 'e643d78090ca4207', '0000000000000400'],
	       ['0101010101010101', '48221b9937748a23', '0000000000000200'],
	       ['0101010101010101', 'dd7c0bbd61fafd54', '0000000000000100'],
	       ['0101010101010101', '2fbc291a570db5c4', '0000000000000080'],
	       ['0101010101010101', 'e07c30d7e4e26e12', '0000000000000040'],
	       ['0101010101010101', '0953e2258e8e90a1', '0000000000000020'],
	       ['0101010101010101', '5b711bc4ceebf2ee', '0000000000000010'],
	       ['0101010101010101', 'cc083f1e6d9e85f6', '0000000000000008'],
	       ['0101010101010101', 'd2fd8867d50d2dfe', '0000000000000004'],
	       ['0101010101010101', '06e7ea22ce92708f', '0000000000000002'],
	       ['0101010101010101', '166b40b44aba4bd6', '0000000000000001'],
	       ['8001010101010101', '0000000000000000', '95a8d72813daa94d'],
	       ['4001010101010101', '0000000000000000', '0eec1487dd8c26d5'],
	       ['2001010101010101', '0000000000000000', '7ad16ffb79c45926'],
	       ['1001010101010101', '0000000000000000', 'd3746294ca6a6cf3'],
	       ['0801010101010101', '0000000000000000', '809f5f873c1fd761'],
	       ['0401010101010101', '0000000000000000', 'c02faffec989d1fc'],
	       ['0201010101010101', '0000000000000000', '4615aa1d33e72f10'],
	       ['0180010101010101', '0000000000000000', '2055123350c00858'],
	       ['0140010101010101', '0000000000000000', 'df3b99d6577397c8'],
	       ['0120010101010101', '0000000000000000', '31fe17369b5288c9'],
	       ['0110010101010101', '0000000000000000', 'dfdd3cc64dae1642'],
	       ['0108010101010101', '0000000000000000', '178c83ce2b399d94'],
	       ['0104010101010101', '0000000000000000', '50f636324a9b7f80'],
	       ['0102010101010101', '0000000000000000', 'a8468ee3bc18f06d'],
	       ['0101800101010101', '0000000000000000', 'a2dc9e92fd3cde92'],
	       ['0101400101010101', '0000000000000000', 'cac09f797d031287'],
	       ['0101200101010101', '0000000000000000', '90ba680b22aeb525'],
	       ['0101100101010101', '0000000000000000', 'ce7a24f350e280b6'],
	       ['0101080101010101', '0000000000000000', '882bff0aa01a0b87'],
	       ['0101040101010101', '0000000000000000', '25610288924511c2'],
	       ['0101020101010101', '0000000000000000', 'c71516c29c75d170'],
	       ['0101018001010101', '0000000000000000', '5199c29a52c9f059'],
	       ['0101014001010101', '0000000000000000', 'c22f0a294a71f29f'],
	       ['0101012001010101', '0000000000000000', 'ee371483714c02ea'],
	       ['0101011001010101', '0000000000000000', 'a81fbd448f9e522f'],
	       ['0101010801010101', '0000000000000000', '4f644c92e192dfed'],
	       ['0101010401010101', '0000000000000000', '1afa9a66a6df92ae'],
	       ['0101010201010101', '0000000000000000', 'b3c1cc715cb879d8'],
	       ['0101010180010101', '0000000000000000', '19d032e64ab0bd8b'],
	       ['0101010140010101', '0000000000000000', '3cfaa7a7dc8720dc'],
	       ['0101010120010101', '0000000000000000', 'b7265f7f447ac6f3'],
	       ['0101010110010101', '0000000000000000', '9db73b3c0d163f54'],
	       ['0101010108010101', '0000000000000000', '8181b65babf4a975'],
	       ['0101010104010101', '0000000000000000', '93c9b64042eaa240'],
	       ['0101010102010101', '0000000000000000', '5570530829705592'],
	       ['0101010101800101', '0000000000000000', '8638809e878787a0'],
	       ['0101010101400101', '0000000000000000', '41b9a79af79ac208'],
	       ['0101010101200101', '0000000000000000', '7a9be42f2009a892'],
	       ['0101010101100101', '0000000000000000', '29038d56ba6d2745'],
	       ['0101010101080101', '0000000000000000', '5495c6abf1e5df51'],
	       ['0101010101040101', '0000000000000000', 'ae13dbd561488933'],
	       ['0101010101020101', '0000000000000000', '024d1ffa8904e389'],
	       ['0101010101018001', '0000000000000000', 'd1399712f99bf02e'],
	       ['0101010101014001', '0000000000000000', '14c1d7c1cffec79e'],
	       ['0101010101012001', '0000000000000000', '1de5279dae3bed6f'],
	       ['0101010101011001', '0000000000000000', 'e941a33f85501303'],
	       ['0101010101010801', '0000000000000000', 'da99dbbc9a03f379'],
	       ['0101010101010401', '0000000000000000', 'b7fc92f91d8e92e9'],
	       ['0101010101010201', '0000000000000000', 'ae8e5caa3ca04e85'],
	       ['0101010101010180', '0000000000000000', '9cc62df43b6eed74'],
	       ['0101010101010140', '0000000000000000', 'd863dbb5c59a91a0'],
	       ['0101010101010120', '0000000000000000', 'a1ab2190545b91d7'],
	       ['0101010101010110', '0000000000000000', '0875041e64c570f7'],
	       ['0101010101010108', '0000000000000000', '5a594528bebef1cc'],
	       ['0101010101010104', '0000000000000000', 'fcdb3291de21f0c0'],
	       ['0101010101010102', '0000000000000000', '869efd7f9f265a09'],
	       ['1046913489980131', '0000000000000000', '88d55e54f54c97b4'],
	       ['1007103489988020', '0000000000000000', '0c0cc00c83ea48fd'],
	       ['10071034c8980120', '0000000000000000', '83bc8ef3a6570183'],
	       ['1046103489988020', '0000000000000000', 'df725dcad94ea2e9'],
	       ['1086911519190101', '0000000000000000', 'e652b53b550be8b0'],
	       ['1086911519580101', '0000000000000000', 'af527120c485cbb0'],
	       ['5107b01519580101', '0000000000000000', '0f04ce393db926d5'],
	       ['1007b01519190101', '0000000000000000', 'c9f00ffc74079067'],
	       ['3107915498080101', '0000000000000000', '7cfd82a593252b4e'],
	       ['3107919498080101', '0000000000000000', 'cb49a2f9e91363e3'],
	       ['10079115b9080140', '0000000000000000', '00b588be70d23f56'],
	       ['3107911598090140', '0000000000000000', '406a9a6ab43399ae'],
	       ['1007d01589980101', '0000000000000000', '6cb773611dca9ada'],
	       ['9107911589980101', '0000000000000000', '67fd21c17dbb5d70'],
	       ['9107d01589190101', '0000000000000000', '9592cb4110430787'],
	       ['1007d01598980120', '0000000000000000', 'a6b7ff68a318ddd3'],
	       ['1007940498190101', '0000000000000000', '4d102196c914ca16'],
	       ['0107910491190401', '0000000000000000', '2dfa9f4573594965'],
	       ['0107910491190101', '0000000000000000', 'b46604816c0e0774'],
	       ['0107940491190401', '0000000000000000', '6e7e6221a4f34e87'],
	       ['19079210981a0101', '0000000000000000', 'aa85e74643233199'],
	       ['1007911998190801', '0000000000000000', '2e5a19db4d1962d6'],
	       ['10079119981a0801', '0000000000000000', '23a866a809d30894'],
	       ['1007921098190101', '0000000000000000', 'd812d961f017d320'],
	       ['100791159819010b', '0000000000000000', '055605816e58608f'],
	       ['1004801598190101', '0000000000000000', 'abd88e8b1b7716f1'],
	       ['1004801598190102', '0000000000000000', '537ac95be69da1e1'],
	       ['1004801598190108', '0000000000000000', 'aed0f6ae3c25cdd8'],
	       ['1002911598100104', '0000000000000000', 'b3e35a5ee53e7b8d'],
	       ['1002911598190104', '0000000000000000', '61c79c71921a2ef8'],
	       ['1002911598100201', '0000000000000000', 'e2f5728f0995013c'],
	       ['1002911698100101', '0000000000000000', '1aeac39a61f0a464'],
	       ['7ca110454a1a6e57', '01a1d6d039776742', '690f5b0d9a26939b'],
	       ['0131d9619dc1376e', '5cd54ca83def57da', '7a389d10354bd271'],
	       ['07a1133e4a0b2686', '0248d43806f67172', '868ebb51cab4599a'],
	       ['3849674c2602319e', '51454b582ddf440a', '7178876e01f19b2a'],
	       ['04b915ba43feb5b6', '42fd443059577fa2', 'af37fb421f8c4095'],
	       ['0113b970fd34f2ce', '059b5e0851cf143a', '86a560f10ec6d85b'],
	       ['0170f175468fb5e6', '0756d8e0774761d2', '0cd3da020021dc09'],
	       ['43297fad38e373fe', '762514b829bf486a', 'ea676b2cb7db2b7a'],
	       ['07a7137045da2a16', '3bdd119049372802', 'dfd64a815caf1a0f'],
	       ['04689104c2fd3b2f', '26955f6835af609a', '5c513c9c4886c088'],
	       ['37d06bb516cb7546', '164d5e404f275232', '0a2aeeae3ff4ab77'],
	       ['1f08260d1ac2465e', '6b056e18759f5cca', 'ef1bf03e5dfa575a'],
	       ['584023641aba6176', '004bd6ef09176062', '88bf0db6d70dee56'],
	       ['025816164629b007', '480d39006ee762f2', 'a1f9915541020b56'],
	       ['49793ebc79b3258f', '437540c8698f3cfa', '6fbf1cafcffd0556'],
	       ['4fb05e1515ab73a7', '072d43a077075292', '2f22e49bab7ca1ac'],
	       ['49e95d6d4ca229bf', '02fe55778117f12a', '5a6b612cc26cce4a'],
	       ['018310dc409b26d6', '1d9d5c5018f728c2', '5f4c038ed12b2e41'],
	       ['1c587f1c13924fef', '305532286d6f295a', '63fac0d034d9f793'],
	       ];

my $i = 1;
my $fail = 0;
my $tt = (scalar(@{$testval}) *2);
print "1..$tt\n";
my $t0 = new Benchmark;
foreach my $tst (@{$testval}) {
    my ($anot,$bnot) = (0,0);
    foreach(@{$tst}) { $_ = pack("H*",$_) }

    my $cipher = new Crypt::DES($tst->[0]);
    $anot = 1 unless ($cipher->encrypt($tst->[1]) eq $tst->[2]);
    if($anot) {
	#print "not ";
	$fail++;
    }
    $i++;

    $bnot = 1 unless ($cipher->decrypt($tst->[2]) eq $tst->[1]);
    if($bnot) {
	#print "not ";
	$fail++;
    }
;
    $i++;
}
my $t1 = new Benchmark;

my $suc = $tt - $fail;
my $fp = sprintf("%0.2f",(($tt / $suc) * 100)) unless $suc == 0;
if($suc == 0) { $fp = '0.00' }
my $td0 = timediff($t1,$t0);
my $ts0 = timestr($td0);
print "$tt basic tests ran in $ts0\n";
print "$suc of $tt tests passed ($fp\%)\n";
if($fail > 0) {
    print "Not all tests successful.  Please attempt to rebuild the package\n";
} else {
    print "\nRunning speed tests...\n";
    print "\nnon-cached cipher speed test.  5000 encrypt iterations\n";
    my $t2 = new Benchmark;
    for(1..5000) {
	my $cipher = new Crypt::DES(pack("H*",'1c587f1c13924fef'));
	$cipher->encrypt(pack("H*",'305532286d6f295a'));
    }
    my $t3 = new Benchmark;
    my $td1 = timediff($t3,$t2);
    my $ts1 = timestr($td1);
    print "$ts1\nok 343\n";

    print "\nnon-cached cipher speed test.  5000 decrypt iterations\n";
    my $t4 = new Benchmark;
    for(1..5000) {
        my $cipher = new Crypt::DES(pack("H*",'1c587f1c13924fef'));
        $cipher->decrypt(pack("H*",'63fac0d034d9f793'));
    }
    my $t5 = new Benchmark;
    my $td2 = timediff($t5,$t4);
    my $ts2 = timestr($td2);
    print "$ts2\nok 344\n";

    print "\ncached cipher speed test.  10000 encrypt iterations\n";
    {
    my $t6 = new Benchmark;
    my $cipher = new Crypt::DES(pack("H*",'1c587f1c13924fef'));
    for(1..10000) {
        $cipher->encrypt(pack("H*",'305532286d6f295a'));
    }
    my $t7 = new Benchmark;
    my $td3 = timediff($t7,$t6);
    my $ts3 = timestr($td3);
    print "$ts3\nok 345\n";
    }

    print "\ncached cipher speed test.  10000 decrypt iterations\n";
    {
    my $t8 = new Benchmark;
    my $cipher = new Crypt::DES(pack("H*",'1c587f1c13924fef'));
    for(1..10000) {
        $cipher->decrypt(pack("H*",'63fac0d034d9f793'));
    }
    my $t9 = new Benchmark;
    my $td4 = timediff($t9,$t8);
    my $ts4 = timestr($td4);
    print "$ts4\nok 346\n";
    }
}

print "\nTesting Cipher Block Chaining..\n";
eval 'use Crypt::CBC';

if(!$@) {
        if($Crypt::CBC::VERSION < 1.22) {
                $@ = "CBC mode requires Crypt::CBC version 1.22 or higher.";
        } else {

                my $cipher = new Crypt::CBC(pack("H*","0123456789ABCDEF"),"DES");
                my $ciphertext = $cipher->encrypt(pack("H*","37363534333231204E6F77206973207468652074696D6520666F722000"));
                my $plaintext  = $cipher->decrypt($ciphertext);

		if($plaintext ne "7654321 Now is the time for \0") { print "not "; }
                print "ok 347 - CBC Mode\n";
        }
} # end no errors

if($@) {
        print "Error (probably harmless):\n$@\n";
}

print "\nFinished with tests\n\n";
