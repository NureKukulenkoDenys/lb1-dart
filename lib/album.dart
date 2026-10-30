typedef Album = ({
  String artist,
  String title,
  int year,
  String label,
  int trackCount,
  int durationMinutes,
  DateTime releaseDate,
  String catalogCode,
});

typedef AlbumParseResult = ({Album? album, String? error});

typedef AlbumLoadResult = ({List<Album> albums, List<String> errors});
