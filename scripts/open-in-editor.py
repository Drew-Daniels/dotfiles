from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from subprocess import call
from urllib.parse import parse_qs, urlparse


class OpenInEditor(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/open-in-editor"):
            query = parse_qs(urlparse(self.path).query)
            # [path], [line] = query["path"], query["line"]
            [path] = query["path"]
            # TODO: You might need to change this to construct the correct root directory for the
            # project that the file is in, so that your IDE opens in the project workspace.
            cwd = Path(path).parent
            # TODO: Replace with the appropriate command for your editor
            # call(["nvim", f"+{line} {path}"], cwd=cwd)
            call(["nvim", f"{path}"], cwd=cwd)
            self.send_response(200)
        else:
            self.send_response(404)
        self.end_headers()


print("Starting open-in-editor server on port 8000...")
HTTPServer(("", 8000), OpenInEditor).serve_forever()
