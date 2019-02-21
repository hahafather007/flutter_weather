class ByteUtil {
  static String calculateSize(int byte) {
    if (byte < 1024) {
      return "$byte B";
    }

    final kb = byte ~/ 1024;
    if (kb < 1024) {
      return "$kb KB";
    }

    final mb = kb ~/ 1024;
    if (mb < 1024) {
      return "$mb MB";
    } else {
      return ">1 GB";
    }
  }
}
