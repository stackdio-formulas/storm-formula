
{% set storm_prefix = '/usr/lib/storm-' + pillar.storm.version %}

# dependencies
storm_deps:
  pkg:
    - installed
    - pkgs:
      - zeromq
      - zeromq-devel
      - java-1.6.0-openjdk
      - unzip

# user/group
storm_group:
  group:
    - present
    - name: storm

storm_user:
  user:
    - present
    - name: storm
    - shell: /bin/bash
    - createhome: true
    - groups:
      - storm
    - require:
      - group: storm_group

# download
storm_install:
  cmd:
    - run
    - name: curl '{{ pillar.storm.pkg_url }}' | tar xz
    - user: root
    - group: root
    - cwd: /usr/lib
    - unless: test -d {{ storm_prefix }}

storm_alternatives_link:
  alternatives:
    - install
    - name: storm
    - link: /usr/lib/storm
    - path: {{ storm_prefix }}
    - priority: 30
    - require:
      - cmd: storm_install

storm_permissions:
  file:
    - directory
    - name: {{ storm_prefix }}
    - user: root
    - group: root
    - recurse:
      - user
      - group

/etc/storm:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755

/etc/storm/conf:
  file:
    - recurse
    - source: salt://storm/conf
    - template: jinja
    - file_mode: 644
    - user: root
    - group: root

