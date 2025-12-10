import 'package:flutter/material.dart';

class Chat1 extends StatefulWidget {
  const Chat1({super.key});

  @override
  State<Chat1> createState() => _Chat1State();
}

class _Chat1State extends State<Chat1> {
  // قائمة الرسائل
  final List<Map<String, dynamic>> _messages = [
    {'text': 'مرحباً! كيف حالك؟', 'isMe': true, 'time': '10:00 ص'},
    {
      'text': 'أنا بخير، شكراً! وأنت كيف حالك؟',
      'isMe': false,
      'time': '10:01 ص',
    },
  ];

  // متحكم لحقل النص
  final TextEditingController _textController = TextEditingController();

  // متغير للتركيز على حقل النص
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // دالة لإرسال الرسالة
  void _sendMessage() {
    final text = _textController.text.trim();

    if (text.isEmpty) return;

    // الحصول على الوقت الحالي
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      // إضافة الرسالة الجديدة
      _messages.add({
        'text': text,
        'isMe': true, // هذه رسالة من المستخدم الحالي
        'time': time,
      });

      // مسح حقل النص
      _textController.clear();
    });

    // التمرير إلى آخر رسالة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // إعادة التركيز على حقل النص
    _focusNode.requestFocus();
  }

  // دالة للتمرير إلى آخر رسالة
  void _scrollToBottom() {
    // يمكنك إضافة ScrollController إذا أردت التحكم في التمرير
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 39, 50), // خلفية الشات
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 50, 67), // خلفية ال AppBar
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            SizedBox(width: 10),
            Text('اسم الشخص', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  text: message['text'],
                  isMe: message['isMe'],
                  time: message['time'],
                );
              },
            ),
          ),
          // حقل الإدخال وزر الإرسال
          _buildInputField(),
        ],
      ),
    );
  }

  // دالة لبناء حقل الإدخال
  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          // زر الإضافة للمرفقات
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // يمكنك إضافة خيارات المرفقات هنا
            },
          ),

          // حقل إدخال النص
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color.fromARGB(255, 41, 50, 67),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              style: TextStyle(color: Colors.white),
              onSubmitted: (value) {
                // إرسال الرسالة عند الضغط على زر الإدخال في الكيبورد
                _sendMessage();
              },
              textInputAction: TextInputAction.send,
            ),
          ),

          // زر الإرسال
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // دالة لبناء فقاعة الرسالة
  Widget _buildMessageBubble({
    required String text,
    required bool isMe,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Color.fromARGB(255, 21, 109, 150) // لون رسائلي
                    : Color.fromARGB(255, 41, 50, 67), // لون رسائل الآخرين
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isMe ? Radius.circular(20) : Radius.circular(4),
                  bottomRight: isMe ? Radius.circular(4) : Radius.circular(20),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
