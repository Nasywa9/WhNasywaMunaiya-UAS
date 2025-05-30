import 'package:flutter/material.dart';
import 'package:whazlansaja/models/message_model.dart';
import 'package:whazlansaja/models/dosen_model.dart';

class PesanScreen extends StatefulWidget {
  final DosenModel dosen;

  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final TextEditingController _controller = TextEditingController();

  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.dosen.messages);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(MessageModel(from: 1, message: text));
        _controller.clear();
      });
    }
  }

  Widget _buildChatBubble(MessageModel msg) {
    bool isSender = msg.from == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar kiri (dosen)
          if (!isSender)
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.dosen.avatar),
            ),
          if (!isSender) const SizedBox(width: 8),

          // Pesan
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isSender
                  ? const Color.fromARGB(255, 190, 56, 67)
                  : const Color.fromARGB(255, 234, 219, 219),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                )
              ],
            ),
            child: Text(
              msg.message,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),

          if (isSender) const SizedBox(width: 8),
          // Avatar kanan (user)
          if (isSender)
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('nasywa.jpg'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.dosen.avatar),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.dosen.fullName,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '6:30', // waktu aktif contoh
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                // aksi video call
              },
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // aksi call
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // aksi menu titik tiga
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.only(top: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color.fromARGB(255, 26, 33, 38),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
