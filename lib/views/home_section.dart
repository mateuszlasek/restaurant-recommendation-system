import 'package:flutter/material.dart';
import 'package:proj_inz/components/restaurant_info_widget.dart';
import 'package:proj_inz/models/google_api_model.dart';

class HomeSection extends StatelessWidget {
  final Place place1 = Place(
      name: "Restauracja 1",
      id: "1",
      types: ["type1", "type2"],
      internationalPhoneNumber: "555",
      formattedAddress: "ul. marchew",
      addressComponents: [],
      location: Location(latitude: 5, longitude: 5),
      viewport: Viewports(low: LatLng(latitude: 5, longitude: 5), high: LatLng(latitude: 5, longitude: 5)),
      rating: 4.5,
      googleMapsUri: "a",
      regularOpeningHours: RegularOpeningHours(openNow: true, periods: [Period(open: Time(day: 5, hour: 4, minute: 3), close: Time(day: 6, hour: 5, minute: 5),)], weekdayDescriptions: ["m"]),
      businessStatus: "a",
      priceLevel: "2",
      userRatingCount: 15,
      displayName: DisplayName(text: "marchew", languageCode: "pl"),
      primaryTypeDisplayName: DisplayName(text: "Pizzeria", languageCode: "pl"),
      takeout: true,
      delivery: true,
      dineIn: true,
      servesLunch: true,
      servesDinner: true,
      servesBeer: true,
      servesWine: true,
      primaryType: "Pizzeria",
      shortFormattedAddress: "ul. Krowoderskich Zuchów 25/25",
      outdoorSeating: false,
      liveMusic: false,
      servesDessert: false,
      servesCoffee: false,
      restroom: false,
      goodForWatchingSports: false,
      paymentOptions: PaymentOptions(acceptsCreditCards: true, acceptsDebitCards: true, acceptsCashOnly: true, acceptsNfc: false),
      parkingOptions: ParkingOptions(freeParkingLot: false),
      accessibilityOptions: AccessibilityOptions(wheelchairAccessibleEntrance: true, wheelchairAccessibleSeating: true));

  HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            RestaurantWidget(place: place1),
            RestaurantWidget(place: place1),
            RestaurantWidget(place: place1),
          ],
        )
    );
  }
}
