# $Id$

use Test::More tests => 1;

print "bail out! Could not compile HTTP::Size.\n"
	unless use_ok( 'HTTP::Size' );
