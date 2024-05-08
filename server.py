from http.server import BaseHTTPRequestHandler, HTTPServer


class MyHandler(BaseHTTPRequestHandler):
    def do_get(self):
        if self.path == '/tkpythontemplate/':
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(bytes("<html><head></head><body>"
                                   "<p>tk python template root directory</p></body></html>", "utf-8"))

        elif self.path == '/tkpythontemplate/health':
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(bytes("<html><head></head><body>"
                                   "<p>tk python template health check</p></body></html>", "utf-8"))


print('starting server')

hostName = "0.0.0.0"
hostPort = 8081
myServer = HTTPServer((hostName, hostPort), MyHandler)

try:
    myServer.serve_forever()
except KeyboardInterrupt:
    pass

myServer.server_close()
print('server stopped')
