;
; /var/named/db.example.com. - Zone file for example.com domain
;
$TTL 86400  ; 1 day
example.com.          IN  SOA ns.example.com. root.example.com. (
                          2003040101      ; Serial
                          10800           ; Refresh after 3 hours
                          3600            ; Retry after 1 hour
                          604800          ; Expire after 1 week
                          86400 )         ; Minimum TTL of 1 day

; name servers
example.com. IN NS ns1.example.com.

; host to address mappings
ose3-master.example.com.      IN  A   192.168.1.100
ns1.example.com.	      IN  A   192.168.1.50
*.ose.example.com.	      IN  A   192.168.1.100
