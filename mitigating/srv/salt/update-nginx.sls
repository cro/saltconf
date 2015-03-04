/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://files/nginx-default
