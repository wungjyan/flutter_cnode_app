import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/user.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/models/user.dart';
import 'package:flutter_cnode_app/store/user_manage.dart';
import 'package:flutter_cnode_app/store/token_manage.dart';
import 'package:flutter_cnode_app/utils/format_date.dart';
import 'package:flutter_cnode_app/utils/toast.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  UserDetail? userDetail = UserDetail(
    loginname: '',
    avatar_url: '',
    githubUsername: '',
    score: 0,
    create_at: DateTime.now(),
    recent_topics: [],
    recent_replies: [],
  );

  Future<void> _handleLogout() async {
    await TokenManage.removeToken();
    await UserManage.removeUserInfo();
    if (!mounted) return;
    setState(() {
      userDetail = UserDetail(
        loginname: '',
        avatar_url: '',
        githubUsername: '',
        score: 0,
        create_at: DateTime.now(),
        recent_topics: [],
        recent_replies: [],
      );
    });
    ToastUtils.showSuccess(context, '已退出登录');
  }

  Future<void> _fetchUserDetail() async {
    final cached = await UserManage.getUserInfo();
    final loginname = cached?['loginname'] as String? ?? '';
    if (loginname.isEmpty) return;
    final res = await getUserDetail(loginname);
    if (!mounted) return;
    if (res is String) {
      ToastUtils.showError(context, res);
      return;
    }
    setState(() {
      userDetail = res as UserDetail;
    });
  }

  Widget _buildTopicList(List<Topic> list) {
    final display = list.length > 3 ? list.sublist(0, 3) : list;
    return Column(
      children: display.map((topic) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.hardEdge,
                child: topic.author.avatar_url.isNotEmpty
                    ? Image.network(
                        topic.author.avatar_url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'lib/assets/images/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                      )
                    : Image.asset(
                        'lib/assets/images/default_avatar.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDateAgo(topic.last_reply_at),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    final detail = userDetail;
    final isLoggedIn = detail != null && detail.loginname.isNotEmpty;

    if (!isLoggedIn) {
      return Center(
        child: GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/login');
            if (result == true) {
              await _fetchUserDetail();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "点击登录",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final recentTopics = detail.recent_topics;
    final recentReplies = detail.recent_replies;
    final theme = Theme.of(context);

    // 用户信息模块
    Widget buildUserInfo() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              clipBehavior: Clip.hardEdge,
              child: detail.avatar_url.isNotEmpty
                  ? Image.network(
                      detail.avatar_url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'lib/assets/images/default_avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'lib/assets/images/default_avatar.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.loginname,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (detail.githubUsername.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.alternate_email,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          detail.githubUsername,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${detail.score} 积分',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '注册于 ${formatDateAgo(detail.create_at)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: _fetchUserDetail,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildUserInfo(),
                    const SizedBox(height: 16),
                    if (recentTopics.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 18,
                                  color: GlobalConstants.primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '最近创建的话题',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTopicList(recentTopics),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '查看更多 »',
                                style: TextStyle(
                                  color: GlobalConstants.primaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (recentReplies.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 18,
                                  color: GlobalConstants.primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '最近参与的话题',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTopicList(recentReplies),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '查看更多 »',
                                style: TextStyle(
                                  color: GlobalConstants.primaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (recentTopics.isEmpty && recentReplies.isEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '暂无话题记录',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.black26),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _handleLogout,
                        child: const Text(
                          '退出登录',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
