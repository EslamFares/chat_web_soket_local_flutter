enum MsgTypesEnum { receive, send }

extension MsgTypesEnumChecker on MsgTypesEnum {
  bool get isReviver => this == MsgTypesEnum.receive;
  bool get isSender => this == MsgTypesEnum.send;
}

extension MsgTypesEnumParsing on MsgTypesEnum {
  static MsgTypesEnum fromString(String str) {
    switch (str.toLowerCase()) {
      case 'receive':
        return MsgTypesEnum.receive;
      case 'send':
        return MsgTypesEnum.send;
      default:
        return MsgTypesEnum.receive;
    }
  }
}
