part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChats extends ChatEvent {
  final String groupId;
  const GetChats(this.groupId);
  @override
  List<Object> get props => [groupId];
}

class GetAdmin extends ChatEvent {
  final String groupId;
  const GetAdmin(this.groupId);
  @override
  List<Object> get props => [groupId];
}

class SendMessageEvent extends ChatEvent {
  final String message, userName,groupId;
  const SendMessageEvent(this.message, this.userName, this.groupId);
  @override
  List<Object> get props => [message, userName,groupId];
}
