# $Id$
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'	       => 'HTTP::Size',
	'VERSION_FROM' => 'lib/Size.pm',

	'PREREQ_PM'    => { 
		'HTTP::Request'         => '0',
		'URI'                   => '0',
		'HTML::SimpleLinkExtor' => '0',
		},

	'PM'           => {
		'lib/Size.pm'         => '$(INST_LIBDIR)/Size.pm',
		},
	);
