import 'album.dart';
import 'album_statistics.dart';
import 'album_utils.dart';

String buildReport(
  List<Album> albums, {
  int topCount = 5,
  bool ascending = false,
  String separator = ' | ',
  List<String> errors = const <String>[],
  DateTime? asOf,
}) {
  final StringBuffer buffer = StringBuffer();
  final DateTime referenceDate = asOf ?? DateTime.now();
  final int safeTopCount = topCount < 0 ? 0 : topCount;
  final List<Album> byYear = sortByYear(albums, ascending: ascending);
  final List<Album> byTracks = sortByTrackCount(albums, ascending: false);
  final Map<String, List<Album>> groups = groupByLabel(albums);
  final Map<String, int> labelMinutes = durationByLabel(albums);
  final List<String> labels = groups.keys.toList()..sort();

  buffer.writeln('==============================================');
  buffer.writeln('ЛАБОРАТОРНА РОБОТА №1 — КАТАЛОГ АЛЬБОМІВ');
  buffer.writeln('Варіант 8');
  buffer.writeln('==============================================');
  buffer.writeln('Дата формування: '
      '${referenceDate.day.toString().padLeft(2, '0')}.'
      '${referenceDate.month.toString().padLeft(2, '0')}.'
      '${referenceDate.year}');
  buffer.writeln('Коректних альбомів: ${albums.length}');
  buffer.writeln('Відхилено записів: ${errors.length}');
  buffer.writeln('Загальна тривалість: ${totalDuration(albums)} хв');
  buffer.writeln('Середня кількість треків: '
      '${averageTrackCount(albums).toStringAsFixed(2)}');
  buffer.writeln('Альбомів з 2015 року: ${releasedSince(albums, 2015).length}');

  buffer.writeln();
  buffer.writeln('ГРУПУВАННЯ ЗА ЛЕЙБЛОМ');
  for (final String label in labels) {
    buffer.writeln('$label: ${groups[label]!.length} альб., '
        '${labelMinutes[label]} хв');
  }

  buffer.writeln();
  buffer.writeln('ТОП-$safeTopCount ЗА РОКОМ '
      '(${ascending ? 'за зростанням' : 'за спаданням'})');
  for (final Album album in byYear.take(safeTopCount)) {
    buffer.writeln(<String>[
      album.artist,
      album.title,
      '${album.year}',
      '${album.trackCount} треків',
      '${album.durationMinutes} хв',
      maskCatalogCode(album.catalogCode),
      '${albumAgeInDays(album, asOf: referenceDate)} днів від випуску',
    ].join(separator));
  }

  buffer.writeln();
  buffer.writeln('ТОП-$safeTopCount ЗА КІЛЬКІСТЮ ТРЕКІВ');
  for (final Album album in byTracks.take(safeTopCount)) {
    buffer.writeln('${album.artist} — ${album.title}: ${album.trackCount}');
  }

  final List<Album> from2020 = albums.where(releasedFromYear(2020)).toList();
  buffer.writeln();
  buffer.writeln('Альбомів з 2020 року (замикання): ${from2020.length}');
  final Album? example = findAlbumByCode(albums, 'ALB-0001');
  buffer.writeln('Пошук ALB-0001: ${example?.title ?? 'не знайдено'}');

  if (errors.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('ВІДХИЛЕНІ РЯДКИ');
    for (final String error in errors) {
      buffer.writeln('- $error');
    }
  }
  return buffer.toString();
}
