import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class PickedCvFile {
  const PickedCvFile({
    required this.name,
    required this.bytes,
    this.declaredLength,
  });

  final String name;
  final Uint8List bytes;
  final int? declaredLength;
}

abstract interface class CvFilePickerService {
  Future<PickedCvFile?> pickPdf();
}

class DeviceCvFilePickerService implements CvFilePickerService {
  const DeviceCvFilePickerService();

  @override
  Future<PickedCvFile?> pickPdf() async {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (file == null) return null;

    final int? length = await file.length();
    final Uint8List bytes = await file.readAsBytes();

    return PickedCvFile(name: file.name, bytes: bytes, declaredLength: length);
  }
}
