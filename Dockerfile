FROM python:2.7

COPY requirements.txt /tmp
RUN  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && pip install -r /tmp/requirements.txt 
WORKDIR /code
CMD mkdir -p /data && \
    python manage.py celery --loglevel=info --logfile=/data/celery.log --pidfile=/run/celery.pid --detach -P eventlet && \
    gunicorn -b 0.0.0.0:80 -k eventlet -w 1 --log-file=/data/gunicorn.log manage:app
