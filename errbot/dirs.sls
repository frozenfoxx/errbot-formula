{% from "errbot/defaults.yaml" import rawmap with context %}
{%- set errbot = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('errbot:lookup')) %}
{% set base_dir = salt['pillar.get']('errbot:base_dir') %}
{% set data_dir = salt['pillar.get']('errbot:data_dir') %}

errbot_dir:
    file.directory:
        - name: {{ base_dir }}
        - makedirs: True
        - user: {{ errbot.user }}
        - group: {{ errbot.group }}
        - require:
            - user: errbot_user
            - group: errbot_group

errbot_data_dir:
    file.directory:
        - name: {{ data_dir }}
        - makedirs: True
        - user: {{ errbot.user }}
        - group: {{ errbot.group }}
        - require:
            - user: errbot_user
            - group: errbot_group
