{% from "errbot/defaults.yaml" import rawmap with context %}
{%- set errbot = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('errbot:lookup')) %}
{% set base_dir = salt['pillar.get']('errbot:basedir') %}

errbot_user:
  user.present:
    - name: {{ errbot.user }}
    - fullname: {{ errbot.user }}
    - shell: /bin/sh
    - home: {{ base_dir }}
    - groups:
        - {{ errbot.group }}
    - require:
        - group: errbot_group

errbot_group:
    group.present:
        - name: {{ errbot.group }}
        - system: True
