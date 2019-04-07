
class Comment {
  String commentBody, commentId, userId, timeStamp;

  Comment({this.commentBody, this.commentId, this.userId, this.timeStamp});

  factory Comment.fromMap(Map comment) {
    return Comment(
      commentBody: comment["comment_body"],
      commentId: comment["comment_id"],
      timeStamp: comment["time_stamp"],
      userId: comment["user_id"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "comment_body": commentBody,
      "comment_id": commentId,
      "time_stamp": timeStamp,
      "user_id": userId
    };
  }
}
