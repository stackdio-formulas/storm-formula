include:
  - storm

storm-nimbus:
  service:
    - running
    - require:
      - file: storm_upstart
    - watch:
      - file: /etc/storm/conf

storm-ui:
  service:
    - running
    - require:
      - file: storm_upstart
    - watch:
      - file: /etc/storm/conf

storm-logviewer:
  service:
    - running
    - require:
      - file: storm_upstart
    - watch:
      - file: /etc/storm/conf
