# $Id$
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'	       => 'HTTP::Size',
	'ABSTRACT'     => 'Get the byte size of an internet resource',
	'VERSION_FROM' => 'lib/Size.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',

	'PREREQ_PM'    => { 
		'HTTP::Request'         => '0',
		'URI'                   => '0',
		'HTML::SimpleLinkExtor' => '0',
		'LWP::Simple'           => '0',
		'LWP::UserAgent'        => '0',
		'URI::file'             => '0',
		},

	'PM'           => {
		'lib/Size.pm'         => '$(INST_LIBDIR)/Size.pm',
		},

	'MAN3PODS'     => {
		'lib/Size.pm' => '$(INST_MAN3DIR)/HTTP::Size.3',
		},

	clean  => { FILES    => q|*.bak HTTP-Size-*| },

	);
