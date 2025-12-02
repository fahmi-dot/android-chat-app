// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomLocalModelAdapter extends TypeAdapter<RoomLocalModel> {
  @override
  final int typeId = 2;

  @override
  RoomLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomLocalModel(
      id: fields[0] as String,
      username: fields[1] as String,
      displayName: fields[2] as String,
      avatarUrl: fields[3] as String,
      lastMessage: fields[4] as String,
      lastMessageSentAt: fields[5] as DateTime,
      unreadMessagesCount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RoomLocalModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.lastMessageSentAt)
      ..writeByte(6)
      ..write(obj.unreadMessagesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
