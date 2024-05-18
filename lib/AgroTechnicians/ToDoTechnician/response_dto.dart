class TrackerResponseDto {
  final String status;
  final String message;
  final bool tracker;

  TrackerResponseDto({
    required this.status,
    required this.message,
    required this.tracker,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'tracker': tracker,
    };
  }

  factory TrackerResponseDto.fromJson(Map<String, dynamic> json) {
    return TrackerResponseDto(
      status: json['status'],
      message: json['message'],
      tracker: json['tracker'],
    );
  }
}
