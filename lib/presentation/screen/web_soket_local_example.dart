import 'package:flutter/material.dart';
import 'package:try_web_socket_local/models/msg_model.dart';
import 'package:try_web_socket_local/presentation/wigets/massage_container.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDemo extends StatefulWidget {
  const WebSocketDemo({super.key});

  @override
  WebSocketDemoState createState() => WebSocketDemoState();
}

class WebSocketDemoState extends State<WebSocketDemo> {
  String androidLink = "ws://192.168.2.1:8080";
  String iosLink = "ws://localhost:8080";
  final _channel = WebSocketChannel.connect(Uri.parse("ws://192.168.2.1:8080"));
  final TextEditingController _controller = TextEditingController();
  final List<MsgModel> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for incoming messages from the server
    _channel.stream.listen((message) {
      debugPrint('message: $message');
      setState(() {
        _messages.add(MsgModel.fromJson(message));
      });
      // Scroll to the bottom after adding a new message
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _controller.text.trim() != '') {
      _channel.sink.add(_controller.text.trim());
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    // Scroll to the bottom of the ListView
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent +
          (_messages.length > 5 ? 120 : 0), //120 for textfield height
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
                  MassageContainer(msgModel: _messages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 2,
                    controller: _controller,
                    decoration: const InputDecoration(
                        labelText: 'Enter message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
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
