#$Id$

package HTTP::Size;
use strict;
use vars qw($INVALID_URL $ERROR $HTTP_STATUS);
use Test::More tests => 35;

use_ok( 'HTTP::Size' );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my $size = get_size('foo');
diag( "String 'foo' got back size [$size]" ) if defined $size;
ok( ! defined $size, "String 'foo' is not a valid absolute URI\n" );
is( $ERROR, $INVALID_URL, "get_size('foo') returned wrong error type" );

$size = get_size();
diag( "Empty string got back size [$size]" ) if defined $size;
ok( ! defined $size, "Empty string is not a valid absolute URI\n" );
is( $ERROR, $INVALID_URL, "get_size() returned wrong error type" );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

SKIP: {
require LWP::Simple;
my $connected = LWP::Simple::get( 'http://www.google.com' ) ||
	LWP::Simple::get( 'http://www.yahoo.com' );

skip "I can't continue unless I'm connected to the net", 10 unless $connected;

require URI::file;
my $uri = URI::file->new_abs("t/test.html");

my @array = (
	[ $uri->canonical,                                           qw( 263 21879 2) ],
	[ qw( http://www.panix.com/~comdog/for/http-size/title.png      5398  5398 1) ],
	[ qw( http://www.panix.com/~comdog/for/http-size/size.txt         42    42 1) ],
	[ qw( ftp://ftp.cpan.org/pub/CPAN/ROADMAP.html                  1604  1604 1) ],
	);
	
foreach my $element ( @array )
	{		
	my $url          = $element->[0];
	my $true_size    = $element->[1];
	my $true_total   = $element->[2];
	my $image_count  = $element->[3];

	my $size = get_size($url);

	ok( $size > 0, "Size is non-zero" );
	is( $HTTP_STATUS, 200, "HTTP response returned OK" );
	
	diag( "$url returned wrong length [$size] expected [$true_size].\n" .
		"Maybe someone changed the resource and it has a new size." ) 
		unless is( $size, $true_size, 
			"Message body for [$url] size is the right size" );		
		
	my( $total, $images ) = get_sizes( $url );
	$total ||= 0;
		
	diag( "[$url] returned wrong length",
		"Maybe someone changed the resource and it has a new size." )
		unless is( $total, $true_total, 
			"Total size for [$url] is right" );
	
	diag( "[$url] had the wrong number of images!" )
		unless is( $image_count, keys %$images, "Image count is right" );
				
	foreach my $key ( keys %$images )
		{
		diag( "I should be able to fetch [$url]", 
			"error: [$ERROR]", "HTTP status: [$HTTP_STATUS]" )
			unless ok( $images->{$key}{size} > 0, "Image size is not zero" );
		diag( "[$url] returned unexpected HTTP status" )
			unless is( $images->{$key}{HTTP_STATUS}, 200, "HTTP status is OK" );
		}

	}

}
__END__

eval {
	
	my @array = (
		[ $uri->canonical,                         qw( 21879 2 ) ],
		[ qw( http://www.panix.com/~comdog/for/http-size/size.txt 42 0 ) ],
		[ qw( ftp://ftp.cpan.org/pub/CPAN/ROADMAP.html  1604 1 ) ],
		);
		
	foreach my $element ( @array )
		{		
		my $url        = $element->[0];
		my $true_total = $element->[1];
		my $hash_keys  = $element->[2];
		
		my( $total, $hash ) = HTTP::Size::get_sizes($url);
		$total ||= 0;
		die "\n$url returned wrong length [$total] expected [$true_total].\n" .
			"Maybe someone changed the resource and it has a new size.\n"
			unless $total == $true_total;
		die "\n$url had the wrong number of images! [" . keys( %$hash ) . "]" .
			" Expected [ $hash_keys ]\n"
			unless $hash_keys == keys %$hash;
					
		foreach my $key ( keys %$hash )
			{
			die "\nI should be able to fetch [$url] [$ERROR] [$HTTP_STATUS]\n" 
				unless $hash->{$key}{size} > 0;
			die "\n$url returned unexpected HTTP status [$HTTP_STATUS] expected [200]"
				unless $hash->{$key}{HTTP_STATUS} == 200;
			}

		unless( $connected )
			{
			print STDERR "\nSkipping some tests because I don't think I am connected\n";
			last;
			}
		}

	};
print STDERR $@ if $@;
print $@ ? 'not ' : '', "ok\n";
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
eval {
	print STDERR "\nFetching bad sites now.  Go do something else for awhile!\n";
	my $url  = 'http://www.sri.net';
	my $size = HTTP::Size::get_size($url);
	die "$url returned unexpected HTTP status [$HTTP_STATUS] expected [500]"
		unless $HTTP_STATUS == 500;
	die "I should not be able to fetch [$url] [$size]\n" 
		if defined $size;
	die "[http://www.sri.net] returned wrong error [$ERROR]\n" 
		unless $ERROR == $COULD_NOT_FETCH;
	};
print STDERR $@ if $@;
print $@ ? 'not ' : '', "ok\n";
