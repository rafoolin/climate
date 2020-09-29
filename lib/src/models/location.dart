class Location {
  String title;
  String locationType;
  int woeid;
  String lattLong;

  Location({this.title, this.locationType, this.woeid, this.lattLong});

  @override
  int get hashCode => woeid;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      ((other is Location) && (this.woeid == other.woeid));

  Location.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    locationType = json['location_type'];
    woeid = json['woeid'];
    lattLong = json['latt_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['location_type'] = this.locationType;
    data['woeid'] = this.woeid;
    data['latt_long'] = this.lattLong;
    return data;
  }
}
