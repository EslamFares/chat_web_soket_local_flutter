import 'package:flutter/material.dart';
import 'package:try_web_socket_local/models/msg_model.dart';
import 'package:try_web_socket_local/models/msg_types_enum.dart';

class MassageContainer extends StatelessWidget {
  const MassageContainer({super.key, required this.msgModel});
  final MsgModel msgModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          MsgTypesEnumParsing.fromString(msgModel.type).isReviver
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: msgColor(), borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${msgModel.sender}:${(msgModel.sender.trim() == msgModel.usename.trim() && msgModel.sender != "Server") ? "(you)" : ''}"),
              Text(msgModel.msg),
              Align(
                  alignment:
                      MsgTypesEnumParsing.fromString(msgModel.type).isReviver
                          ? AlignmentDirectional.bottomEnd
                          : AlignmentDirectional.bottomStart,
                  child: Column(
                    children: [
                      Text(msgModel.time),
                      Text(msgModel.date),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Color msgColor() {
    if (MsgTypesEnumParsing.fromString(msgModel.type).isReviver) {
      if (msgModel.sender.trim() == msgModel.usename.trim()) {
        return Colors.teal;
      } else {
        return Colors.blue.withOpacity(.8);
      }
    }
    return Colors.grey;
  }
}
