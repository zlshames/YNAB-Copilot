// These should only be 32-4 words
import 'package:flutter/cupertino.dart';

final loadingPhrases = [
  // Generic loading phrases
  "Crunching Numbers",
  "Awaiting Abacus Results",
  "Warning: Math is Happening",
  "Calculating Calculations",
  "Counting Beans",
  "Adding Things Up",
  "Tabulating Totals",

  // Insulting loading phrases
  "Please seek financial help",
  "You must be new at this",
  "Money must not be your thing"
];

// If a category name contains any of the keys in this map,
// the corresponding emoji will be used.
final nameToEmojiMap = {
  "grocery": "🍞",
  "groceries": "🍞",
  "food": "🍔",
  "dining": "🍽",
  "restaurant": "🍽",
  "fast food": "🍟",
  "coffee": "☕️",
  "drink": "🍹",
  "alcohol": "🍺",
  "entertainment": "🎥",
  "movies": "🎥",
  "drugs": "💊",
  "weed": "🌿",
  "cannabis": "🌿",
  "marijuana": "🌿",
  "medical": "🏥",
  "health": "🏥",
  "car": "🚗",
  "auto": "🚗",
  "mortgage": "🏠",
  "rent": "🏠",
  "home": "🏠",
  "utilities": "💡",
  "electricity": "💡",
  "gas": "⛽️",
  "water": "🚿",
  "internet": "🌐",
  "phone": "📱",
  "verizon": "📱",
  "at&t": "📱",
  "sprint": "📱",
  "tmobile": "📱",
  "donation": "💸",
  "charity": "💸",
  "gift": "🎁",
  "present": "🎁",
  "clothing": "👕",
  "clothes": "👕",
  "shopping": "👜",
  "amazon": "📦",
  "ebay": "📦",
  "etsy": "📦",
  "paypal": "💳",
  "credit card": "💳",
  "interest": "💳",
  "fee": "💳",
  "travel": "✈️",
  "vacation": "🏖",
  "hotel": "🏨",
  "airbnb": "🏠",
  "uber": "🚗",
  "lyft": "🚗",
  "taxi": "🚖",
  "bus": "🚌",
  "train": "🚆",
  "subway": "🚇",
  "metro": "🚇",
  "cat": "🐱",
  "dog": "🐶",
  "pet": "🐾",
  "veterinarian": "🐾",
  "grooming": "🐾",
  "beauty": "💅",
  "hair": "💇",
  "salon": "💇",
  "spa": "💆",
  "nail": "💅",
  "makeup": "💄",
  "cosmetic": "💄",
  "gym": "🏋️",
  "fitness": "🏋️",
  "exercise": "🏋️",
  "games": "🎮",
  "videogame": "🎮",
  "fun": "🎉",
  "forgot": "🤦",
  "baby": "👶",
  "child": "👶",
  "tech": "💻",
  "streaming": "📺",
  "netflix": "📺",
  "hulu": "📺",
  "yard": "🌳",
  "lawn": "🌳",
  "garden": "🌹",
  "flower": "🌹",
  "plant": "🌱",
  "subscription": "🔁",
};

String selectRandomLoadingPhrase() {
  return loadingPhrases[DateTime.now().second % loadingPhrases.length];
}

void showCupertinoPicker(BuildContext ctx, Widget child, {double height = 215}) {
  showCupertinoModalPopup<void>(
    context: ctx,
    builder: (BuildContext context) => Container(
      height: height,
      padding: const EdgeInsets.only(top: 6.0),
      // The Bottom margin is provided to align the popup above the system navigation bar.
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // Provide a background color for the popup.
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
