use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WWW::Mailinator',
    VERSION_FROM      => 'lib/WWW/Mailinator.pm', # finds $VERSION
    PREREQ_PM         => { LWP::Simple => 0,
                           HTML::TableExtract => 0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/WWW/Mailinator.pm', # retrieve abstract from module
       AUTHOR         => 'M. Blom <b10m@perlmonk.org>') : ()),
);

