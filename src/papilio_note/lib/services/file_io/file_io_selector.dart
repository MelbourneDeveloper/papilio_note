export 'file_io_stub.dart'
    if (dart.library.html) 'file_io_web.dart'
    if (dart.library.io) 'file_io.dart';
