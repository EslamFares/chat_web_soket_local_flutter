import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDemo extends StatefulWidget {
  const WebSocketDemo({super.key});

  @override
  WebSocketDemoState createState() => WebSocketDemoState();
}

class WebSocketDemoState extends State<WebSocketDemo> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for incoming messages from the server
    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
      // Scroll to the bottom after adding a new message
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    // Scroll to the bottom of the ListView
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent +
          (_messages.length > 5 ? 90 : 0), //70 for textfield height
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket Client')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  MassageContainer(messages: _messages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class MassageContainer extends StatelessWidget {
  const MassageContainer({super.key, required this.messages});
  final String messages;

  @override
  Widget build(BuildContext context) {
    final msg = messages.split("at")[0];
    final msgSender = msg.split(":")[0];
    final msgConatinet = msg.split(":")[1];
    final time = messages.split("at")[1];
    return Column(
      crossAxisAlignment: messages.contains("Server received:")
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color:
                  msg.contains("Server received:") ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$msgSender:"),
              Text(msgConatinet),
              Text(time),
            ],
          ),
        ),
      ],
    );
  }
}
