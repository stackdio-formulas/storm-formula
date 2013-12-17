
{% set storm_prefix = pillar.storm.pkg.prefix + pillar.storm.version %}
{% set storm_user = pillar.storm.user }}
{% set storm_group = pillar.storm.group }}

# user/group
{{ storm_group }}:
  group:
    - present

{{ storm_user }}:
  user:
    - present
    - shell: /bin/bash
    - createhome: true
    - groups:
      - {{ storm_group }}
    - require:
      - group: {{ storm_group }}

# prep
{{ storm_prefix }}:
  file:
    - directory
    - clean: true
    - user: {{ storm_user }}
    - group: {{ storm_group }}
    - recurse:
      - user
      - group
    - require:
      - user: {{ storm_user }}
      - group: {{ storm_group }}

# download
/tmp/storm-{{ pillar.storm.version }}.tar.gz:
  file:
    - managed
    - source: {{ pillar.storm.pkg.url }}
    - source_hash: {{ pillar.storm.pkg.hash }}

# extract

# symlink

# conf
