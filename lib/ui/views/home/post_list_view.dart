import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/models/post.dart';
import 'package:meread/ui/viewmodels/home_controller.dart';
import 'package:meread/ui/widgets/post_card.dart';


class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
  });

  HomeController get c => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        physics: c.postList.isEmpty
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        itemBuilder: (context, index) {
          return SwipeActionCell(
            key: ObjectKey(c.postList[index]),
            trailingActions: [
              SwipeAction(
                color: Colors.transparent,
                content: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: Icon(
                    Icons.done_outline_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer,
                  ),
                ),
                onTap: (handler) async {
                  final Post post = c.postList[index];
                  post.read = !post.read;
                  IsarHelper.putPost(post);
                  await handler(false);
                },
              ),
            ],
            child: InkWell(
              onTap: () {
                c.openPost(index).then((_) {
                  c.getPosts();
                });
              },
              child: PostCard(post: c.postList[index]),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: c.postList.length,
      ),
    );
  }
}
