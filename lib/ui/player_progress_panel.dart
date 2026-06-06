import 'package:flutter/material.dart';

import '../data/player_profile_preferences.dart';
import '../data/player_progress_summary.dart';
import '../l10n/app_localizations.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    required this.strings,
    required this.profile,
  });

  final AppStrings strings;
  final PlayerProgressSummary profile;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  final PlayerProfilePreferences _preferences = PlayerProfilePreferences();
  late final Future<void> _loadAvatarFuture;
  int _selectedAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAvatarFuture = _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final index = await _preferences.loadAvatarIndex(widget.profile.userEmail);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedAvatarIndex = index.clamp(0, _avatarOptions.length - 1).toInt();
    });
  }

  Future<void> _selectAvatar(int index) async {
    setState(() {
      _selectedAvatarIndex = index;
    });
    await _preferences.saveAvatarIndex(widget.profile.userEmail, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.strings.profile),
        backgroundColor: const Color(0xFFF5F2EA),
        foregroundColor: const Color(0xFF263A36),
      ),
      backgroundColor: const Color(0xFFF5F2EA),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadAvatarFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _ProfileHeader(
                      strings: widget.strings,
                      profile: widget.profile,
                      avatar: _avatarOptions[_selectedAvatarIndex],
                    ),
                    const SizedBox(height: 12),
                    _StreakSection(
                      strings: widget.strings,
                      profile: widget.profile,
                    ),
                    const SizedBox(height: 12),
                    _AvatarSection(
                      strings: widget.strings,
                      selectedIndex: _selectedAvatarIndex,
                      onSelect: _selectAvatar,
                    ),
                    const SizedBox(height: 12),
                    _BadgeShowcaseSection(
                      strings: widget.strings,
                      profile: widget.profile,
                    ),
                    const SizedBox(height: 12),
                    _TasksSection(
                      strings: widget.strings,
                      profile: widget.profile,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.strings,
    required this.profile,
    required this.avatar,
  });

  final AppStrings strings;
  final PlayerProgressSummary profile;
  final _AvatarOption avatar;

  @override
  Widget build(BuildContext context) {
    final email = profile.userEmail?.trim();
    return _ProfileSection(
      child: Row(
        children: [
          _AvatarCircle(avatar: avatar, size: 72, iconSize: 38),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF263A36),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (email != null && email.isNotEmpty)
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF69736F),
                    ),
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricPill(
                      icon: Icons.flag_outlined,
                      label:
                          '${profile.completedLevels}/${profile.totalLevels} ${strings.completedLevels}',
                    ),
                    _MetricPill(
                      icon: Icons.workspace_premium_outlined,
                      label:
                          '${profile.unlockedBadges}/${profile.badges.length} ${strings.myBadges}',
                    ),
                    _MetricPill(
                      icon: Icons.local_fire_department_outlined,
                      label:
                          '${profile.streak.currentStreak} ${strings.dayLabel} ${strings.studyStreak}',
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
}

class _StreakSection extends StatelessWidget {
  const _StreakSection({required this.strings, required this.profile});

  final AppStrings strings;
  final PlayerProgressSummary profile;

  @override
  Widget build(BuildContext context) {
    final streak = profile.streak;
    final today = DateTime.now();
    final recentDays = [
      for (var offset = 6; offset >= 0; offset--)
        DateTime(
          today.year,
          today.month,
          today.day,
        ).subtract(Duration(days: offset)),
    ];
    final activeToday = streak.hasActivityOn(today);

    return _ProfileSection(
      title: strings.studyStreak,
      icon: Icons.local_fire_department_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricPill(
                icon: Icons.local_fire_department,
                label:
                    '${strings.currentStreak}: ${streak.currentStreak} ${strings.dayLabel}',
              ),
              _MetricPill(
                icon: Icons.emoji_events_outlined,
                label:
                    '${strings.longestStreak}: ${streak.longestStreak} ${strings.dayLabel}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                activeToday ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color:
                    activeToday
                        ? const Color(0xFF2D736A)
                        : const Color(0xFF8A8174),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  activeToday
                      ? strings.streakActiveToday
                      : strings.streakNeedsLesson,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF3F524E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.recentDays,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF263A36),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final day in recentDays)
                _StreakDayDot(
                  date: day,
                  active: streak.hasActivityOn(day),
                  today: _sameDate(day, today),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.strings,
    required this.selectedIndex,
    required this.onSelect,
  });

  final AppStrings strings;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: strings.profilePicture,
      icon: Icons.image_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.chooseProfilePicture,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF69736F),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var index = 0; index < _avatarOptions.length; index++)
                _AvatarChoice(
                  avatar: _avatarOptions[index],
                  selected: index == selectedIndex,
                  onTap: () => onSelect(index),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeShowcaseSection extends StatelessWidget {
  const _BadgeShowcaseSection({required this.strings, required this.profile});

  final AppStrings strings;
  final PlayerProgressSummary profile;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: strings.badgeShowcase,
      icon: Icons.workspace_premium_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileWidth = constraints.maxWidth < 520 ? 150.0 : 170.0;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final badge in profile.badges)
                SizedBox(
                  width: tileWidth,
                  child: _BadgeTile(
                    strings: strings,
                    badge: badge,
                    onTap: () => _showBadgeRequirement(context, strings, badge),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TasksSection extends StatelessWidget {
  const _TasksSection({required this.strings, required this.profile});

  final AppStrings strings;
  final PlayerProgressSummary profile;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: strings.tasks,
      icon: Icons.assignment_turned_in_outlined,
      child: Column(
        children: [
          for (var index = 0; index < profile.tasks.length; index++) ...[
            _TaskRow(strings: strings, task: profile.tasks[index]),
            if (index < profile.tasks.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({this.title, this.icon, required this.child});

  final String? title;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0D6C8)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  Icon(icon, size: 19, color: const Color(0xFF2D736A)),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF263A36),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.avatar,
    required this.selected,
    required this.onTap,
  });

  final _AvatarOption avatar;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: avatar.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 58,
          height: 58,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE8F5F1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  selected ? const Color(0xFF3A8F86) : const Color(0xFFE0D6C8),
              width: selected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Center(child: _AvatarCircle(avatar: avatar)),
              if (selected)
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF2D736A),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.avatar,
    this.size = 44,
    this.iconSize = 24,
  });

  final _AvatarOption avatar;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatar.background,
        shape: BoxShape.circle,
      ),
      child: Icon(avatar.icon, color: avatar.foreground, size: iconSize),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.strings,
    required this.badge,
    required this.onTap,
  });

  final AppStrings strings;
  final PlayerBadgeProgress badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.unlocked;
    final color = unlocked ? const Color(0xFFB36B00) : const Color(0xFF8A8174);
    final background =
        unlocked ? const Color(0xFFFFF3D7) : const Color(0xFFF0ECE4);
    return Tooltip(
      message: _badgeRequirement(badge.id, strings),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 126),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  unlocked ? const Color(0xFFFFC75A) : const Color(0xFFD8D0C4),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_badgeIcon(badge.id, unlocked), color: color, size: 30),
              const SizedBox(height: 10),
              Text(
                _badgeTitle(badge.id, strings),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF263A36),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                unlocked
                    ? strings.earned
                    : '${strings.lockedBadge} ${badge.currentValue}/${badge.targetValue}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.strings, required this.task});

  final AppStrings strings;
  final PlayerTaskProgress task;

  @override
  Widget build(BuildContext context) {
    final color =
        task.completed ? const Color(0xFF2D736A) : const Color(0xFF8A8174);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              task.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                _taskTitle(task.id, strings),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF263A36),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${task.currentValue}/${task.targetValue}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            minHeight: 5,
            value: task.fraction,
            backgroundColor: const Color(0xFFECE6DA),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCDE5DD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2D736A)),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF263A36),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakDayDot extends StatelessWidget {
  const _StreakDayDot({
    required this.date,
    required this.active,
    required this.today,
  });

  final DateTime date;
  final bool active;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final foreground =
        active ? const Color(0xFFB36B00) : const Color(0xFF8A8174);
    final background =
        active ? const Color(0xFFFFF3D7) : const Color(0xFFF0ECE4);
    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              today
                  ? const Color(0xFF3A8F86)
                  : active
                  ? const Color(0xFFFFC75A)
                  : const Color(0xFFD8D0C4),
          width: today ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.local_fire_department : Icons.circle_outlined,
            size: 18,
            color: foreground,
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}/${date.month}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

void _showBadgeRequirement(
  BuildContext context,
  AppStrings strings,
  PlayerBadgeProgress badge,
) {
  showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(_badgeTitle(badge.id, strings)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.badgeRequirementTitle,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(_badgeRequirement(badge.id, strings)),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value:
                    badge.targetValue <= 0
                        ? 1
                        : (badge.currentValue / badge.targetValue)
                            .clamp(0.0, 1.0)
                            .toDouble(),
                backgroundColor: const Color(0xFFECE6DA),
                valueColor: AlwaysStoppedAnimation<Color>(
                  badge.unlocked
                      ? const Color(0xFF3A8F86)
                      : const Color(0xFF8A8174),
                ),
              ),
              const SizedBox(height: 8),
              Text('${badge.currentValue}/${badge.targetValue}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.close),
            ),
          ],
        ),
  );
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _taskTitle(PlayerTaskId id, AppStrings strings) {
  return switch (id) {
    PlayerTaskId.signIn => strings.signedInTask,
    PlayerTaskId.completeTwoLevels => strings.completeTwoLevelsTask,
    PlayerTaskId.completeFourLevels => strings.completeFourLevelsTask,
    PlayerTaskId.completeAllLevels => strings.completeAllLevelsTask,
  };
}

String _badgeTitle(PlayerBadgeId id, AppStrings strings) {
  return switch (id) {
    PlayerBadgeId.completeTwoTasks => strings.twoTasksBadge,
    PlayerBadgeId.completeFourTasks => strings.fourTasksBadge,
    PlayerBadgeId.completeAllLevels => strings.allLevelsBadge,
  };
}

String _badgeRequirement(PlayerBadgeId id, AppStrings strings) {
  return switch (id) {
    PlayerBadgeId.completeTwoTasks => strings.twoTasksBadgeRequirement,
    PlayerBadgeId.completeFourTasks => strings.fourTasksBadgeRequirement,
    PlayerBadgeId.completeAllLevels => strings.allLevelsBadgeRequirement,
  };
}

IconData _badgeIcon(PlayerBadgeId id, bool unlocked) {
  if (!unlocked) {
    return Icons.lock_outline;
  }
  return switch (id) {
    PlayerBadgeId.completeTwoTasks => Icons.workspace_premium,
    PlayerBadgeId.completeFourTasks => Icons.military_tech,
    PlayerBadgeId.completeAllLevels => Icons.emoji_events,
  };
}

class _AvatarOption {
  const _AvatarOption({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
}

const _avatarOptions = [
  _AvatarOption(
    label: 'Terminal',
    icon: Icons.terminal,
    background: Color(0xFFE8F5F1),
    foreground: Color(0xFF2D736A),
  ),
  _AvatarOption(
    label: 'Router',
    icon: Icons.router,
    background: Color(0xFFEAF0FF),
    foreground: Color(0xFF365FA8),
  ),
  _AvatarOption(
    label: 'Shield',
    icon: Icons.security,
    background: Color(0xFFFFF3D7),
    foreground: Color(0xFFB36B00),
  ),
  _AvatarOption(
    label: 'Code',
    icon: Icons.code,
    background: Color(0xFFF0ECE4),
    foreground: Color(0xFF6D5C46),
  ),
  _AvatarOption(
    label: 'Network',
    icon: Icons.hub_outlined,
    background: Color(0xFFE9F7FF),
    foreground: Color(0xFF147391),
  ),
  _AvatarOption(
    label: 'Star',
    icon: Icons.star,
    background: Color(0xFFFFE9EE),
    foreground: Color(0xFFB53B59),
  ),
];
