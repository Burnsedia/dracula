class BloodSugar {
  int bloodSugar;
  int carbs;
  String food;
  BloodSugar(this.bloodSugar, this.carbs, this.food)
}

class Record {
  final int bloodSugar;
  final int carbs;
  Record({required this.bloodSugar, required this.carbs});
}
