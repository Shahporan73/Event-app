import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime24hr(String dateTimeStr) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeStr); // Parse the string into DateTime
    return DateFormat('HH:mm').format(dateTime); // Format to 24-hour time
  }catch (e) {
    print("Error formatting time: $e");
    return dateTimeStr; // Return original time if parsing fails
  }
}



String convertFormatTime12hr(String dateTimeString) {
  try {
    // Parse the full DateTime string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Extract the time portion in 24-hour format
    String time24hr = DateFormat("HH:mm").format(dateTime);

    // Parse the extracted time and format it to 12-hour format with AM/PM
    DateTime time = DateFormat("HH:mm").parse(time24hr);
    return DateFormat("h:mm a").format(time);
  } catch (e) {
    print("Error formatting time: $e");
    return dateTimeString; // Return original string if parsing fails
  }
}

String formattedDateMethod(String? dateString) {
  try {
    if (dateString == null || dateString.isEmpty) {
      return DateFormat('MMM d, yyyy').format(DateTime.now()); // Fallback to current date
    }
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM d, yyyy').format(date);
  } catch (e) {
    return DateFormat('MMM d, yyyy').format(DateTime.now()); // Fallback to current date on error
  }
}


String convertIsoTo12Hour(String isoString, BuildContext context) {
  try {
    // Parse the ISO string into a DateTime object
    DateTime dateTime = DateTime.parse(isoString);

    // Format the time into 12-hour format with AM/PM using context
    TimeOfDay timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    String formattedTime = timeOfDay.format(context);

    return formattedTime;
  } catch (e) {
    // Handle invalid format
    print("Error converting ISO to 12-hour format: $e");
    return isoString; // Return the original string if parsing fails
  }
}

String convertDateToIso(DateTime date) {
  return date.toIso8601String();
}


String convertStringToIso(String dateString) {
  try {
    // Parse the date string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Convert it to ISO 8601 format
    return date.toIso8601String();
  } catch (e) {
    print("Error converting date to ISO format: $e");
    return dateString; // Return the original string if parsing fails
  }
}


