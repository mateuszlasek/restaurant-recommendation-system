class UserFormModel {
  final String name;
  final bool servesVegetarianFood;
  final bool menuForChildren;
  final bool goodForChildren;
  final bool allowsDogs;
  final bool acceptsCreditCards;
  final bool acceptsDebitCards;
  final bool acceptsCashOnly;
  final bool acceptsNfc;
  final bool freeParkingLot;
  final bool paidParkingLot;
  final bool wheelchairAccessibleParking;
  final bool wheelchairAccessibleEntrance;
  final bool wheelchairAccessibleRestroom;

  UserFormModel({
    required this.name,
    required this.servesVegetarianFood,
    required this.menuForChildren,
    required this.goodForChildren,
    required this.allowsDogs,
    required this.acceptsCreditCards,
    required this.acceptsDebitCards,
    required this.acceptsCashOnly,
    required this.acceptsNfc,
    required this.freeParkingLot,
    required this.paidParkingLot,
    required this.wheelchairAccessibleParking,
    required this.wheelchairAccessibleEntrance,
    required this.wheelchairAccessibleRestroom,
  });

  // Konwersja obiektu do mapy, aby można było zapisać go w Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'servesVegetarianFood': servesVegetarianFood,
      'menuForChildren': menuForChildren,
      'goodForChildren': goodForChildren,
      'allowsDogs': allowsDogs,
      'acceptsCreditCards': acceptsCreditCards,
      'acceptsDebitCards': acceptsDebitCards,
      'acceptsCashOnly': acceptsCashOnly,
      'acceptsNfc': acceptsNfc,
      'freeParkingLot': freeParkingLot,
      'paidParkingLot': paidParkingLot,
      'wheelchairAccessibleParking': wheelchairAccessibleParking,
      'wheelchairAccessibleEntrance': wheelchairAccessibleEntrance,
      'wheelchairAccessibleRestroom': wheelchairAccessibleRestroom,
    };
  }
}
