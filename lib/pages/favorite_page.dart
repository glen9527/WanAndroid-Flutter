import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid_flutter/models/article.dart';
import 'package:wanandroid_flutter/pages/webview_page.dart';
import 'package:wanandroid_flutter/widgets/article_item.dart';
import 'package:wanandroid_flutter/widgets/gradient_appbar.dart';
import 'package:wanandroid_flutter/http/http.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/models/article_response.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoritePageState();
  }
}

class FavoritePageState extends State<FavoritePage> {
  double screenWidth = 0;
  List<Article> articleList = new List();
  List<String> list = new List();
  int currentPage = 0;
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    loadFavorites(currentPage);
  }

  void loadFavorites(int page) async {
    var result = await HttpClient.getInstance()
        .get(Api.FAVORITE_LIST, data: {"page": page});
    if (result != null) {
      ArticleResponse articleResponse = ArticleResponse.fromJson(result);
      List<Article> articles = articleResponse.datas;
      if (page == 0) {
        articleList.clear();
      }
      setState(() {
        articleList.addAll(articles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("收藏"),
      ),
      body: EasyRefresh(
        header: ClassicalHeader(),
        footer: ClassicalFooter(
          noMoreText: "到底了",
        ),
        onRefresh: () async {},
        onLoad: () async {},
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return createFavoriteListItem(context, index);
          },
          separatorBuilder: (context, index) {
            return Divider(
              indent: 12,
              endIndent: 12,
              height: 0.5,
            );
          },
          itemCount: articleList.length,
        ),
      ),
    );
  }

  createFavoriteListItem(BuildContext context, int index) {
    Article article = articleList[index];
    String author;
    if (article.author != null) {
      author = article.author;
    } else if (article.shareUser != null) {
      author = article.shareUser;
    } else {
      author = "";
    }
    return Slidable(
      // slidableController 控制只有一个 slidable 处于打开状态
      controller: slidableController,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: ArticleItem(
        article.title,
        article.niceDate,
        author,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                url: article.link,
              ),
            ),
          );
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _cancelFavorite(index),
        ),
      ],
    );
  }

  /// 取消收藏
  _cancelFavorite(int index) async {
    Article article = articleList[index];
    var result = await HttpClient.getInstance().post(
        Api.UNCOLLECT_LIST + "${article.id}/json",
        data: {"originId": "-1"});
    setState(() {
      articleList.removeAt(index);
    });
  }
}
