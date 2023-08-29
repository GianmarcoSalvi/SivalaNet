from rest_framework.pagination import PageNumberPagination


class CustomPagination(PageNumberPagination):
    page_size_query_param = 'page_size'

    def get_page_size(self, request):
        # Get the `page_size` query parameter from the request
        page_size = request.query_params.get('page_size')

        # Return the default page size if the `page_size` parameter is not provided or invalid
        if not page_size or not page_size.isdigit() or int(page_size) < 1:
            return self.page_size

        # Return the user-specified page size
        return int(page_size)


class GeoapifyStylePagination(PageNumberPagination):
    page_size_query_param = 'limit'
    page_query_param = 'offset'

    def get_page_size(self, request):
        # Get the `page_size` query parameter from the request
        page_size = request.query_params.get('limit')

        # Return the default page size if the `page_size` parameter is not provided or invalid
        if not page_size or not page_size.isdigit() or int(page_size) < 1:
            return self.page_size

        # Return the user-specified page size
        return int(page_size)
