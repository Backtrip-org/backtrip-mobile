class UserStats {
  int tripsNumber;
  int stepsNumber;
  int countriesVisited;
  int citiesVisited;

  UserStats(this.tripsNumber, this.stepsNumber, this.countriesVisited,
      this.citiesVisited);

  factory UserStats.fromJson(dynamic json) {
    return UserStats(
        json['trips_number'],
        json['steps_number'],
        json['countries_visited'],
        json['cities_visited'],
    );
  }
}
