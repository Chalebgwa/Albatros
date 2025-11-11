import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Screen displaying all missions and their progress
class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final activeMissions = provider.activeMissions;
    final completedMissions = provider.completedMissions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Active',
                    activeMissions.length.toString(),
                    Icons.flag,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    context,
                    'Completed',
                    completedMissions.length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _buildStatItem(
                    context,
                    'Points',
                    provider.userProgress.totalPoints.toString(),
                    Icons.star,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Active Missions
          if (activeMissions.isNotEmpty) ...[
            Text(
              'Active Missions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...activeMissions.map((mission) => _MissionCard(mission: mission)),
            const SizedBox(height: 24),
          ],
          
          // Completed Missions
          if (completedMissions.isNotEmpty) ...[
            Text(
              'Completed Missions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...completedMissions.map((mission) => _MissionCard(mission: mission)),
          ],
          
          // Empty State
          if (activeMissions.isEmpty && completedMissions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No missions available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MissionCard extends StatelessWidget {
  final dynamic mission;

  const _MissionCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    final progress = mission.progress.clamp(0.0, 1.0);
    final isCompleted = mission.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMissionIcon(mission.type.toString()),
                  color: isCompleted ? Colors.green : Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    '+${mission.rewardPoints}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  avatar: const Icon(Icons.star, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${mission.currentProgress}/${mission.targetValue}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Completed!',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getMissionIcon(String type) {
    if (type.contains('daily')) return Icons.today;
    if (type.contains('weekly')) return Icons.calendar_week;
    if (type.contains('landmark')) return Icons.location_on;
    if (type.contains('special')) return Icons.star;
    return Icons.flag;
  }
}
