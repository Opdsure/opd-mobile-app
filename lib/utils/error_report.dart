import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logs/logs.dart';

class ErrorReporter {
  final BuildContext context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  void onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    Logs().e(message ?? 'Error caught', error, stackTrace);
    final text = '$error\n${stackTrace ?? ''}';
    await showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const AppTextView(
          text:
              "😭 Oh no. Something went wrong. If you want, you can report this bug to the developers.",
        ),
        content: SizedBox(
          height: 256,
          width: 256,
          child: SingleChildScrollView(
            child: HighlightView(
              text,
              language: 'sh',
              theme: shadesOfPurpleTheme,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppTextView(
              text: 'Close',
            ),
          ),
          AppTextView(
            text: 'Copy',
            onClick: () => Clipboard.setData(
              ClipboardData(text: text),
            ),
          ),
          AppTextView(
            text: 'Report',
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
