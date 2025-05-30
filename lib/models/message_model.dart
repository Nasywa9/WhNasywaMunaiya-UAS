class MessageModel {
  final int from; 
  final String message;
  bool isRead; 

  MessageModel({
    required this.from,
    required this.message,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    from: json['from'],
    message: json['message'],
    isRead: json['isRead'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'from': from,
    'message': message,
    'isRead': isRead,
  };
}
