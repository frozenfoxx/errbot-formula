{% from "errbot/defaults.yaml" import rawmap with context %}
{%- set errbot = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('errbot:lookup')) %}
{% set base_dir = salt['pillar.get']('errbot:base_dir') %}
{% set data_dir = salt['pillar.get']('errbot:data_dir') %}
{% set extra_plugin_dir = salt['pillar.get']('errbot:extra_plugin_dir') %}
{% set log_level = salt['pillar.get']('errbot:log_level') %}
{% set backend = salt['pillar.get']('errbot:backend') %}
{% set token = salt['pillar.get']('errbot:token') %}
{% set admins = salt['pillar.get']('errbot:admins') %}
{% set fullname = salt['pillar.get']('errbot:fullname') %}
{% set access_controls = salt['pillar.get']('errbot:access_controls') %}

errbot_config:
    file.managed:
        - name: {{ base_dir }}/config.py
        - source: salt://{{ sls_path }}/templates/config.py.j2
        - template: jinja
        - owner: {{ errbot.user }}
        - group: {{ errbot.group }}
        - mode: 0640
        - context:
            data_dir: {{ data_dir }}
            extra_plugin_dir: {{ extra_plugin_dir }}
            log_level: {{ log_level }}
            backend: {{ backend }}
            token: {{ token }}
            admins: {{ admins }}
            fullname: {{ fullname }}
        - require:
            - file: errbot_dir
            - pip: errbot_package
            - cmd: errbot_install

errbot_service_file:
    file.managed:
        - name: {{ errbot.service_file }}
        - source: salt://{{ sls_path }}/templates/errbot.service.j2
        - template: jinja
        - owner: root
        - group: root
        - mode: 0644
        - context:
            conf_file: {{ base_dir }}/config.py
            exec_file: {{ errbot.exec_file }}
            user: {{ errbot.user }}
        - require:
            - cmd: errbot_install
