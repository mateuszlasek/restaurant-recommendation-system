# Place Details - API Documentation

This document describes the structure of the place details returned by the API.

## Fields

### Basic Information
- **name**: Identifier for the place in the format `places/id`.
- **id**: Unique identifier for the place, used to fetch detailed information from the API.
- **types**: Array of strings describing the place's categories.
    - **Example**:
      ```json
      "types": [
        "seafood_restaurant",
        "restaurant",
        "food",
        "point_of_interest",
        "establishment"
      ]
      ```

### Address
- **formattedAddress**: Address in the format "Street, Postal Code City, Country".
    - **Example**: `"Grodzka 26, 31-044 Kraków, Polska"`
- **internationalPhoneNumber**: Phone number with country code.
- **addressComponents**: Array of objects, each containing detailed address components.
    - **Example**:
      ```json
      "addressComponents": [
        {
              "longText": "22",
              "shortText": "22",
              "types": [
                "street_number"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Szpitalna",
              "shortText": "Szpitalna",
              "types": [
                "route"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Stare Miasto",
              "shortText": "Stare Miasto",
              "types": [
                "sublocality_level_1",
                "sublocality",
                "political"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Kraków",
              "shortText": "Kraków",
              "types": [
                "locality",
                "political"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Powiat Kraków",
              "shortText": "Powiat Kraków",
              "types": [
                "administrative_area_level_2",
                "political"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Województwo małopolskie",
              "shortText": "Województwo małopolskie",
              "types": [
                "administrative_area_level_1",
                "political"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "Polska",
              "shortText": "PL",
              "types": [
                "country",
                "political"
              ],
              "languageCode": "pl"
            },
            {
              "longText": "31-024",
              "shortText": "31-024",
              "types": [
                "postal_code"
              ],
              "languageCode": "pl"
            }
      ]
      ```

### Location
- **location**: Object containing latitude and longitude.
- **viewport**: Specifies the geographical bounds of the location.
    - **Example**:
      ```json
      "viewport": {
        "low": {
          "latitude": 50.0577122697085,
          "longitude": 19.936592419708496
        },
        "high": {
          "latitude": 50.0604102302915,
          "longitude": 19.9392903802915
        }
      }
      ```

### Ratings and Links
- **rating**: Place's rating as a `double`.
- **googleMapsUri**: Google Maps URL for the place.
- **websiteUri**: URL to the place’s official website.

### Opening Hours
- **regularOpeningHours**: Details on the place’s opening hours.
    - **openNow**: Boolean indicating if the place is currently open.
    - **periods**: Array of 7 objects (one per day of the week), each containing:
        - **open** and **close**: Objects specifying:
            - **day**: Day of the week.
            - **hour** and **minute**: Opening and closing times.
    - **weekdayDescriptions**: Array of strings, displaying opening hours as in Google Maps.
        - **Example Format**: `"DayOfWeek: 00:00-00:00"`

### Status and Pricing
- **businessStatus**: Operational status of the place (e.g., `"OPERATIONAL"`).
- **priceLevel**: String representing the price level (e.g., `PRICE_LEVEL_MODERATE`, `PRICE_LEVEL_INEXPENSIVE`, etc.).
- **userRatingCount**: Integer representing the number of user reviews.

### Display Names
- **displayName**: Object with:
    - **text**: Place’s name.
    - **languageCode**: Language code of the name.
- **primaryTypeDisplayName**: Object with:
    - **text**: Main category of the place (e.g., `"Breakfast Restaurant"`, `"French Cuisine"`).
- **primaryType**: Main purpose of the place, should be `"restaurant"`.

### Address Formatting
- **shortFormattedAddress**: Concise address in the format "Street Number, City".

### Services Offered
- **takeout**: Boolean, indicating if takeout is available.
- **delivery**: Boolean, indicating if delivery is available.
- **dineIn**: Boolean, indicating if dine-in is available.
- **curbsidePickup**: Boolean, indicating if curbside pickup is available.

### Dining Options
- **servesBreakfast**: Boolean, indicating if breakfast is served.
- **servesLunch**: Boolean, indicating if lunch is served.
- **servesDinner**: Boolean, indicating if dinner is served.
- **servesBeer**: Boolean, indicating if beer is served.
- **servesWine**: Boolean, indicating if wine is served.
- **servesVegetarianFood**: Boolean, indicating if vegetarian food is available.
- **servesCocktails**: Boolean, indicating if cocktails are served.
- **servesDessert**: Boolean, indicating if desserts are served.
- **servesCoffee**: Boolean, indicating if coffee is served.

### Additional Information
- **outdoorSeating**: Boolean, indicating if outdoor seating is available.
- **liveMusic**: Boolean, indicating if live music is available.
- **menuForChildren**: Boolean, indicating if a children's menu is available.
- **goodForChildren**: Boolean, indicating if the place is child-friendly.
- **allowsDogs**: Boolean, indicating if dogs are allowed.
- **restroom**: Boolean, indicating if restrooms are available.
- **goodForWatchingSports**: Boolean, indicating if the place is suitable for watching sports.

### Payment Options
- **paymentOptions**: Object containing:
    - **acceptsCreditCards**: Boolean.
    - **acceptsDebitCards**: Boolean.
    - **acceptsCashOnly**: Boolean.
    - **acceptsNfc**: Boolean, for NFC-based payments.

### Parking Options
- **parkingOptions**: Object containing:
    - **freeParkingLot**: Boolean.
    - **paidParkingLot**: Boolean.

### Accessibility Options
- **accessibilityOptions**: Object containing:
    - **wheelchairAccessibleParking**: Boolean.
    - **wheelchairAccessibleEntrance**: Boolean.
    - **wheelchairAccessibleRestroom**: Boolean.
