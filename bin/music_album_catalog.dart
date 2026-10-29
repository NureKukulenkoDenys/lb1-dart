import 'package:music_album_catalog/album_data.dart';
import 'package:music_album_catalog/album_parser.dart';

void main() {
  final result = loadAlbums(rawAlbumLines);
  print('ЛР №1 — каталог музичних альбомів.');
  print('Коректних альбомів: ${result.albums.length}.');
  print('Пошкоджених рядків: ${result.errors.length}.');
  for (final error in result.errors) {
    print('- $error');
  }
}
