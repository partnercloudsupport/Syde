

class Story{

  String storyTitle,storyBody,storyId,timeStamp;
  int likeCount,commentCount;
  Map user;


  Story(this.storyTitle, this.storyBody, this.storyId, this.timeStamp,
      this.likeCount, this.commentCount, this.user);

   Story.fromMap(Map story){

    storyTitle = "Not Available";
    storyBody = story["post_body"];
    storyId = story["post_id"];
    timeStamp = story["time_stamp"];
    user = story["user"];
    likeCount = story["like_count"];
    commentCount = story["commentCount"];

//    heb 9:14
//     heb 10:2

  }


}