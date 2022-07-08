abstract class FileIOBase {
  Future writeText(String fileName, String text);

  Future<String?> readText(String fileName);

  Future deleteFile(String fileName);
}
