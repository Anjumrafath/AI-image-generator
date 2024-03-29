import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:imagegenerator/errormsg.dart';
import 'package:imagegenerator/mainscreen.dart';

Future<dynamic> convertTextToImage(
  String prompt,
  BuildContext context,
) async {
  Uint8List imageData = Uint8List(0);

  const baseUrl = 'https://api.stability.ai';
  final url = Uri.parse(
      '$baseUrl/v1alpha/generation/stable-diffusion-512-v2-1/text-to-image');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer sk-pxM7PIvpqXcpLHPKD5k4DDycmOA4QHD316vMzefiBr2tkxEf',
      'Accept': 'image/png',
    },
    body: jsonEncode({
      "cfg_scale": 15,
      "clip_guidance_preset": "FAST_BLUE",
      "height": 512,
      "width": 512,
      "sampler": "K_DPM_2_ANCESTRAL",
      "samples": 1,
      "steps": 150,
      "seed": 0,
      "text_prompts": [
        {"text": prompt, "weight": 1}
      ]
    }),
  );

  if (response.statusCode == 200) {
    try {
      imageData = (response.bodyBytes);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(image: imageData),
          ));
      return response.bodyBytes;
    } on Exception {
      return showErrorDialog('Failed to generate image', context);
    }
  } else {
    return showErrorDialog('Failed to generate image', context);
  }
}
