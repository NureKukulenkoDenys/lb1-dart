import 'album.dart';

DateTime? parseIsoDate(String text) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) {
    return null;
  }
  final DateTime? parsed = DateTime.tryParse(text);
  if (parsed == null || parsed.toIso8601String().substring(0, 10) != text) {
    return null;
  }
  return parsed;
}

AlbumParseResult parseAlbum(String line) {
  final List<String> fields = line.split(';').map((String field) => field.trim()).toList();
  if (fields.length != 8) {
    return (album: null, error: 'Очікувалося 8 полів, отримано ${fields.length}.');
  }

  final int? year = int.tryParse(fields[2]);
  final int? trackCount = int.tryParse(fields[4]);
  final int? durationMinutes = int.tryParse(fields[5]);
  final DateTime? releaseDate = parseIsoDate(fields[6]);

  if (year == null) {
    return (album: null, error: 'Некоректний рік: "${fields[2]}".');
  }
  if (trackCount == null) {
    return (album: null, error: 'Некоректна кількість треків: "${fields[4]}".');
  }
  if (durationMinutes == null) {
    return (album: null, error: 'Некоректна тривалість: "${fields[5]}".');
  }
  if (releaseDate == null) {
    return (album: null, error: 'Некоректна дата випуску: "${fields[6]}".');
  }

  return (
    album: (
      artist: fields[0],
      title: fields[1],
      year: year,
      label: fields[3],
      trackCount: trackCount,
      durationMinutes: durationMinutes,
      releaseDate: releaseDate,
      catalogCode: fields[7],
    ),
    error: null,
  );
}

List<String> validateAlbum(Album album, {DateTime? asOf}) {
  final DateTime now = asOf ?? DateTime.now();
  final List<String> issues = <String>[];
  if (album.artist.trim().isEmpty) {
    issues.add('Відсутній виконавець.');
  }
  if (album.title.trim().isEmpty) {
    issues.add('Відсутня назва альбому.');
  }
  if (album.label.trim().isEmpty) {
    issues.add('Відсутній лейбл.');
  }
  if (album.year < 1900 || album.year > now.year) {
    issues.add('Рік має бути в межах 1900–${now.year}.');
  }
  if (album.trackCount < 1 || album.trackCount > 100) {
    issues.add('Кількість треків має бути в межах 1–100.');
  }
  if (album.durationMinutes < 1 || album.durationMinutes > 1500) {
    issues.add('Тривалість має бути в межах 1–1500 хв.');
  }
  if (album.releaseDate.year != album.year) {
    issues.add('Рік випуску не відповідає даті випуску.');
  }
  final DateTime today = DateTime.utc(now.year, now.month, now.day);
  final DateTime released = DateTime.utc(
    album.releaseDate.year,
    album.releaseDate.month,
    album.releaseDate.day,
  );
  if (released.isAfter(today)) {
    issues.add('Дата випуску не може бути в майбутньому.');
  }
  if (album.catalogCode.isEmpty) {
    issues.add('Відсутній каталожний код.');
  }
  return issues;
}

AlbumLoadResult loadAlbums(Iterable<String> lines, {DateTime? asOf}) {
  final List<Album> albums = <Album>[];
  final List<String> errors = <String>[];

  for (final (int index, String line) in lines.indexed) {
    final AlbumParseResult parsed = parseAlbum(line);
    final Album? album = parsed.album;
    if (album == null) {
      errors.add('Рядок ${index + 1}: ${parsed.error ?? 'Помилка розбору'}');
      continue;
    }

    final List<String> issues = validateAlbum(album, asOf: asOf);
    if (issues.isNotEmpty) {
      errors.add('Рядок ${index + 1}: ${issues.join(' ')}');
      continue;
    }
    albums.add(album);
  }
  return (albums: albums, errors: errors);
}
