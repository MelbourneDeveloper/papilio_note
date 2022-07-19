abstract class FileIOBase {
  Future<void> writeText(String fileName, String text);

  Future<String?> readText(String fileName);

  Future<void> deleteFile(String fileName);
}
