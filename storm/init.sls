
{% set storm_install_path = '/usr/lib/storm-' + pillar.storm.version %}
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

jzmq_cleanup:
  cmd:
    - run
    - name: 'rm -rf /tmp/jzmq && mkdir /tmp/jzmq'
    - require:
      - pkg: storm_deps

jzmq_clone:
  cmd:
    - run
    - name: 'git clone https://github.com/nathanmarz/jzmq .'
    - unless: test -f /usr/local/lib/libjzmq.a
    - cwd: /tmp/jzmq
    - user: root
    - group: root
    - require:
      - cmd: jzmq_cleanup

jzmq_build:
  cmd:
    - run
    - name: 'export JAVA_HOME={{ java_home }} && ./autogen.sh && ./configure && make && make install'
    - unless: test -f /usr/local/lib/libjzmq.a
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
    - unless: test -d {{ storm_install_path }}
    - require:
      - user: storm
      - cmd: jzmq_build

storm_alternatives:
  alternatives:
    - install
    - name: storm
    - link: /usr/lib/storm
    - path: {{ storm_install_path }}
    - priority: 30
    - require:
      - cmd.run: storm_install

storm_permissions:
  file:
    - directory
    - name: {{ storm_install_path }}
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd: storm_install

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

{{ pillar.storm.local_dir }}:
  file:
    - directory
    - user: root
    - group: root
    - dir_mode: 755

storm_upstart:
  file:
    - recurse
    - name: /etc/init
    - source: salt://storm/etc/init
    - file_mode: 644
    - user: root
    - group: root
    - require:
      - file: storm_permissions
      - file: /etc/storm/conf
      - file: {{ pillar.storm.local_dir }}
