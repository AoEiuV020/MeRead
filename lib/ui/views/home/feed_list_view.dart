import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/ui/viewmodels/home_controller.dart';

class FeedListView extends StatelessWidget {
  const FeedListView({
    super.key,
  });

  HomeController get c => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: ListTile(
              title: Text('allFeeds'.tr),
              onTap: c.focusAllFeeds,
              tileColor: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withAlpha(80),
              visualDensity: VisualDensity.compact,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                for (Feed feed in c.feeds)
                  InkWell(
                    onSecondaryTapUp: (details) {
                      _showMenu(context, feed, details.globalPosition);
                    },
                    onTap: () => c.focusFeed(feed),
                    onLongPress: () => c.toEditFeed(feed),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(feed == c.feeds.first ? 24 : 0),
                        bottom: Radius.circular(feed == c.feeds.last ? 24 : 0),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        feed.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                          feed.post.where((p) => !p.read).length.toString()),
                      tileColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(80),
                      mouseCursor: SystemMouseCursors.click,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context, Feed feed, Offset position) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position:
          RelativeRect.fromSize(position & Size(48.0, 48.0), overlay.size),
      items: [
        PopupMenuItem(
          value: 1,
          child: Text('refresh'.tr),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('editFeed'.tr),
        ),
        PopupMenuItem(
          value: 3,
          child: Text('markAllAsRead'.tr),
        ),
      ],
    ).then((value) {
      if (value == null) return;
      if (value == 1) {
        c.refreshFeed(feed);
      } else if (value == 2) {
        c.toEditFeed(feed);
      } else if (value == 3) {
        c.markFeedRead(feed);
      }
    });
  }
}
