# $Id$
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'	       => 'HTTP::Size',
	'VERSION' => 0.3,
	'PREREQ_PM'    => { 
		'HTTP::Request' => undef,
		'URI'           => undef,
		'HTML::SimpleLinkExtor' => undef,
		},
	'PM'           => {
		'lib/Size.pm'         => '$(INST_LIBDIR)/Size.pm',
		},
	);
