;This is the simple now playing 'script' for MPC-HC
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
}

on *:sockopen:mpchc.np:{
  sockwrite -n $sockname GET /info.html HTTP/1.1
  sockwrite -n $sockname Host: $sock($sockname).ip
  sockwrite -n $sockname $crlf
}

on *:sockread:mpchc.np:{
  var %temptext
  sockread %temptext
  if (*<p id="mpchc_np">* iswm %temptext) {
    %temptext = $regsubex(%temptext, /^\s+/, $null)
    say $nohtml(%temptext)
  }
}