class MovieModel {
  String? title;
  String? year;
  String? imdbID;
  String? type;
  String? poster;

  MovieModel({this.title, this.year, this.imdbID, this.type, this.poster});

  MovieModel.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    imdbID = json['imdbID'];
    type = json['Type'];
    poster = json['Poster'];
  }
  @override
  String toString() {
    return 'MovieModel{title: $title, year: $year, imdbID: $imdbID, type: $type, poster: $poster}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['imdbID'] = this.imdbID;
    data['Type'] = this.type;
    data['Poster'] = this.poster;
    return data;
  }
}
