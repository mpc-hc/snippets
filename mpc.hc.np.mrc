;/**
;* mpc.hc.np.mrc, snippet to display now-playing info for MPC-HC
;* Released under the terms of MIT license
;*
;* https://github.com/mpc-hc/snippets
;*
;* Copyright (C) 2012-2013 MPC-HC Team
;*/

;In order to use it you need to enable web interface in options first
;Type /np to show info in active channel

alias nohtml {
  var %nohtml = $regsubex($regsubex($1,/<.+?>/g,),/&#(\d+);/g,$fixentities(\t))
  %nohtml = $replacecs(%nohtml,&laquo;,«,&raquo;,»,&bull;,•)
  return %nohtml
}

alias np {
  var %mpchc.host 127.0.0.1
  var %mpchc.port 13579
  .sockclose mpchc.np
  .sockopen mpchc.np %mpchc.host %mpchc.port
  .sockmark mpchc.np $active
}

on *:sockopen:mpchc.np:{
  sockwrite $sockname GET /info.html HTTP/1.1 $+ $crlf Host: $sock($sockname).ip $crlf $+ $crlf
}

on *:sockread:mpchc.np:{
  var %temptext
  sockread %temptext
  if (*<p id="mpchc_np">* iswm %temptext) {
    %temptext = $regsubex(%temptext, /^\s+/, $null)
    msg $sock($sockname).mark $nohtml(%temptext)
  }
}
