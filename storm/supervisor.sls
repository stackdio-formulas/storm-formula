include:
  - storm

storm-supervisor:
  service:
    - running
    - require:
      - file: storm_upstart
    - watch:
      - file: /etc/storm/conf
