#!/usr/bin/env python3

import logging
import multiprocessing
import os
import re
import signal
import subprocess
import sys

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


class ServiceManager(object):

    def __init__(self):
        self.status = 'initializing'

    def _start_tfs(self):
        cmd = '/docker/tfs/start_tfs.sh'
        log.info('tensorflow serving command: {}'.format(cmd))
        p = subprocess.Popen(cmd.split())
        log.info('started tensorflow serving (pid: %d)', p.pid)
        self._tfs = p


    def _start_api(self):
        if os.environ.get('RELOAD', False):
            cmd = '/docker/uvicorn/start-reload.sh'
        else:
            cmd = '/docker/uvicorn/start.sh'
        log.info('unicorn serving command: {}'.format(cmd))
        p = subprocess.Popen(cmd.split())
        log.info('started unicorn (pid: %d)', p.pid)
        self._api = p


    def start(self):

        signal.signal(signal.SIGTERM, self.graceful_stop)

        self._state = 'started'
        self._start_tfs()
        self._start_api()
        self._state = 'running'
        pid, status = os.wait()

        if self._state != 'stopping':
            log.info('Service crashed, shutting down.')
            self.stop()
            sys.exit(1)

        log.info('Exiting')
        sys.exit(0)


    def graceful_stop(self, sigid, stack):
        self._state = 'stopping'
        self.stop()


    def stop(self):
        self._state = 'stopping'
        log.info('stopping services')
        try:
            if self._tfs:
                os.kill(self._tfs.pid, signal.SIGTERM)
                self._tfs = False
        except OSError:
            pass
        try:
            if self._api:
                os.kill(self._api.pid, signal.SIGTERM)
                self._api = False
        except OSError:
            pass


if __name__ == '__main__':
    ServiceManager().start()
