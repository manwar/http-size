# $Id$
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'	       => 'HTTP::Size',
	'VERSION_FROM' => 'lib/Size.pm', # finds $VERSION
	'PREREQ_PM'    => { 
		'HTTP::Request' => undef,
		'URI'           => undef,
		},
	'PM'           => {
		'lib/Size.pm'         => '$(INST_LIBDIR)/Size.pm',
		},
	);
