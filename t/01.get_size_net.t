BEGIN { $| = 1; print "1..5\n"; }

END {print "not ok 1\n" unless $loaded;}

use HTTP::Size;
$loaded = 1;

print "ok 1\n";

package HTTP::Size;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
eval {
	my $size = HTTP::Size::get_size('foo');
	die "Thought 'foo' was a valid absolute URI\n"
		if defined $size;
	die "'foo' returned wrong error type [$ERROR]"
		 unless $ERROR == $INVALID_URL;

	$size = HTTP::Size::get_size();
	die "Thought [undef] was a valid absolute URI [$size]\n"
		if defined $size;
	die "undef returned wrong error type [$ERROR]"
		unless $ERROR == $INVALID_URL;
	};
print STDERR $@ if $@;
print $@ ? 'not ' : '', "ok\n";

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
require URI::file;
my $uri = URI::file->new_abs("t/test.html");

require LWP::Simple;
my $connected = LWP::Simple::get( 'http://www.yahoo.com' );

eval {
	my @array = (
		[ $uri->canonical,                           qw( 263 ) ],
		[ qw( http://www.pair.com/~comdog/for/http-size/title.png      5398 ) ],
		[ qw( http://www.pair.com/~comdog/for/http-size/size.txt         42 ) ],
		[ qw( ftp://ftp.cpan.org/pub/CPAN/ROADMAP.html  1604 ) ],
		);

	foreach my $element ( @array )
		{
		my $url       = $element->[0];
		my $true_size = $element->[1];

		my $size = HTTP::Size::get_size($url);

		die "\nI should be able to fetch [$url] [$ERROR] [$HTTP_STATUS]\n"
			unless defined $size && $size > 0;
		die "\n$url returned unexpected HTTP status [$HTTP_STATUS] expected [200]"
			unless $HTTP_STATUS == 200;
		die "\n$url returned wrong length [$size] expected [$true_size].\n" .
			"Maybe someone changed the resource and it has a new size.\n"
			unless $size == $true_size;

		unless( $connected )
			{
			print STDERR "\nSkipping some tests because I don't think I am connected\n";
			last;
			}
		}

	};
print STDERR $@ if $@;
print $@ ? 'not ' : '', "ok\n";

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
	# macOS returns 200 for www.example.net!
	my $url  = 'http://www.example.example.example.net';
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
