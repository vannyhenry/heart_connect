import 'package:flutter/material.dart';

class CustomModalConfig {
  final bool show;
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String type;

  CustomModalConfig({
    this.show = false,
    this.title = '',
    this.message = '',
    this.onConfirm,
    this.onCancel,
    this.type = 'info',
  });
}