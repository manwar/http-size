# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile(
	'NAME'	       => 'HTTP::Size',
	'VERSION_FROM' => 'lib/Size.pm',
	'LICENSE'       => 'perl',

	'PREREQ_PM'    => { 
		'HTTP::Request'         => '0',
		'URI'                   => '0',
		'HTML::SimpleLinkExtor' => '0',
		},

	'PM'           => {
		'lib/Size.pm'         => '$(INST_LIBDIR)/Size.pm',
		},

	'MAN3PODS'     => {
		'lib/Size.pm' => '$(INST_MAN3DIR)/HTTP::Size.3',
		},

	'LICENSE'      => 'perl',
	
	clean  => { FILES    => q|*.bak HTTP-Size-*| },

	);
