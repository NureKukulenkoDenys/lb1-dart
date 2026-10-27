/// Демонстраційні (вигадані) дані для каталогу. Формат:
/// виконавець;назва;рік;лейбл;кількість_треків;тривалість_хв;дата;код.
///
/// 20 коректних та 5 навмисно некоректних рядків.
const List<String> rawAlbumLines = <String>[
  'Nova Echo;Skyline Drift;2003;Aurora Records;12;48;2003-04-15;ALB-0001',
  'Pixel Tide;Neon Seasons;2015;Blue Moon;10;42;2015-09-18;ALB-0002',
  'Amber Circuit;Glass Horizon;2019;North Wave;11;45;2019-05-03;ALB-0003',
  'Orbit Kids;Faraway Radio;2010;Orbit Sound;9;38;2010-01-20;ALB-0004',
  'Nova Echo;Signals in Rain;2022;Aurora Records;13;54;2022-10-07;ALB-0005',
  'Pixel Tide;Midnight Transit;2008;Blue Moon;12;49;2008-06-14;ALB-0006',
  'Amber Circuit;Electric Gardens;2024;North Wave;14;58;2024-03-22;ALB-0007',
  'Silver Avenue;Vinyl Dreams;1999;Orbit Sound;10;41;1999-11-12;ALB-0008',
  'Orbit Kids;Analog Future;2017;Orbit Sound;8;34;2017-07-28;ALB-0009',
  'Nova Echo;Between Stations;2005;Aurora Records;11;44;2005-02-04;ALB-0010',
  'Silver Avenue;Northern Lights;2021;Blue Moon;12;51;2021-12-03;ALB-0011',
  'Pixel Tide;Paper Satellites;2013;Blue Moon;9;37;2013-08-16;ALB-0012',
  'Amber Circuit;Waves and Wires;2016;North Wave;13;52;2016-04-29;ALB-0013',
  'Orbit Kids;Letters to Mars;2020;Orbit Sound;10;43;2020-02-21;ALB-0014',
  'Silver Avenue;Slow Motion;2012;Aurora Records;11;46;2012-05-11;ALB-0015',
  'Nova Echo;Early Mornings;2001;Aurora Records;8;32;2001-09-09;ALB-0016',
  'Pixel Tide;Low Orbit;2023;Blue Moon;15;60;2023-11-17;ALB-0017',
  'Silver Avenue;Bright City;2018;Aurora Records;10;40;2018-01-26;ALB-0018',
  'Amber Circuit;Deep Blue;2009;North Wave;12;47;2009-03-13;ALB-0019',
  'Orbit Kids;Tomorrow Is Here;2025;Orbit Sound;10;39;2025-06-06;ALB-0020',
  // Помилка 1: відсутній восьмий стовпець (код).
  'Broken Notes;No Catalog Code;2018;Blue Moon;9;39;2018-10-01',
  // Помилка 2: нечисловий рік випуску.
  'Broken Notes;No Numeric Year;twenty;North Wave;8;33;2020-05-14;ALB-0022',
  // Помилка 3: неіснуюча дата (DateTime.tryParse нормалізує переповнення).
  'Broken Notes;Invalid February;2024;Aurora Records;10;41;2024-02-30;ALB-0023',
  // Помилка 4: кількість треків поза допустимим діапазоном.
  'Broken Notes;Zero Tracks;2021;Orbit Sound;0;44;2021-07-01;ALB-0024',
  // Помилка 5: код не відповідає формату ALB-0000.
  'Broken Notes;Wrong Code;2020;Blue Moon;9;35;2020-08-08;CD-0025',
];
