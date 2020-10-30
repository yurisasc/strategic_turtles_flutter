/// Class to hold every constant variables
/// needed through the whole project
class Constants {
  // User roles
  static const String Farmer = 'Farmer';
  static const String Broker = 'Broker';
  static const List<String> roles = [Farmer, Broker];

  // Request status
  static const String Pending = 'Pending';
  static const String Accepted = 'Accepted';
  static const String Rejected = 'Rejected';
  static const List<String> requestStatus = [Pending, Accepted, Rejected];
}