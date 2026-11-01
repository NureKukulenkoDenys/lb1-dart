import 'album.dart';

final RegExp _codePattern = RegExp(r'^(?<prefix>ALB)-(?<number>\d{4})$');

bool validCatalogCode(String code) {
  final RegExpMatch? match = _codePattern.firstMatch(code);
  return match != null &&
      match.namedGroup('prefix') == 'ALB' &&
      match.namedGroup('number') != null;
}

String maskCatalogCode(String code) {
  final RegExp maskPattern = RegExp(
    r'^(?<prefix>ALB-)(?<secret>\d{2})(?<visible>\d{2})$',
  );
  return code.replaceAllMapped(maskPattern, (Match match) {
    return '${match.namedGroup('prefix')}**${match.namedGroup('visible')}';
  });
}

bool Function(Album) releasedFromYear(int minYear) {
  return (Album album) => album.year >= minYear;
}

int albumAgeInDays(Album album, {DateTime? asOf}) {
  final DateTime today = asOf ?? DateTime.now();
  final DateTime toDate = DateTime.utc(today.year, today.month, today.day);
  final DateTime fromDate = DateTime.utc(
    album.releaseDate.year,
    album.releaseDate.month,
    album.releaseDate.day,
  );
  final Duration duration = toDate.difference(fromDate);
  return duration.inDays;
}

Album? findAlbumByCode(Iterable<Album> albums, String code) {
  return albums.where((Album album) => album.catalogCode == code).firstOrNull;
}

List<Album> sortByYear(Iterable<Album> albums, {bool ascending = true}) {
  final List<Album> sorted = albums.toList();
  sorted.sort((Album first, Album second) {
    final int comparison = first.year.compareTo(second.year);
    final int tieBreak = first.title.compareTo(second.title);
    final int result = comparison != 0 ? comparison : tieBreak;
    return ascending ? result : -result;
  });
  return sorted;
}

List<Album> sortByTrackCount(Iterable<Album> albums, {bool ascending = true}) {
  final List<Album> sorted = albums.toList();
  sorted.sort((Album first, Album second) {
    final int comparison = first.trackCount.compareTo(second.trackCount);
    final int tieBreak = first.title.compareTo(second.title);
    final int result = comparison != 0 ? comparison : tieBreak;
    return ascending ? result : -result;
  });
  return sorted;
}
