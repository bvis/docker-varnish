
# The routine when we deliver the HTTP request to the user
# Last chance to modify headers that are sent to the client
sub vcl_deliver {

  if (req.http.Accept-Version-Recommended) {
    set resp.http.Accept-Version-Recommended = req.http.Accept-Version-Recommended;
  }

  if (req.http.Accept-Version) {
    set resp.http.Accept-Version = req.http.Accept-Version;
  }

  call debug_deliver;

  return (deliver);
}
