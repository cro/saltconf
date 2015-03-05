{% if salt['pkg.version']('apache2') %}
poodle apache server restart:
    service.running:
        - name: apache2
  {% for foundfile in salt['cmd.run']('rgrep -m 1 SSLProtocol /etc/apache*').split('\n') %}
    {% if 'No such file' not in foundfile and 'bak' not in foundfile and foundfile.strip() != ''%}
poodle {{ foundfile.split(':')[0] }}:
    file.replace:
        - name : {{ foundfile.split(':')[0] }}
        - pattern: "SSLProtocol all -SSLv2[ ]*$"
        - repl: "SSLProtocol all -SSLv2 -SSLv3"
        - backup: False
        - show_changes: True
        - watch_in:
            service: apache2
    {% endif %}
  {% endfor %}
{% endif %}

{% if salt['pkg.version']('nginx') %}
poodle nginx server restart:
    service.running:
        - name: nginx
  {% for foundfile in salt['cmd.run']('rgrep -m 1 ssl_protocols /etc/nginx/*').split('\n') %}
    {% if 'No such file' not in foundfile and 'bak' not in foundfile and foundfile.strip() != ''%}
poodle {{ foundfile.split(':')[0] }}:
    file.replace:
        - name : {{ foundfile.split(':')[0] }}
        - pattern: "ssl_protocols .*$"
        - repl: "ssl_protocols TLSv1 TLSv1.1 TLSv1.2;"
        - show_changes: True
        - watch_in:
            service: nginx
    {% endif %}
  {% endfor %}
{% endif %}

{% if salt['pkg.version']('postfix') %}
poodle postfix server restart:
    service.running:
        - name: postfix
poodle /etc/postfix/main.cf:
{% if 'main.cf' in salt['cmd.run']('grep smtpd_tls_mandatory_protocols /etc/postfix/main.cf') %}
    file.replace:
        - pattern: "smtpd_tls_mandatory_protocols=.*"
        - repl: "smtpd_tls_mandatory_protocols=!SSLv2,!SSLv3"
{% else %}
    file.append:
        - text: |
            # poodle fix
            smtpd_tls_mandatory_protocols=!SSLv2,!SSLv3
{% endif %}
        - name: /etc/postfix/main.cf
        - watch_in:
            service: postfix
{% endif %}

{% if salt['pkg.version']('chromium') %}
/usr/share/applications/chromium.desktop:
    file.replace:
        - pattern: Exec=/usr/bin/chromium %U
        - repl: Exec=/usr/bin/chromium --ssl-version-min=tls1 %U
{% endif %}

{% if salt['pkg.version']('iceweasel') %}
/etc/iceweasel/pref/poodle.js:
    file.managed:
        - text : pref("security.tls.version.min", "1")
{% endif %}
