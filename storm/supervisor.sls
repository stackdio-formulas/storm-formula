include:
  - storm

start_supervisor:
  cmd:
    - run
    - name: 'bin/storm supervisor'
    - user: storm
    - group: storm
    - cwd: /usr/lib/storm
