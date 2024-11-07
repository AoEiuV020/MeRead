import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/ui/viewmodels/home_controller.dart';

class PostListAppBar {
  static AppBar build(BuildContext context) {
    final c = Get.find<HomeController>();
    return AppBar(
      title: Obx(() => Text(
            c.appBarTitle.value,
          )),
      centerTitle: false,
      actions: [
        /* 未读筛选 */
        IconButton(
          onPressed: c.filterUnread,
          icon: Obx(() => c.onlyUnread.value
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_unchecked)),
        ),
        /* 收藏筛选 */
        IconButton(
          onPressed: c.filterFavorite,
          icon: Obx(() => c.onlyFavorite.value
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border_outlined)),
        ),
        PopupMenuButton(
          elevation: 1,
          position: PopupMenuPosition.under,
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              /* 全标已读 */
              PopupMenuItem(
                onTap: c.markAllRead,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.done_all_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text('markAllAsRead'.tr),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 0),
              /* 全文搜索 */
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text('fullTextSearch'.tr),
                  ],
                ),
              ),
              /* 添加订阅源 */
              PopupMenuItem(
                onTap: c.toAddFeed,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text('addFeed'.tr),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 0),
              /* 设置 */
              PopupMenuItem(
                onTap: c.toSetting,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.settings_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text('moreSettings'.tr),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
