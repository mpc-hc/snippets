############ MPC-HC 0.3 - © 2012, vBm <vbm@omertabeyond.com> ###################
#!/usr/bin/perl

use strict;
use warnings;
use Xchat qw( :all );
use LWP::UserAgent;

#############################################################################

my $version = "0.3";
Xchat::register("MPC-HC API", $version, "Displays MPC-HC Player Info!","");
Xchat::print('Loaded - MPC-HC API - Use: /np :: Setup: Open MPC-HC > Options -> Player -> Web interface -> listen on port');

#############################################################################

Xchat::hook_command("np", "mpchc");

#############################################################################

sub mpchc {
	my $browser		= LWP::UserAgent->new;			# Create A session!
	my $url			= 'http://localhost:13579/info.html';	# HTML File Here!
	$browser->timeout(3);						# How Long to Wait!
	$browser->env_proxy;						# Proxy Mode!
	my $response = $browser->get($url);				# Get Info!

	#Report Back if its Wrong!
	if ( !$response->is_success ) {
		Xchat::command("echo - Could Not Get: $url . Open MPC-HC > Options -> Player -> Web interface -> listen on port");
	}

	#Report Back if its Right!
	else {
		# Get Results into Variable!
		my $content = $response->content;
		my @temptext = split("\n", $content);
		my $mpchcnp = $temptext[7];
		# Remove html, remove whitespace at beginning and end of string and replace entities.
		$mpchcnp =~ s/<[^>]*>//g;
		$mpchcnp =~ s/^\s+|\s+$//g;
		$mpchcnp =~ s/&laquo;/\xab/g;
		# Couldn't find proper way to replace it so i'm using plain hypen as separator ;x
		$mpchcnp =~ s/&bull;/\x2D/g;
		$mpchcnp =~ s/&raquo;/\xbb/g;
		Xchat::command("say $mpchcnp");
	}
	return Xchat::EAT_ALL;
}
#############################################################################