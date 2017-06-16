{% from "errbot/defaults.yaml" import rawmap with context %}
{%- set errbot = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('errbot:lookup')) %}
{% set base_dir = salt['pillar.get']('errbot:base_dir') %}
{% set locale = salt['pillar.get']('errbot:locale') %}

errbot_dependencies:
    pkg.installed:
        - pkgs:
            - build-essential
            - libssl-dev
            - libffi-dev
            - python3
            - python3-pip
            - python3-dev

errbot_package:
    pip.installed:
        - name: errbot
        - requirements: salt://{{ sls_path }}/files/requirements.txt
        - bin_env: /usr/bin/pip3
        - env_vars:
            LC_ALL: {{ locale }}
        - require:
            - file: errbot_dir
            - pkg: errbot_dependencies

errbot_install:
    cmd.run:
        - name: errbot --init
        - cwd: {{ base_dir }}
        - runas: {{ errbot.user }}
        - unless: test -f {{ base_dir }}/config.py
        - require:
            - pip: errbot
