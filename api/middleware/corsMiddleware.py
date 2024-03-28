
class corsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        response["access-control-allow-origin"] = "*"
        response["access-control-allow-headers"] = "*"
        response["access-control-allow-methods"] = "*"
        return response
    
"""    
class corsMiddleware(object):
    def process_response(self, req, resp):
        resp["Access-Control-Allow-Origin"] = "*"
        return resp
"""