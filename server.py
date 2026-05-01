#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Todoist-server : petit serveur HTTP local.

Écoute sur 127.0.0.1:PORT. À chaque requête GET, transmet la query-string
brute à handler.rb (sous-processus détaché) puis répond 204 No Content
(transparent côté navigateur).

Aucune dépendance : stdlib uniquement.
"""

import os
import signal
import subprocess
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse

HOST = "127.0.0.1"
PORT = 8000

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
HANDLER  = os.path.join(BASE_DIR, "handler.rb")
RUBY     = "/Users/philippeperret/.rbenv/versions/3.4.7/bin/ruby"

# Sur Unix, demander au noyau de récolter automatiquement les enfants
# zombies (on ne fait jamais wait() sur les sous-processus Ruby).
if hasattr(signal, "SIGCHLD"):
    signal.signal(signal.SIGCHLD, signal.SIG_IGN)


class TodoistHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        query = urlparse(self.path).query

        try:
            result = subprocess.run(
                [RUBY, HANDLER, query],
                cwd=BASE_DIR,
                stdin=subprocess.DEVNULL,
                capture_output=True,
                text=True,
                timeout=30,
            )
            output = (result.stdout + result.stderr).strip()
        except Exception as e:
            output = str(e)

        if output:
            # Si le output contient du HTML (peu importe ce qui précède),
            # extraire à partir de <!DOCTYPE ou <html.
            html_idx = output.find("<!DOCTYPE")
            if html_idx == -1:
                html_idx = output.lower().find("<html")
            if html_idx != -1:
                rendered = output[html_idx:]
                ctype    = "text/html; charset=utf-8"
            else:
                rendered = output
                ctype    = "text/plain; charset=utf-8"
            body = rendered.encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", ctype)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            self.send_response(204)
            self.end_headers()

    # Silence : pas de log d'accès sur stderr.
    def log_message(self, format, *args):
        return


def main():
    server = ThreadingHTTPServer((HOST, PORT), TodoistHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
