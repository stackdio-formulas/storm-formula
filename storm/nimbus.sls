include:
  - storm

start_nimbus:
  cmd:
    - run
    - name: 'bin/storm nimbus'
    - user: storm
    - group: storm
    - cwd: /usr/lib/storm

start_ui:
  cmd:
    - run
    - name: 'bin/storm ui'
    - user: storm
    - group: storm
    - cwd: /usr/lib/storm

