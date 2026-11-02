import 'album.dart';

List<Album> releasedSince(Iterable<Album> albums, int year) {
  return albums.where((Album album) => album.year >= year).toList();
}

List<String> albumCaptions(Iterable<Album> albums) {
  return albums
      .map((Album album) => '${album.artist} — ${album.title}')
      .toList();
}

int totalDuration(Iterable<Album> albums) {
  return albums
      .where((Album album) => album.durationMinutes > 0)
      .map((Album album) => album.durationMinutes)
      .fold<int>(0, (int total, int minutes) => total + minutes);
}

double averageTrackCount(Iterable<Album> albums) {
  final ({int count, int tracks}) sums = albums.fold<({int count, int tracks})>(
    (count: 0, tracks: 0),
    (({int count, int tracks}) accum, Album album) => (
      count: accum.count + 1,
      tracks: accum.tracks + album.trackCount,
    ),
  );
  return sums.count == 0 ? 0 : sums.tracks / sums.count;
}

Map<String, List<Album>> groupByLabel(Iterable<Album> albums) {
  return albums.fold<Map<String, List<Album>>>(
    <String, List<Album>>{},
    (Map<String, List<Album>> groups, Album album) {
      groups.putIfAbsent(album.label, () => <Album>[]).add(album);
      return groups;
    },
  );
}

Map<String, int> durationByLabel(Iterable<Album> albums) {
  return groupByLabel(albums).map(
    (String label, List<Album> group) => MapEntry<String, int>(
      label,
      totalDuration(group),
    ),
  );
}
