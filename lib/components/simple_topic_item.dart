import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/models/user.dart';
import 'package:flutter_cnode_app/utils/format_date.dart';

class SimpleTopicItem extends StatefulWidget {
  final Topic info;
  const SimpleTopicItem({super.key, required this.info});

  @override
  State<SimpleTopicItem> createState() => _SimpleTopicItemState();
}

class _SimpleTopicItemState extends State<SimpleTopicItem> {
  @override
  Widget build(BuildContext context) {
    final topic = widget.info;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/topic_detail', arguments: topic.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
                    "最后回复 ${formatDateAgo(topic.last_reply_at)}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
