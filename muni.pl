#!/usr/bin/perl

use LWP::UserAgent;
use XML::Simple;
use Email::Simple;
use Email::Sender::Simple qw(sendmail);
use Getopt::Long;
use Data::Dumper;

my ($recip, $needed, $sid, $rt);
GetOptions ('recip=s' => \$recip,
	    'needed=i' => \$needed,
	    'sid=i' => \$sid,
	    'rt=s' => \$rt) || die 'not enough args';

my $ua = LWP::UserAgent->new;
my $res = $ua->get("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=".$sid."&routeTag=".$rt);
if ($res->is_success) {
  my $doc = XMLin($res->content, ForceArray => ['direction']);

  my $min = $doc->{predictions}->{direction}->[0]->{prediction}->[0]->{minutes};
  if ($needed >= $min) {
    my $email = Email::Simple->create(
				      header => [
						 From => 'rjsen@me.com',
						 To => $recip
						],
				      body => "The next $rt will be at stop $sid in $min minutes"
				     );
    eval {
      sendmail($email);
    };
    die "email failed: $@" if $@;
  }
} else {
  print "request failed: ".$res->status_line."\n";
}
