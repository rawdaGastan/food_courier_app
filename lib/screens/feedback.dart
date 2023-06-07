import 'package:flutter/material.dart';
import 'package:foodCourier/constants/decorations.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/feedback_widgets/feedbackReview.dart';
import 'package:foodCourier/widgets/feedback_widgets/messageContainer.dart';
import 'package:foodCourier/generated/l10n.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  List<Widget> messageList = [];
  final inputController = TextEditingController();
  String messageText;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  addMessage(message, isMe) {
    inputController.clear();
    Widget messageContainer = new MessageContainer(
      text: message,
      isMe: isMe,
    );
    messageList.insert(0, messageContainer);
  }

  addMessageToChat() {
    inputController.clear();
  }

  @override
  void initState() {
    super.initState();
    addMessage('always glad to help, tell me what\'s wrong', true);
    addMessage('you\'re doing great job but i have some issue', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
            size: 6 * SizeConfig.blockSizeHorizontal,
          ),
        ),
        centerTitle: true,
        title: Text(
          S().feedback,
          style: titleText,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.error_outline, color: lightTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 2 * SizeConfig.blockSizeVertical,
                bottom: SizeConfig.blockSizeVertical,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(style: feedbackDay, text: S().dayFeedback
                            //'Tuesday  '
                            ),
                        TextSpan(style: feedbackTime, text: S().timeFeedback
                            //'20:21'
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //MessagesStream(),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.blockSizeVertical),
                color: whiteColor,
                child: ListView(
                  key: UniqueKey(),
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                      vertical: 2 * SizeConfig.blockSizeVertical),
                  children: messageList,
                ),
              ),
            ),
            FeedbackReview(),
            Container(
              color: secondaryColor,
              height: 8 * SizeConfig.blockSizeVertical,
              margin: EdgeInsets.only(
                  bottom: 2 * SizeConfig.blockSizeVertical,
                  right: 2 * SizeConfig.blockSizeVertical,
                  left: 2 * SizeConfig.blockSizeVertical),
              padding: EdgeInsets.only(
                  left: 4 * SizeConfig.blockSizeHorizontal,
                  top: 1.5 * SizeConfig.blockSizeVertical,
                  bottom: 1.5 * SizeConfig.blockSizeVertical,
                  right: 2 * SizeConfig.blockSizeHorizontal),
              //decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      cursorColor: whiteColor,
                      controller: inputController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: feedbackInput,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Transform.rotate(
                    angle: 315 * 3.14 / 180,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          addMessage(messageText, true);
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: blueTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//class MessagesStream extends StatelessWidget {
//
//  StreamController _streamController;
//  Stream _stream;
//  bool isLoading = false;
//
//  @override
//  void initState() {
//    _streamController = StreamController();
//    _stream = _streamController.stream;
//    Future.delayed(Duration.zero, this.getDataFromProvider);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      stream:
//      builder: (context , snapshot){
//        if (!snapshot.hasData){
//          return Center(
//            child: CircularProgressIndicator(
//              backgroundColor: Colors.lightBlueAccent,
//            ),
//          );
//        }
//        final documents = snapshot.data.documents;
//        List<MessageContainer> chatMessages = [] ;
//        for(var document in documents){
//          final message = document.data['message'];
//          final sender = document.data['sender'];
//          final messageTime = document.data["time"];
//          final messageWidget = MessageContainer(
//            text: message,
//            time: messageTime,
//            isMe: loggedInUser.email == sender ,
//          );
//          chatMessages.add(messageWidget);
//          chatMessages.sort((a , b) => b.time.compareTo(a.time));
//        }
//        return Expanded(
//          child: ListView(
//            reverse: true,
//            children: chatMessages,
//          ),
//        );
//      },
//    );
//  }
//}
