X`import 'package:music_album_catalog/album_data.dart';
import 'package:music_album_catalog/album_parser.dart';
import 'package:music_album_catalog/album_statistics.dart';
import 'package:music_album_catalog/album_utils.dart';

void main() {
  final result = loadAlbums(rawAlbumLines);
  print('Каталог: ${result.albums.length} коректних альбомів.');
  print('Відхилено: ${result.errors.length} рядків.');
  print('Загальна тривалість: ${totalDuration(result.albums)} хв.');
  print('Лейбли: ${durationByLabel(result.albums)}');
  print('Сортування за роком: ${albumCaptions(sortByYear(result.albums)).take(3).join('; ')}');
  print('За кількістю треків: ${albumCaptions(sortByTrackCount(result.albums, ascending: false)).take(3).join('; ')}');
  final filtered = result.albums.where(releasedFromYear(2020));
  print('Випущено з 2020 року: ${filtered.length}.');
  final album = findAlbumByCode(result.albums, 'ALB-0001');
  if (album != null) {
    print('Приклад маскування: ${maskCatalogCode(album.catalogCode)}');
    print('Вік альбому: ${albumAgeInDays(album)} днів.');
  }
  for (final error in result.errors) {
    print('- $error');
  }
}
