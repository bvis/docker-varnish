# It adds info if this has been cached or not
sub debug_backend_response
{
    if (bereq.http.X-Cache-Debug=="u0AJAlRWN4")
    {
        # Varnish determined the object was not cacheable
        if (beresp.ttl <= 0s) {
            set beresp.http.X-Cacheable = "NO:Not Cacheable";
        # You are respecting the Cache-Control=private header from the backend
        } elsif (beresp.http.Cache-Control ~ "private") {
            set beresp.http.X-Cacheable = "NO:Cache-Control=private";
        # Varnish determined the object was cacheable
        } else {
            set beresp.http.X-Cacheable = "YES";
        }

        set beresp.http.X-Cache-Backend-Name = beresp.backend.name;
        set beresp.http.X-Cache-Backend-Ip   = beresp.backend.ip;
    }
}
