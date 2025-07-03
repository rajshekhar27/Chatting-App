import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/APIs/Apis.dart';
import 'package:we_chat/Models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  late Size mq;

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Card(

      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan.shade300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height*0.3),
                child: CachedNetworkImage(
                  imageUrl: "${widget.user.image}",
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.black,),
                ),
              ),
            ),
            title: Text(widget.user.name.toString()),
            subtitle: Text(widget.user.about.toString(), maxLines: 1, ),
            trailing: Container(
              height: mq.height*0.01,
              width: mq.width*0.02,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mq.height*0.005),
                color: Colors.green.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
