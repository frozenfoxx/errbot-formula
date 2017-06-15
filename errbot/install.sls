{% set basedir = salt['pillar.get']('errbot:basedir') %}
{% set locale = salt['pillar.get']('errbot:locale') %}

errbot-dir:
    file.directory:
        - name: {{ basedir }}
        - makedirs: true

errbot-dependencies:
    pkg.installed:
        - pkgs:
            - build-essential
            - libssl-dev
            - libffi-dev
            - python3
            - python3-pip
            - python3-dev

errbot-package:
    pip.installed:
        - name: errbot
        - requirements: salt://{{ sls_path }}/files/requirements.txt
        - bin_env: /usr/bin/pip3
        - env_vars:
            LC_ALL: {{ locale }}
        - require:
            - file: errbot-dir
            - pkg: errbot-dependencies

errbot-install:
    cmd.run:
        - name: errbot --init
        - cwd: {{ basedir }}
        - unless: test -f {{ basedir }}/config.py
        - require:
            - pip: errbot
