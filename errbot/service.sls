errbot_service:
    service.running:
        - name: "errbot"
        - enable: True
        - reload: True
        - require:
            - file: errbot_service_file
