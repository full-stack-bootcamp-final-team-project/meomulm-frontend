import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

/**
 * Cloudinary 관련 api_service 페이지
 */

/*
이미지 업로드
 */
class CloudinaryUploader {
  final Dio _dio = Dio();

  final String cloudName = EnvConfig.cloudinaryCloudName;
  final String uploadPreset = EnvConfig.cloudinaryUploadPreset;

  Future<String> uploadImage(File file) async {
    // TODO: 디버깅 후 삭제
    print("클라우디너리 업로더 호출");
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    // TODO: 디버깅 후 삭제
    print("이미지 formData로 변환");
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
      'folder': 'user_profiles',
    });

    // TODO: 디버깅 후 삭제
    print("클라우디너리에 이미지 업로드 시작");
    final res = await _dio.post(url, data: formData);
    // TODO: 디버깅 후 삭제
    print("클라우디너리에 이미지 업로드 완료 - secure_url: ${res.data['secure_url']}");

    return res.data['secure_url'] as String;  // 저장된 이미지 경로
  }
}