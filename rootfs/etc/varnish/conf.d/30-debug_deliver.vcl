#
# Adds extra output debug headers if the request contains the valid X-Cache-Debug header.
#
# For example:
#
# X-Urlsupported: true
# X-Backend-Name: prius
# X-Cache: MISS
# X-Cache-Backend-Sent-Cookie:  # (No cookies are sent to backend)
# X-Cache-Backend-Sent-Host: m.softonic.com.dev
# X-Cache-Backend-Sent-Url: /
# X-Cache-Hits: 0
# X-Cacheable: NO:Not Cacheable
# X-Served-By: prius.com.dev
# X-UA-Device: mobile-iphone
#
sub debug_deliver
{
    if (req.http.X-Cache-Debug=="u0AJAlRWN4") {
        if (obj.hits > 0) {
            set resp.http.X-Cache = "HIT";
        } else {
            set resp.http.X-Cache = "MISS";
        }

        # Relay previous varnish hits/misses.
        if( !resp.http.X-Served-By ) {
            set resp.http.X-Cache-Hits = obj.hits;
        }
        else {
            // append current data
            set resp.http.X-Cache-Hits = resp.http.X-Cache-Hits + ", " + obj.hits;
        }

        if( !resp.http.X-Served-By ) {
            # Send current hostname.
            set resp.http.X-Served-By = server.hostname;
        } else {
            # Relay previous server hostnames.
            set resp.http.X-Served-By = resp.http.X-Served-By + ", " + server.hostname;
        }

        # Per request debug data.
        set resp.http.X-Served-By-Ip              = server.ip;
        set resp.http.X-Cache-Backend-Sent-Cookie = req.http.Cookie;
        set resp.http.X-Cache-Backend-Sent-Host   = req.http.Host;
        set resp.http.X-Cache-Backend-Sent-Url    = req.url;
        set resp.http.X-Backend-Name              = req.backend_hint;
        set resp.http.X-Backend-Requested-Version = req.http.Accept-Version;
        set resp.http.X-Client-IP                 = req.http.X-Client-IP;
    } else {
      # Remove some headers: PHP version
      unset resp.http.X-Powered-By;

      # Remove some headers: Apache version & OS
      unset resp.http.Server;
      unset resp.http.X-Drupal-Cache;
      unset resp.http.X-Varnish;
      unset resp.http.Via;
      unset resp.http.Link;
      unset resp.http.X-Generator;
    }
}
