import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Screen displaying earned and available badges
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final badges = provider.badges;
    final earnedBadges = provider.earnedBadges;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 48,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${earnedBadges.length} / ${badges.length}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text('Badges Earned'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: badges.isEmpty ? 0 : earnedBadges.length / badges.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Badges Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _BadgeCard(badge: badge);
            },
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final dynamic badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    final isEarned = badge.isEarned;

    return Card(
      elevation: isEarned ? 4 : 1,
      child: InkWell(
        onTap: () => _showBadgeDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 64,
                    color: isEarned ? _getBadgeColor(badge.type.toString()) : Colors.grey[300],
                  ),
                  if (!isEarned)
                    Icon(
                      Icons.lock,
                      size: 24,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? Colors.black87 : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEarned ? 'Earned!' : '${badge.requiredPoints} pts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isEarned ? Colors.green : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: badge.isEarned 
                  ? _getBadgeColor(badge.type.toString()) 
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(badge.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description),
            const SizedBox(height: 16),
            if (badge.isEarned)
              Text(
                'Earned on ${_formatDate(badge.earnedDate)}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                'Required: ${badge.requiredPoints} points',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String type) {
    if (type.contains('achievement')) return Colors.blue;
    if (type.contains('streak')) return Colors.orange;
    if (type.contains('landmark')) return Colors.green;
    if (type.contains('master')) return Colors.purple;
    return Colors.grey;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}
