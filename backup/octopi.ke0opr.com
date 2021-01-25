# Filename octopi.ke0opr.com.conf
# Redirect HTTP to HTTPS

server {
    if ($host = octopi.ke0opr.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    if ($host = octopi.ke0opr.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
        listen       80;
        listen       [::]:80;
        server_name  octopi.ke0opr.com;
        #root         /usr/share/nginx/html;
        #include snippets/letsencrypt.conf;
        return 301 https://$host$request_uri;
}


# plex Server Configuration
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name  octopi.ke0opr.com;
    ssl_certificate /etc/letsencrypt/live/www.ke0opr.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.ke0opr.com/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
    ssl_prefer_server_ciphers on;
	ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/www.ke0opr.com/chain.pem;
	# logging
	access_log /var/log/nginx/octopi.ke0opr.com.access.log;
	error_log /var/log/nginx/octopi.ke0opr.com.error.log warn;

 # octopi
 location / {
				#root /usr/share/nginx/html;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
				
                proxy_pass https://192.168.3.10; # centos IP Address
                proxy_ssl_verify off; # No need on isolated LAN
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
				
				#ADD A password so that people don't see this is an centos server
                #auth_basic "Restricted Content";
                #auth_basic_user_file /etc/nginx/passwd;

                proxy_buffering off;
                client_max_body_size 0;
                proxy_read_timeout 36000s;
                proxy_redirect off;
                proxy_ssl_session_reuse off;
	}
	
	location /webcam/ {		
		proxy_pass http://192.168.3.10:8080/;       
        proxy_buffering off;
	}
	
	error_page 404 /404.html;
		location = /usr/share/nginx/html/error_page/40x.html {
	}

	error_page 500 502 503 504 /50x.html;
		location = /usr/share/nginx/html/error_page/50x.html {
	}

}

