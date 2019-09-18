# docker-fail2ban

Fail2Ban for docker environment. This is compatible with docker web hosts.

For this, you should use action **docker-iptables-multiport** which works as iptables-multiport

Will allow for whitlisting IP's using environment variable "WHITELIST_IP".
Assign IP's as a comma separated string. 
See example below `docker-compose.yml`
```yaml
  fail2ban:
    environment:
      WHITELIST_IP: "192.0.2.0,255.255.255.0"
```
