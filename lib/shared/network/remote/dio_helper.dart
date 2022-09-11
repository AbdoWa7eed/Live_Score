

import 'package:dio/dio.dart';

class DioHelper
{
    static late Dio dio;

    static init()
    {
      dio = Dio(
        BaseOptions(
          baseUrl:'https://v3.football.api-sports.io/',
          headers: {
              'x-rapidapi-host' : 'v3.football.api-sports.io',
              'x-rapidapi-key' : '411455e80bf58bf7a205040f68508665'
          }
        )
      );
    }
    static Future<Response> getData({
    required String url,
     Map<String , dynamic>? query
  })
    {
       return dio.get(url, queryParameters: query);
    }
}