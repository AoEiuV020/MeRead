import 'package:isar/isar.dart';
import 'package:meread/models/folder.dart';
import 'package:meread/models/post.dart';

part 'feed.g.dart';

/// 定义 Feed 类
@collection
class Feed {
  Id? id = Isar.autoIncrement;
  String title; // 订阅源名称
  String url; // 订阅源地址
  String description; // 订阅源描述
  bool fullText; // 是否全文
  int openType; // 打开方式：0-阅读器 1-内置标签页 2-系统浏览器
  DateTime createdAt; // 创建时间
  final folder = IsarLink<Folder>(); // 订阅源分类
  @Backlink(to: 'feed')
  final post = IsarLinks<Post>();

  Feed({
    this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.fullText,
    required this.openType,
    required this.createdAt,
  });
}
