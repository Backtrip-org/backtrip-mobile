class ChatMessage {
  int id;
  String message;
  int tripId;
  int userId;

  ChatMessage({this.id, this.message, this.tripId, this.userId});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      tripId: json['trip_id'],
      userId: json['user_id'],
    );
  }
}