// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageLocalModelAdapter extends TypeAdapter<MessageLocalModel> {
  @override
  final int typeId = 1;

  @override
  MessageLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageLocalModel(
      id: fields[0] as String,
      roomId: fields[1] as String,
      content: fields[2] as String,
      mediaUrl: fields[3] as String,
      sentAt: fields[4] as DateTime,
      isRead: fields[5] as bool,
      senderId: fields[6] as String,
      isSentByMe: fields[7] as bool,
      localMediaPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageLocalModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.mediaUrl)
      ..writeByte(4)
      ..write(obj.sentAt)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.senderId)
      ..writeByte(7)
      ..write(obj.isSentByMe)
      ..writeByte(8)
      ..write(obj.localMediaPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
