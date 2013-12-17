include:
  - storm

start_supervisor:
  cmd:
    - run
    - name: 'bin/storm supervisor'
    - cwd: /usr/lib/storm
