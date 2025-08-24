// import 'package:flutter/material.dart';

// class CustomModalConfig {
//   final bool show;
//   final String title;
//   final String message;
//   final VoidCallback? onConfirm;
//   final VoidCallback? onCancel;
//   final String type;

//   CustomModalConfig({
//     this.show = false,
//     this.title = '',
//     this.message = '',
//     this.onConfirm,
//     this.onCancel,
//     this.type = 'info',
//   });
// }
import 'package:flutter/material.dart';

@immutable
class CustomModalConfig {
  final bool show;
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String type;

  const CustomModalConfig({
    this.show = false,
    this.title = '',
    this.message = '',
    this.onConfirm,
    this.onCancel,
    this.type = 'info',
  });

  CustomModalConfig copyWith({
    bool? show,
    String? title,
    String? message,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? type,
  }) {
    return CustomModalConfig(
      show: show ?? this.show,
      title: title ?? this.title,
      message: message ?? this.message,
      onConfirm: onConfirm ?? this.onConfirm,
      onCancel: onCancel ?? this.onCancel,
      type: type ?? this.type,
    );
  }
}