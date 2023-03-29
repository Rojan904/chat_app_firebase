import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/database_service.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<GetChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final data = await DatabaseService().getChats(event.groupId);
        emit(ChatLoaded(data: data));
      } on Exception catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    on<GetAdmin>((event, emit) {
      try {
        final data = DatabaseService().getAdmin(event.groupId);
        emit(ChatLoaded(data: data));
      } on Exception catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    on<SendMessageEvent>(
      (event, emit) async {
        try {
        if(event.message.isNotEmpty){  Map<String, dynamic> chatMessageMap = {
            "message": event.message,
            "sender": event.userName,
            "time": DateTime.now().microsecondsSinceEpoch
          };
          await DatabaseService().sendMessage(event.groupId, chatMessageMap);}
        } catch (e) {
          emit(ChatError(e.toString()));
        }
      },
    );
  }
}
