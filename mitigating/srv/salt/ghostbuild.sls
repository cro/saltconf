/tmp/ghost.c:
  file.managed:
    - source: salt://ghost.c

gcc ghost.c -o ghost:
  cmd.run:
    - user: root
    - cwd: /tmp

# Note this will not work unless file_recv is 'True' in the salt-master config
cp.push:
  module.run:
    - path: /tmp/ghost

