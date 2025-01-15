// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MsgModel {
  final String type;
  final String msg;
  final String time;
  final String date;
  final String sender;
  MsgModel({
    required this.type,
    required this.msg,
    required this.time,
    required this.date,
    required this.sender,
  });

  MsgModel copyWith({
    String? type,
    String? msg,
    String? time,
    String? date,
    String? sender,
  }) {
    return MsgModel(
      type: type ?? this.type,
      msg: msg ?? this.msg,
      time: time ?? this.time,
      date: date ?? this.date,
      sender: sender ?? this.sender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'message': msg,
      'time': time,
      'date': date,
      'sender': sender,
    };
  }

  factory MsgModel.fromMap(Map<String, dynamic> map) {
    return MsgModel(
      type: map['type'] ?? "",
      msg: map['msg'] ?? "",
      time: map['time'] ?? "",
      date: map['date'] ?? "",
      sender: map['sender'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory MsgModel.fromJson(String source) =>
      MsgModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MsgModel(type: $type, message: $msg, time: $time, date: $date, sender: $sender)';
  }

  @override
  bool operator ==(covariant MsgModel other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.msg == msg &&
        other.time == time &&
        other.date == date &&
        other.sender == sender;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        msg.hashCode ^
        time.hashCode ^
        date.hashCode ^
        sender.hashCode;
  }
}
