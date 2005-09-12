package WWW::Mailinator;

=head1 NAME

WWW::Mailinator - Perl extension for grabbing messages from 
mailinator.net

=head1 DESCRIPTION

C<WWW::Mailinator> accesses 'your' mailinator.net mailbox and downloads 
the message(s).

=head1 SYNOPSIS

  use WWW::Mailinator;
  
  my $mailbox = WWW::Mailinator->new();
  $mailbox->login('b10m');
  
  if($mailbox->count) {
     foreach my $email ($mailbox->messages) {
        print $email->{from}.": ".$email->{subject}."\n";
        print $mailbox->retrieve($email->{num})."\n\n";
     }
  }

=head2 METHODS

=head3 new

C<new> creates a new C<WWW::Mailinator> object. It takes no options.

=head3 login

C<login> seems like a strange word for this action, for there is no
password needed. Yet in spite of a better name, here it is. The only  
thing required is a username of the mailbox you want to check.

After 'logging in', you can access the C<count>, C<messages>, and
C<retrieve> routines.

=head3 count

C<count> will return the amount of messages found for the user that logged in.

=head3 messages

C<messages> returns an array of all the messages found, except for the body
of the email. From, Subject, URL, and Num(ber) can be accessed. 

  $mailbox->login('dude');
  foreach my $email ($mailbox->messages) {
     printf("%03i <%s>: %s\n\t%s\n\n", $email->{num}, $email->{from},
                                       $email->{subject}, $email->{url});
  }

=head3 retrieve

C<retrieve> takes one argument, the mail number, and returns the corresponding
email.

=head1 SEE ALSO

LWP::Simple, HTML::TableExtract, http://www.mailinator.net/

=head1 AUTHOR

M. Blom, E<lt>b10m@perlmonk.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004,2005 by M. Blom

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
#------------------------------------------------------------------------------#
use strict;
use warnings;

our $VERSION = '0.04';

use Carp;
use LWP::Simple;
use HTML::TableExtract;

my $BASEURL = 'http://www.mailinator.com';

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class;

   return $self;
}

sub login {
   my ($self, $username) = @_;
   Carp::croak 'Username must be specified' if(!$username);
   $self->{username} = $username;
   if(my $content = get($BASEURL.'/mailinator/maildir.jsp?email='.$self->{username}) ) {
      my $te = new HTML::TableExtract( 
					headers => [qw(FROM SUBJECT)],
 					keep_html => 1
				     );
      $te->parse($content);
      foreach my $t ($te->tables) {
         foreach my $row ($t->rows) {
	    if(@$row[1]) {
               @$row[0] =~ s|^<b>(.*)</b>$|$1|; # Greedy, like we want ;)
               if(@$row[1] =~ m|^<a href=([^>]+)>(.+)</a>$|) {
                  push @{$self->{messages}}, { from    => @$row[0],
					       url     => $BASEURL.$1,
                                               subject => $2,
					       num     => $self->{count}
                                             };
		  $self->{count}++;
               }
            }
         }
      } 
   }
   else {
      Carp::croak "Couldn't fetch Mailinator page";
   }
}

sub count {
   my $self = shift;
   return $self->{count} || 0;
}

sub messages {
   my $self = shift;
   return @{$self->{messages}};
}

sub retrieve {
   my ($self, $mail) = @_;
   $mail ||= '0';
   if(my $content = get($self->{messages}->[$mail]->{url})) {
      my $te = new HTML::TableExtract(keep_html=>1);
      $te->parse($content);

      my $mail;
      if(my $table = $te->table(1,2)) {
         $mail = $table->cell(0,0);
         $mail =~ s/^.+?<br><br><br>//m;
      } 
      return $mail;
   }
   else {
      Carp::croak "Couldn't fetch Mailinator page";
   }
}

1;
__END__
