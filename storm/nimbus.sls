include:
  - storm

start_nimbus:
  cmd:
    - run
    - name: 'bin/storm nimbus'
    - cwd: /usr/lib/storm

start_ui:
  cmd:
    - run
    - name: 'bin/storm ui'
    - cwd: /usr/lib/storm

