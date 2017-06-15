{% set basedir = salt['pillar.get']('errbot:basedir') %}
{% set extra_plugin_dir = salt['pillar.get']('errbot:extra_plugin_dir') %}
{% set log_level = salt['pillar.get']('errbot:log_level') %}
{% set backend = salt['pillar.get']('errbot:backend') %}
{% set token = salt['pillar.get']('errbot:token') %}
{% set admins = salt['pillar.get']('errbot:admins') %}
{% set fullname = salt['pillar.get']('errbot:fullname') %}

errbot-config:
    file.managed:
        - name: {{ basedir }}/config.py
        - source: salt://{{ sls_path }}/templates/config.py.j2
        - template: jinja
        - owner: root
        - group: root
        - mode: 0640
        - context:
            extra_plugin_dir: {{ extra_plugin_dir }}
            log_level: {{ log_level }}
            backend: {{ backend }}
            token: {{ token }}
            admins: {{ admins }}
            fullname: {{ fullname }}
        - require:
            - pip: errbot-package
