import 'dart:typed_data';
import '../data/demo_repository.dart';

class ChatMessage {
  final Label body;
  final bool fromUser;
  final Uint8List? photo;
  const ChatMessage(this.body, {this.fromUser = false, this.photo});
}

/// Implement this contract using a secure mobile backend in the future.
/// Never put provider credentials in the mobile client.
abstract interface class ChatService {
  Future<ChatMessage> reply(List<ChatMessage> conversation);
}

class DemoChatService implements ChatService {
  @override
  Future<ChatMessage> reply(
    List<ChatMessage> conversation,
  ) async => const ChatMessage(
    Label(
      'डेमो: आपकी बात दर्ज हुई। AI सक्रिय नहीं है। यह तय नमूना उत्तर है, निदान या चिकित्सा सलाह नहीं। डॉक्टर का प्रोफाइल देख सकते हैं।',
      'DEMO: Your message is in this session. AI is inactive. This is a fixed sample reply, not a diagnosis or medical advice. You can view a doctor profile.',
    ),
  );
}
