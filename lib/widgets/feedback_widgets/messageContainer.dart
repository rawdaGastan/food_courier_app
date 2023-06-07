import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';

class MessageContainer extends StatelessWidget {
  final String text;
  final bool isMe;

  MessageContainer({
    @required this.text,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal!,
          bottom: 2 * SizeConfig.blockSizeHorizontal!,
          right: SizeConfig.blockSizeHorizontal!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical!),
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(20.0) : Radius.zero,
                topRight: isMe ? Radius.zero : Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.black12,
            ),
            padding:
                EdgeInsets.only(left: 8.0, right: 3.0, bottom: 3.0, top: 3.0),*/
            child: isMe
                ? Column(
                    children: [
                      ChatBubble(
                        clipper:
                            ChatBubbleClipper3(type: BubbleType.sendBubble),
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical!),
                        backGroundColor: blueTextColor,
                        child: Text(
                          '$text',
                          style: messageStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.blockSizeHorizontal!),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                            S().seen,
                            //'Read 16:26',
                            style: feedbackSeen,
                          ),
                        ),
                      ),
                    ],
                  )
                : ChatBubble(
                    clipper:
                        ChatBubbleClipper3(type: BubbleType.receiverBubble),
                    backGroundColor: msgContainerFromColor,
                    //margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical!),
                    child: Text(
                      '$text',
                      style: messageStyle.copyWith(color: Colors.black),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
