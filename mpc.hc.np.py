# -*- coding: utf-8 -*-

#/**
#* mpc.hc.np.py, snippet to display now-playing info for MPC-HC
#* Released under the terms of MIT license
#*
#* https://github.com/mpc-hc/snippets
#*
#* Copyright (C) 2013 MPC-HC Team
#*/


__module_name__ = "MPC-HC NP snippet"
__module_version__ = "0.2"
__module_description__ = "Displays MPC-HC Player Info!"

import xchat
import urllib2
import re

###############################################################################
# Setup

MPC_HC_PORT = "13579"      # Default port
MPC_HC_PAGE = "info.html"  # Page where "now playing" info is displayed

###############################################################################

MPC_HC_URL = "http://{0}:{1}/{2}".format("localhost", MPC_HC_PORT, MPC_HC_PAGE)

MPC_HC_REGEXP = re.compile(r"\<p\ id\=\"mpchc_np\"\>(.*)\<\/p\>")


def mpc_hc(caller, callee, helper):
    try:
        data = urllib2.urlopen(MPC_HC_URL).read()
		mpc_hc_np = MPC_HC_REGEXP.findall(data)[0].replace("&laquo;", "«")
		mpc_hc_np = mpc_hc_np.replace("&raquo;", "»")
		mpc_hc_np = mpc_hc_np.replace("&bull;", "•")
    except:
        xchat.prnt("Error: MPC-HC not detected")
    else:
        xchat.command("say %s" % mpc_hc_np)
        return xchat.EAT_ALL

xchat.hook_command(
    "np",
    mpc_hc,
    help="Use: /np :: Setup: Options -> Player -> Web Interface -> Listen on port"
)
