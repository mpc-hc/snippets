#!/usr/bin/perl

#/**
#* mpc.hc.np.pl, snippet to display now-playing info for MPC-HC
#* Released under the terms of MIT license
#*
#* https://github.com/mpc-hc/snippets
#*
#* Copyright (C) 2012-2013 MPC-HC Team
#*/

use strict;
use warnings;
use Xchat qw( :all );
use LWP::UserAgent;

#############################################################################

my $version = "0.3";
Xchat::register("MPC-HC API", $version, "Displays MPC-HC Player Info!", "");
Xchat::print("Loaded - MPC-HC API - Use: /np :: Setup: Open MPC-HC -> Options -> Player -> Web Interface -> Listen on port");

#############################################################################

Xchat::hook_command("np", sub {
	my $browser	= LWP::UserAgent->new;					# Create a session
	my $url		= "http://localhost:13579/info.html";	# HTML file here
	$browser->timeout(3);								# How long to wait
	$browser->env_proxy;								# Proxy mode
	my $response = $browser->get($url);					# Get info

	# Report back if it's wrong
	if ( !$response->is_success ) {
		Xchat::command("echo - Could not get: $url . Open MPC-HC -> Options -> Player -> Web Interface -> Listen on port");
	}

	# Report back if it's right
	else {
		# Get results into variable
		my $content = $response->content;
		my @temptext = split("\n", $content);
		my $mpchcnp = $temptext[7];
		# Remove html, remove whitespace at beginning and end of string and replace entities.
		$mpchcnp =~ s/<[^>]*>//g;
		$mpchcnp =~ s/^\s+|\s+$//g;
		$mpchcnp =~ s/&laquo;/\xab/g;
		# Couldn't find proper way to replace it so I'm using plain hyphen as separator ;x
		$mpchcnp =~ s/&bull;/\x2D/g;
		$mpchcnp =~ s/&raquo;/\xbb/g;
		Xchat::command("say $mpchcnp");
	}
	return Xchat::EAT_ALL;
});

#############################################################################
