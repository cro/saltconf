ub01:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: ubuntu
        release: utopic
        arch: amd64

ub02:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: ubuntu
        release: utopic
        arch: amd64

ub03:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: ubuntu
        release: utopic
        arch: amd64

ct01:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: centos
        release: 6
        arch: amd64

ct02:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: centos
        release: 6
        arch: amd64

ct03:
  lxc.present:
    - running: True
    - template: download
    - options:
        dist: centos
        release: 6
        arch: amd64

ub03_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - args:
        - ub03
    - kwarg:
        master: 10.0.3.1
