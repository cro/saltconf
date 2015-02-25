ub01_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ub01
    - kwargs:
        master: 10.0.3.1
ub02_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ub02
    - kwargs:
        master: 10.0.3.1
ub03_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ub03
    - kwargs:
        master: 10.0.3.1
ct01_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ct01
    - kwargs:
        master: 10.0.3.1
ct02_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ct02
    - kwargs:
        master: 10.0.3.1
ct03_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: ct03
    - kwargs:
        master: 10.0.3.1
