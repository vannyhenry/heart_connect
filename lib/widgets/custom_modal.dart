import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final bool show;
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String type; // 'info', 'error', 'confirm'

  const CustomModal({
    super.key,
    required this.show,
    required this.title,
    required this.message,
    this.onConfirm,
    this.onCancel,
    this.type = 'info',
  });

  /// Determines the header color based on the modal type.
  Color _getHeaderColor() {
    switch (type) {
      case 'error':
        return Colors.red.shade600;
      case 'confirm':
        return Colors.blue.shade600;
      default:
        return Colors.deepPurple.shade600;
    }
  }

  /// Determines the button color based on the modal type.
  Color _getButtonColor() {
    switch (type) {
      case 'error':
        return Colors.red.shade500;
      case 'confirm':
        return Colors.blue.shade500;
      default:
        return Colors.deepPurple.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    // Using a Stack and ModalBarrier to create a full-screen overlay dialog
    return Stack(
      children: [
        ModalBarrier(
          dismissible: false, // Prevents closing by tapping outside
          color: Colors.black.withOpacity(0.5),
        ),
        Center(
          child: Material(
            color: Colors.transparent, // Required for custom shaped dialogs
            child: Container(
              margin: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Make column only take necessary space
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _getHeaderColor(),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onCancel != null) // Show Cancel button only if onCancel callback is provided
                          TextButton(
                            onPressed: onCancel,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                            child: const Text('Cancel'),
                          ),
                        const SizedBox(width: 8),
                        if (onConfirm != null) // Show Confirm/OK button only if onConfirm callback is provided
                          ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getButtonColor(),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(type == 'confirm' ? 'Confirm' : 'OK'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}