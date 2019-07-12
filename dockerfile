ARG TFS_VERSION=latest-gpu
FROM tensorflow/serving:${TFS_VERSION}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYTHONPATH=/app

RUN useradd -ms /bin/bash tfs

COPY docker /docker

RUN chmod +x /docker/install_python.sh
RUN /docker/install_python.sh

RUN python3.6 -m pip install --no-cache-dir --upgrade pip setuptools
RUN python3.6 -m pip install --no-cache-dir fastapi gunicorn uvicorn ujson

RUN mkdir -p /models/model
RUN chmod +x /docker/tfs/start_tfs.sh
RUN chmod +x /docker/uvicorn/start-reload.sh
RUN chmod +x /docker/uvicorn/start.sh
RUN chmod +x /docker/entrypoint.py

RUN chown -R tfs /usr/local/lib/python3.6/dist-packages
RUN chown -R tfs /usr/local/bin

COPY app /app

# Don't run as root.
USER tfs

ENTRYPOINT ["/docker/entrypoint.py"]
