class Place {
  final String name;
  final String id;
  final List<String> types;
  final String internationalPhoneNumber;
  final String formattedAddress;
  final List<AddressComponent> addressComponents;
  final Location location;
  final Viewport viewport;
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
    required this.takeout,
    required this.delivery,
    required this.dineIn,
    required this.servesLunch,
    required this.servesDinner,
    required this.servesBeer,
    required this.servesWine,
    required this.primaryType,
    required this.shortFormattedAddress,
    required this.outdoorSeating,
    required this.liveMusic,
    required this.servesDessert,
    required this.servesCoffee,
    required this.restroom,
    required this.goodForWatchingSports,
    required this.paymentOptions,
    required this.parkingOptions,
    required this.accessibilityOptions,
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
      viewport: Viewport.fromJson(json['viewport']),
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

class Viewport {
  final LatLng low;
  final LatLng high;

  Viewport({
    required this.low,
    required this.high,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
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

  RegularOpeningHours({
    required this.openNow,
    required this.periods,
    required this.weekdayDescriptions,
  });

  factory RegularOpeningHours.fromJson(Map<String, dynamic> json) {
    return RegularOpeningHours(
      openNow: json['openNow'],
      periods: (json['periods'] as List).map((item) => Period.fromJson(item)).toList(),
      weekdayDescriptions: List<String>.from(json['weekdayDescriptions']),
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
    required this.acceptsCreditCards,
    required this.acceptsDebitCards,
    required this.acceptsCashOnly,
    required this.acceptsNfc,
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
  final bool freeParkingLot;

  ParkingOptions({required this.freeParkingLot});

  factory ParkingOptions.fromJson(Map<String, dynamic> json) {
    return ParkingOptions(
      freeParkingLot: json['freeParkingLot'],
    );
  }
}

class AccessibilityOptions {
  final bool wheelchairAccessibleEntrance;
  final bool wheelchairAccessibleSeating;

  AccessibilityOptions({
    required this.wheelchairAccessibleEntrance,
    required this.wheelchairAccessibleSeating,
  });

  factory AccessibilityOptions.fromJson(Map<String, dynamic> json) {
    return AccessibilityOptions(
      wheelchairAccessibleEntrance: json['wheelchairAccessibleEntrance'],
      wheelchairAccessibleSeating: json['wheelchairAccessibleSeating'],
    );
  }
}
