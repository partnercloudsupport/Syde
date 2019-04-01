

class Comment{

  String commentBody,commentId,userId,timeStamp;

  Comment({this.commentBody, this.commentId, this.userId, this.timeStamp});



  Map toMap(){

    return {
      "comment_body":commentBody,
      "comment_id" : commentId,
      "time_stamp" : timeStamp,
      "user_id" : userId
    };
  }


}