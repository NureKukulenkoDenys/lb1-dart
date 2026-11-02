import 'package:music_album_catalog/album.dart';
import 'package:music_album_catalog/album_data.dart';
import 'package:music_album_catalog/album_parser.dart';
import 'package:music_album_catalog/album_report.dart';
import 'package:music_album_catalog/album_statistics.dart';
import 'package:music_album_catalog/album_utils.dart';

int _checked = 0;

void verify(bool condition, String description) {
  if (!condition) {
    throw StateError('Тест провалено: $description');
  }
  _checked += 1;
  print('OK $_checked: $description');
}

void main() {
  final AlbumLoadResult loaded = loadAlbums(
    rawAlbumLines,
    asOf: DateTime.utc(2026, 10, 27),
  );
  verify(rawAlbumLines.length == 25, '25 сирих рядків');
  verify(loaded.albums.length == 20, '20 коректних альбомів');
  verify(loaded.errors.length == 5, '5 пошкоджених записів');
  verify(parseAlbum(rawAlbumLines[20]).album == null, 'неповний рядок');
  verify(parseAlbum(rawAlbumLines[21]).album == null, 'нечисловий рік');
  verify(parseAlbum(rawAlbumLines[22]).album == null, 'неіснуюча дата');
  verify(
    loaded.errors.any((String item) => item.contains('Кількість треків')),
    'перевірка діапазону треків',
  );
  verify(
    loaded.errors.any((String item) => item.contains('формату ALB-0000')),
    'перевірка формату коду',
  );
  verify(parseIsoDate('2024-02-29') != null, 'коректна високосна дата');
  verify(parseIsoDate('2024-02-30') == null, 'відхилення переповнення дати');
  verify(averageTrackCount(<Album>[]) == 0, 'порожній набір у fold');
  verify(releasedSince(loaded.albums, 2020).isNotEmpty, 'фільтрація за роком');
  verify(albumCaptions(loaded.albums).length == 20, 'map для підписів');
  verify(totalDuration(loaded.albums) > 0, 'where→map→fold');
  verify(groupByLabel(loaded.albums).length == 4, 'групування за лейблом');
  verify(
    durationByLabel(loaded.albums).values.fold<int>(0, (int a, int b) => a + b) ==
        totalDuration(loaded.albums),
    'сума по групах дорівнює сумі каталогу',
  );
  verify(
    sortByYear(loaded.albums).first.year <= sortByYear(loaded.albums).last.year,
    'сортування за роком зростає',
  );
  verify(
    sortByYear(loaded.albums, ascending: false).first.year >=
        sortByYear(loaded.albums, ascending: false).last.year,
    'сортування за роком спадає',
  );
  verify(
    sortByTrackCount(loaded.albums, ascending: false).first.trackCount >=
        sortByTrackCount(loaded.albums, ascending: false).last.trackCount,
    'сортування за кількістю треків',
  );
  verify(validCatalogCode('ALB-0123'), 'RegExp з іменованими групами');
  verify(!validCatalogCode('CD-0123'), 'некоректний код');
  verify(maskCatalogCode('ALB-0123') == 'ALB-**23', 'replaceAllMapped');
  verify(findAlbumByCode(loaded.albums, 'ALB-9999') == null, 'безпечний пошук');
  verify(
    loaded.albums.where(releasedFromYear(2020)).every((Album a) => a.year >= 2020),
    'замикання захоплює minYear',
  );
  final Album sample = (
    artist: 'Test',
    title: 'Test',
    year: 2026,
    label: 'Test Label',
    trackCount: 1,
    durationMinutes: 3,
    releaseDate: DateTime.utc(2026, 10, 26),
    catalogCode: 'ALB-9998',
  );
  verify(
    albumAgeInDays(sample, asOf: DateTime.utc(2026, 10, 27)) == 1,
    'DateTime.difference / Duration',
  );
  final String report = buildReport(
    loaded.albums,
    topCount: 3,
    ascending: true,
    separator: ' / ',
    errors: loaded.errors,
    asOf: DateTime.utc(2026, 10, 27),
  );
  verify(report.contains('ТОП-3'), 'іменований параметр topCount');
  verify(report.contains(' / '), 'іменований параметр separator');
  verify(report.contains('ВІДХИЛЕНІ РЯДКИ'), 'діагностика в звіті');
  print('Успішно пройдено $_checked перевірок.');
}
