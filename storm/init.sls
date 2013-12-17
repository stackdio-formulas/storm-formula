
{% set storm_prefix = '/usr/lib/storm-' + pillar.storm.version %}
{% set java_home = '/etc/alternatives/java_sdk_1.6.0' %}

# dependencies
storm_deps:
  pkg:
    - installed
    - pkgs:
      - zeromq
      - zeromq-devel
      - java-1.6.0-openjdk
      - java-1.6.0-openjdk-devel
      - unzip

jzmq_clone:
  cmd:
    - run
    - name: curl 'git clone https://github.com/nathanmarz/jzmq'
    - cwd: /tmp
    - user: root
    - group: root
    - require:
      - pkg: storm_deps

jzmq_build:
  cmd:
    - run
    - name: 'JAVA_HOME={{ java_home }} ./autogen.sh && ./configure && make && make install'
    - cwd: /tmp/jzmq
    - user: root
    - group: root
    - require:
      - cmd: jzmq_clone

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

