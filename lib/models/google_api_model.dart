class Place {
  final String name;
  final String id;
  final List<String> types;
  final String internationalPhoneNumber;
  final String formattedAddress;
  final List<AddressComponent> addressComponents;
  final Location location;
  final Viewports viewport;
  final double rating;
  final String googleMapsUri;
  final RegularOpeningHours regularOpeningHours;
  final String businessStatus;
  final String priceLevel;
  final int userRatingCount;
  final DisplayName displayName;
  final DisplayName primaryTypeDisplayName;
  final bool takeout;
  final bool delivery;
  final bool dineIn;
  final bool servesLunch;
  final bool servesDinner;
  final bool servesBeer;
  final bool servesWine;
  final String primaryType;
  final String shortFormattedAddress;
  final bool outdoorSeating;
  final bool liveMusic;
  final bool servesDessert;
  final bool servesCoffee;
  final bool restroom;
  final bool goodForWatchingSports;
  final PaymentOptions paymentOptions;
  final ParkingOptions parkingOptions;
  final AccessibilityOptions accessibilityOptions;
  final bool curbsidePickup;
  final bool servesVegetarianFood;
  final bool menuForChildren;
  final bool servesCocktails;
  final bool goodForChildren;
  final bool allowsDogs;
  final String websiteUri;

  Place({
    required this.name,
    required this.id,
    required this.types,
    required this.internationalPhoneNumber,
    required this.formattedAddress,
    required this.addressComponents,
    required this.location,
    required this.viewport,
    required this.rating,
    required this.googleMapsUri,
    required this.regularOpeningHours,
    required this.businessStatus,
    required this.priceLevel,
    required this.userRatingCount,
    required this.displayName,
    required this.primaryTypeDisplayName,
    required this.primaryType,
    required this.shortFormattedAddress,
    required this.paymentOptions,
    required this.parkingOptions,
    required this.accessibilityOptions,
    required this.websiteUri,
    this.curbsidePickup = false,
    this.servesVegetarianFood = false,
    this.menuForChildren = false,
    this.servesCocktails = false,
    this.goodForChildren = false,
    this.allowsDogs = false,
    this.takeout = false,
    this.delivery = false,
    this.dineIn = false,
    this.servesLunch = false,
    this.servesDinner = false,
    this.servesBeer = false,
    this.servesWine = false,
    this.outdoorSeating = false,
    this.liveMusic = false,
    this.servesDessert = false,
    this.servesCoffee = false,
    this.restroom = false,
    this.goodForWatchingSports = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      id: json['id'],
      types: List<String>.from(json['types']),
      internationalPhoneNumber: json['internationalPhoneNumber'],
      formattedAddress: json['formattedAddress'],
      addressComponents: (json['addressComponents'] as List)
          .map((item) => AddressComponent.fromJson(item))
          .toList(),
      location: Location.fromJson(json['location']),
      viewport: Viewports.fromJson(json['viewport']),
      rating: json['rating'],
      googleMapsUri: json['googleMapsUri'],
      regularOpeningHours: RegularOpeningHours.fromJson(json['regularOpeningHours']),
      businessStatus: json['businessStatus'],
      priceLevel: json['priceLevel'],
      userRatingCount: json['userRatingCount'],
      displayName: DisplayName.fromJson(json['displayName']),
      primaryTypeDisplayName: DisplayName.fromJson(json['primaryTypeDisplayName']),
      takeout: json['takeout'],
      delivery: json['delivery'],
      dineIn: json['dineIn'],
      servesLunch: json['servesLunch'],
      servesDinner: json['servesDinner'],
      servesBeer: json['servesBeer'],
      servesWine: json['servesWine'],
      primaryType: json['primaryType'],
      shortFormattedAddress: json['shortFormattedAddress'],
      outdoorSeating: json['outdoorSeating'],
      liveMusic: json['liveMusic'],
      servesDessert: json['servesDessert'],
      servesCoffee: json['servesCoffee'],
      restroom: json['restroom'],
      goodForWatchingSports: json['goodForWatchingSports'],
      paymentOptions: PaymentOptions.fromJson(json['paymentOptions']),
      parkingOptions: ParkingOptions.fromJson(json['parkingOptions']),
      accessibilityOptions: AccessibilityOptions.fromJson(json['accessibilityOptions']),
      curbsidePickup: json['curbsidePickup'],
      servesVegetarianFood: json['servesVegetarianFood'],
      menuForChildren: json['menuForChildren'],
      servesCocktails: json['servesCocktails'],
      goodForChildren: json['goodForChildren'],
      allowsDogs: json['allowsDogs'],
      websiteUri: json['websiteUri']
    );
  }
}

class AddressComponent {
  final String longText;
  final String shortText;
  final List<String> types;
  final String languageCode;

  AddressComponent({
    required this.longText,
    required this.shortText,
    required this.types,
    required this.languageCode,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longText: json['longText'],
      shortText: json['shortText'],
      types: List<String>.from(json['types']),
      languageCode: json['languageCode'],
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Viewports {
  final LatLng low;
  final LatLng high;

  Viewports({
    required this.low,
    required this.high,
  });

  factory Viewports.fromJson(Map<String, dynamic> json) {
    return Viewports(
      low: LatLng.fromJson(json['low']),
      high: LatLng.fromJson(json['high']),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({
    required this.latitude,
    required this.longitude,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class RegularOpeningHours {
  final bool openNow;
  final List<Period> periods;
  final List<String> weekdayDescriptions;
  final String nextOpenTime;

  RegularOpeningHours({
    required this.openNow,
    required this.periods,
    required this.weekdayDescriptions,
    required this.nextOpenTime,
  });

  factory RegularOpeningHours.fromJson(Map<String, dynamic> json) {
    return RegularOpeningHours(
      openNow: json['openNow'],
      periods: (json['periods'] as List).map((item) => Period.fromJson(item)).toList(),
      weekdayDescriptions: List<String>.from(json['weekdayDescriptions']),
      nextOpenTime: json["nextOpenTime"]
    );
  }
}

class Period {
  final Time open;
  final Time close;

  Period({
    required this.open,
    required this.close,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      open: Time.fromJson(json['open']),
      close: Time.fromJson(json['close']),
    );
  }
}

class Time {
  final int day;
  final int hour;
  final int minute;

  Time({
    required this.day,
    required this.hour,
    required this.minute,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }
}

class DisplayName {
  final String text;
  final String languageCode;

  DisplayName({
    required this.text,
    required this.languageCode,
  });

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'],
      languageCode: json['languageCode'],
    );
  }
}

class PaymentOptions {
  final bool acceptsCreditCards;
  final bool acceptsDebitCards;
  final bool acceptsCashOnly;
  final bool acceptsNfc;

  PaymentOptions({
    this.acceptsCreditCards = false,
    this.acceptsDebitCards = false,
    this.acceptsCashOnly = false,
    this.acceptsNfc = false,
  });

  factory PaymentOptions.fromJson(Map<String, dynamic> json) {
    return PaymentOptions(
      acceptsCreditCards: json['acceptsCreditCards'],
      acceptsDebitCards: json['acceptsDebitCards'],
      acceptsCashOnly: json['acceptsCashOnly'],
      acceptsNfc: json['acceptsNfc'],
    );
  }
}

class ParkingOptions {
  final bool paidParkingLot;
  final bool freeParkingLot;
  final bool paidStreetParking;
  final bool valetParking;
  final bool freeStreetParking;
  final bool freeGarageParking;
  final bool paidGarageParking;

  ParkingOptions({
    this.paidParkingLot = false,
    this.paidStreetParking = false,
    this.valetParking = false,
    this.freeStreetParking = false,
    this.freeGarageParking = false,
    this.paidGarageParking = false,
    this.freeParkingLot = false
});

  factory ParkingOptions.fromJson(Map<String, dynamic> json) {
    return ParkingOptions(
      paidParkingLot: json['paidParkingLot'],
      paidStreetParking: json['paidStreetParking'],
      valetParking: json['valetParking'],
      freeStreetParking: json['freeStreetParking'],
      freeGarageParking: json['freeGarageParking'],
      paidGarageParking: json['paidGarageParking'],
    );
  }
}

class AccessibilityOptions {
  final bool wheelchairAccessibleEntrance;
  final bool wheelchairAccessibleSeating;
  final bool wheelchairAccessibleRestroom;
  final bool wheelchairAccessibleParking;

  AccessibilityOptions({
    this.wheelchairAccessibleEntrance = false,
    this.wheelchairAccessibleSeating = false,
    this.wheelchairAccessibleRestroom = false,
    this.wheelchairAccessibleParking = false,
  });

  factory AccessibilityOptions.fromJson(Map<String, dynamic> json) {
    return AccessibilityOptions(
      wheelchairAccessibleEntrance: json['wheelchairAccessibleEntrance'],
      wheelchairAccessibleSeating: json['wheelchairAccessibleSeating'],
      wheelchairAccessibleRestroom: json['wheelchairAccessibleRestroom'],
      wheelchairAccessibleParking: json['wheelchairAccessibleParking'],
    );
  }
}
