import 'package:music_album_catalog/album_data.dart';
import 'package:music_album_catalog/album_parser.dart';
import 'package:music_album_catalog/album_statistics.dart';

void main() {
  final result = loadAlbums(rawAlbumLines);
  print('Каталог: ${result.albums.length} коректних альбомів.');
  print('Відхилено: ${result.errors.length} рядків.');
  print('Починаючи з 2015 року: ${releasedSince(result.albums, 2015).length}.');
  print('Підписи: ${albumCaptions(result.albums).take(3).join(' | ')}');
  print('Загальна тривалість: ${totalDuration(result.albums)} хв.');
  print('Середня кількість треків: ${averageTrackCount(result.albums).toStringAsFixed(2)}.');
  print('Групи: ${groupByLabel(result.albums).keys.join(', ')}.');
  print('Час за лейблами: ${durationByLabel(result.albums)}.');
  for (final error in result.errors) {
    print('- $error');
  }
}
