BEGIN { print "1..1\n"; }

END { print "not ok\n" unless $loaded }

use HTTP::Size;

$loaded = 1;

print "ok\n";
