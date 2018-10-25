/// 煎蛋图片数据
class EggData {
  String status;
  int currentPage;
  int totalComments;
  int pageCount;
  int count;
  List<EggComments> comments;

  EggData(
      {this.status,
      this.currentPage,
      this.totalComments,
      this.pageCount,
      this.count,
      this.comments});

  EggData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    currentPage = json['current_page'];
    totalComments = json['total_comments'];
    pageCount = json['page_count'];
    count = json['count'];
    if (json['comments'] != null) {
      comments = new List<EggComments>();
      json['comments'].forEach((v) {
        comments.add(new EggComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['current_page'] = this.currentPage;
    data['total_comments'] = this.totalComments;
    data['page_count'] = this.pageCount;
    data['count'] = this.count;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EggComments {
  String commentID;
  String commentPostID;
  String commentAuthor;
  String commentDate;
  String commentDateGmt;
  String commentContent;
  String userId;
  String votePositive;
  String voteNegative;
  String subCommentCount;
  String textContent;
  List<String> pics;

  EggComments(
      {this.commentID,
      this.commentPostID,
      this.commentAuthor,
      this.commentDate,
      this.commentDateGmt,
      this.commentContent,
      this.userId,
      this.votePositive,
      this.voteNegative,
      this.subCommentCount,
      this.textContent,
      this.pics});

  EggComments.fromJson(Map<String, dynamic> json) {
    commentID = json['comment_ID'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    userId = json['user_id'];
    votePositive = json['vote_positive'];
    voteNegative = json['vote_negative'];
    subCommentCount = json['sub_comment_count'];
    textContent = json['text_content'];
    pics = json['pics'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_ID'] = this.commentID;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['user_id'] = this.userId;
    data['vote_positive'] = this.votePositive;
    data['vote_negative'] = this.voteNegative;
    data['sub_comment_count'] = this.subCommentCount;
    data['text_content'] = this.textContent;
    data['pics'] = this.pics;
    return data;
  }
}
