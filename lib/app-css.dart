class GardenData {
  final String name;
  final String dbpath;
  final String picurl;
  final List<String> locsurl;

  GardenData(
    this.name,
    this.dbpath,
    this.picurl,
    this.locsurl,
  );
}

List<GardenData> gardenList = [
  GardenData(
    'Front Lawn',
    'frontlawn',
    r'lib/assets/images/frontlawn.jpg',
    [
      r'lib/assets/images/frontlawn_location1.jpg',
      r'lib/assets/images/frontlawn_location2.jpg',
    ],
  ),
  GardenData(
    'Leelavathi Hostel',
    'leelavathi',
    r'lib/assets/images/leelavathi.jpg',
    [
      r'lib/assets/images/leelavathi_location1.jpg',
    ],
  ),
];
