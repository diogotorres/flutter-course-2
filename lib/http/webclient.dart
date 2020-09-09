import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

const String baseUrl = 'http://172.17.0.1:8080/transactions';

final Client client = HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
