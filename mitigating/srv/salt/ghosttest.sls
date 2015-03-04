# /srv/salt/ghosttest.sls

/tmp/ghost:
  file.managed:
{% if grains['osarch'] == 'i386' %}
    - source: salt://ghost32
{% else %}
    - source: salt://ghost
{% endif %}
    - owner: root
    - mode: '0700'

runghost:
  cmd.run:
    - name: /tmp/ghost
    - cwd: /tmp
    - user: root
    - require:
      - file: /tmp/ghost
