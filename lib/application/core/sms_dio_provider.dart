import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:seba_app1/application/core/api_path.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final smsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiPath.smsBaseUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    validateStatus: (statusCode) {
      if (statusCode == null) {
        return false;
      }
      return statusCode >= 200 && statusCode < 300;
    },
  ));
  dio.interceptors.addAll([
    if (kDebugMode)
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseData: true,
          printResponseMessage: true,
          printRequestData: true,
        ),
      ),
    DioCacheInterceptor(
        options: CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    ))
  ]);
  return dio;
});
