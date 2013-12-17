include:
  - storm

storm-nimbus:
  service:
    - running
    - require:
      - file: storm_upstart

storm-ui:
  service:
    - running
    - require:
      - file: storm_upstart
