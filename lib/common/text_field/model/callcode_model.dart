class CallcodeModel {
  final String countryCode;
  final String countryEn;
  final String countryCn;
  final int phoneCode;

  CallcodeModel({
    required this.countryCode,
    required this.countryEn,
    required this.countryCn,
    required this.phoneCode,
  });

  // Factory constructor to create a CallcodeModel from JSON
  factory CallcodeModel.fromJson(Map<String, dynamic> json) {
    return CallcodeModel(
      countryCode: json['country_code'] ?? '',
      countryEn: json['country_en'] ?? '',
      countryCn: json['country_cn'] ?? '',
      phoneCode: json['phone_code'] ?? 0,
    );
  }

  // Method to convert CallcodeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'countryEn': countryEn,
      'countryCn': countryCn,
      'phoneCode': phoneCode,
    };
  }
}
