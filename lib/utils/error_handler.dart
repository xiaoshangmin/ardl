import 'package:flutter/material.dart';
import '../exceptions/app_exceptions.dart';

class ErrorHandler {
  static Future<T> handleFuture<T>({
    required Future<T> Function() future,
    required BuildContext context,
    String? defaultErrorMessage,
    Function(Exception)? onError,
  }) async {
    try {
      return await future();
    } on DownloadException catch (e) {
      _showErrorDialog(context, e.message);
      onError?.call(e);
      rethrow;
    } on NetworkException catch (e) {
      _showErrorDialog(context, e.message);
      onError?.call(e);
      rethrow;
    } on DatabaseException catch (e) {
      _showErrorDialog(context, e.message);
      onError?.call(e);
      rethrow;
    } catch (e) {
      _showErrorDialog(context, defaultErrorMessage ?? e.toString());
      onError?.call(e as Exception);
      rethrow;
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('提示'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'),
          ),
        ],
      ),
    );
  }
}
