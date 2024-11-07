import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';
import 'package:meread/ui/viewmodels/home_controller.dart';
import 'package:meread/ui/views/home/feed_list_view.dart';
import 'package:meread/ui/views/home/post_list_app_bar.dart';
import 'package:meread/ui/views/home/post_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      const feedListWidth = 304;
      const postListWidth = 300;
      const postWidth = 400;
      // 判断是否为手机, 不需要真的判断， 只判断宽度太小就用手机布局，
      bool isMobile = screenWidth < feedListWidth + postListWidth;
      c.isMobile.value = isMobile;
      // 是否使用侧边抽屉，不使用就是固定显示订阅列表，
      bool useDrawer =
          isMobile || screenWidth < feedListWidth + postListWidth + postWidth;
      c.useDrawer.value = useDrawer;
      if (isMobile) {
        return Scaffold(
          appBar: PostListAppBar.build(context),
          body: SafeArea(
            child: const MobileLayout(),
          ),
          drawerEdgeDragWidth: Get.width * 0.3,
          drawer: Drawer(
            child: SafeArea(
              child: const FeedListView(),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: PostListAppBar.build(context),
        body: SafeArea(
          child: const DesktopLayout(),
        ),
        drawer: useDrawer
            ? Drawer(
                child: SafeArea(
                  child: const FeedListView(),
                ),
              )
            : null,
      );
    });
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
  });
  HomeController get c => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => c.useDrawer.value
        ? const PostListView()
        : Row(
            children: [
              // 左侧固定显示原本 Drawer 的内容
              SizedBox(
                width: 304,
                child: const FeedListView(),
              ),
              // 主内容区域
              Expanded(
                child: const PostListView(),
              ),
            ],
          ));
  }
}

class MobileLayout extends StatefulWidget {
  const MobileLayout({
    super.key,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  HomeController get c => Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    if (PrefsHelper.refreshOnStartup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshKey.currentState?.show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: c.refreshPosts,
      child: const PostListView(),
    );
  }
}
