import 'package:music_album_catalog/album_data.dart';
import 'package:music_album_catalog/album_parser.dart';
import 'package:music_album_catalog/album_report.dart';

void main() {
  final result = loadAlbums(rawAlbumLines);
  print(buildReport(result.albums, errors: result.errors));
}
