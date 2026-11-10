import 'package:flutter/material.dart';

void main() => runApp(const GardenDiaryApp());

class GardenDiaryApp extends StatelessWidget {
  const GardenDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF214B38);
    return MaterialApp(
      title: 'Home Gardening Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F6F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          primary: forest,
          surface: const Color(0xFFF7F6F0),
        ),
        fontFamily: 'Roboto',
      ),
      home: const GardenShell(),
    );
  }
}

class GardenShell extends StatefulWidget {
  const GardenShell({super.key});

  @override
  State<GardenShell> createState() => _GardenShellState();
}

class _GardenShellState extends State<GardenShell> {
  int index = 0;
  final pages = const [HomePage(), PlantsPage(), CalendarPage(), JournalPage()];
  final titles = const [
    'My garden',
    'My plants',
    'Garden calendar',
    'Garden diary',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFF7F6F0),
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titles[index],
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 21,
              color: Color(0xFF203B2D),
            ),
          ),
          const Text(
            'A little green, every day',
            style: TextStyle(fontSize: 12, color: Color(0xFF788278)),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _notice(context, 'You’re all caught up!'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 18),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFDCE8D5),
            child: Icon(Icons.person_outline, color: Color(0xFF31543D)),
          ),
        ),
      ],
    ),
    body: IndexedStack(index: index, children: pages),
    floatingActionButton: index == 0
        ? FloatingActionButton.extended(
            onPressed: () => _notice(
              context,
              'Planting a new seedling is a lovely place to start.',
            ),
            backgroundColor: const Color(0xFF28563E),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Add entry',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE5EEDF),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          selectedIcon: Icon(Icons.space_dashboard_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.eco_outlined),
          selectedIcon: Icon(Icons.eco_rounded),
          label: 'Plants',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month_rounded),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: 'Diary',
        ),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 104),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: const Color(0xFF244D39),
          gradient: const LinearGradient(
            colors: [Color(0xFF315F46), Color(0xFF1E4432)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFFFFD987),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'MONDAY, NOVEMBER 10',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .8),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Good morning,\ngarden friend 🌱',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                height: 1.13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your plants are growing beautifully. Here’s what they need today.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .82),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const _MiniStat(
                  icon: Icons.grass_rounded,
                  value: '12',
                  label: 'plants',
                ),
                Container(
                  width: 1,
                  height: 38,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                ),
                const _MiniStat(
                  icon: Icons.water_drop_outlined,
                  value: '3',
                  label: 'to water',
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 26),
      const _SectionHeading(
        title: 'Today in your garden',
        action: 'See calendar',
      ),
      const SizedBox(height: 12),
      _TaskCard(
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF5B9CA0),
        title: 'Water your plants',
        subtitle: '3 plants are ready for a drink',
        trailing: '10 min',
      ),
      const SizedBox(height: 10),
      _TaskCard(
        icon: Icons.content_cut_rounded,
        color: const Color(0xFFD49248),
        title: 'Prune basil leaves',
        subtitle: 'Keep your herbs bushy & happy',
        trailing: '5 min',
      ),
      const SizedBox(height: 26),
      const _SectionHeading(title: 'Growing right now', action: 'All plants'),
      const SizedBox(height: 12),
      SizedBox(
        height: 188,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            _PlantCard(
              emoji: '🍅',
              name: 'Cherry tomato',
              detail: 'Vegetable · 24 days',
              progress: .72,
              tint: Color(0xFFF3E6D8),
            ),
            SizedBox(width: 12),
            _PlantCard(
              emoji: '🌿',
              name: 'Sweet basil',
              detail: 'Herb · 18 days',
              progress: .48,
              tint: Color(0xFFE5EEDC),
            ),
            SizedBox(width: 12),
            _PlantCard(
              emoji: '🌻',
              name: 'Sunflower',
              detail: 'Flower · 32 days',
              progress: .86,
              tint: Color(0xFFF4EDCE),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFECEFE5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Text('💡', style: TextStyle(fontSize: 26)),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Garden tip of the day',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF294833),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Water in the early morning to help your plants beat the afternoon heat.',
                    style: TextStyle(
                      height: 1.4,
                      color: Color(0xFF647365),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: const Color(0xFFCEE1B9), size: 21),
      const SizedBox(width: 8),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: .78),
          fontSize: 12,
        ),
      ),
    ],
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.action});
  final String title, action;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF25392D),
        ),
      ),
      TextButton(
        onPressed: () => _notice(context, '$action coming up in your garden'),
        child: Text(
          action,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    ],
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });
  final IconData icon;
  final Color color;
  final String title, subtitle, trailing;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E4034),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF858E85)),
              ),
            ],
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFF788278),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({
    required this.emoji,
    required this.name,
    required this.detail,
    required this.progress,
    required this.tint,
  });
  final String emoji, name, detail;
  final double progress;
  final Color tint;
  @override
  Widget build(BuildContext context) => Container(
    width: 158,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 74,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 38)),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: Color(0xFF2E4034),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          detail,
          style: const TextStyle(fontSize: 10, color: Color(0xFF899188)),
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            color: const Color(0xFF69905D),
            backgroundColor: const Color(0xFFE9EEE6),
          ),
        ),
      ],
    ),
  );
}

class PlantsPage extends StatelessWidget {
  const PlantsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'Your little jungle',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF25392D),
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        '12 plants growing with you',
        style: TextStyle(color: Color(0xFF788278)),
      ),
      const SizedBox(height: 20),
      const _TaskCard(
        icon: Icons.spa_rounded,
        color: Color(0xFF69905D),
        title: 'Sweet basil',
        subtitle: 'Herb · Planted Oct 23',
        trailing: '🌿',
      ),
      const SizedBox(height: 12),
      const _TaskCard(
        icon: Icons.local_florist_rounded,
        color: Color(0xFFD49248),
        title: 'Cherry tomato',
        subtitle: 'Vegetable · Planted Oct 17',
        trailing: '🍅',
      ),
      const SizedBox(height: 12),
      const _TaskCard(
        icon: Icons.filter_vintage_rounded,
        color: Color(0xFF8B78AE),
        title: 'Sunflower',
        subtitle: 'Flower · Planted Oct 9',
        trailing: '🌻',
      ),
      const SizedBox(height: 12),
      const _TaskCard(
        icon: Icons.eco_rounded,
        color: Color(0xFF5B9CA0),
        title: 'Mint',
        subtitle: 'Herb · Planted Nov 1',
        trailing: '🌱',
      ),
    ],
  );
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'This week',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF25392D),
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        'A few small moments make a happy garden.',
        style: TextStyle(color: Color(0xFF788278)),
      ),
      const SizedBox(height: 20),
      const _CalendarItem(
        day: 'MON 10',
        title: 'Water your plants',
        note: 'Basil, tomatoes & mint',
        icon: Icons.water_drop_rounded,
        tint: Color(0xFFE3F0EF),
      ),
      const _CalendarItem(
        day: 'TUE 11',
        title: 'Check soil moisture',
        note: 'Sunflower · 2 minutes',
        icon: Icons.touch_app_rounded,
        tint: Color(0xFFECEFE5),
      ),
      const _CalendarItem(
        day: 'WED 12',
        title: 'Feed the tomatoes',
        note: 'A little organic fertilizer',
        icon: Icons.compost_rounded,
        tint: Color(0xFFF3E8D8),
      ),
      const _CalendarItem(
        day: 'FRI 14',
        title: 'Write a garden note',
        note: 'Notice what changed this week',
        icon: Icons.edit_note_rounded,
        tint: Color(0xFFF1E8F0),
      ),
    ],
  );
}

class _CalendarItem extends StatelessWidget {
  const _CalendarItem({
    required this.day,
    required this.title,
    required this.note,
    required this.icon,
    required this.tint,
  });
  final String day, title, note;
  final IconData icon;
  final Color tint;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF71806F),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF42634A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E4034),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF858E85),
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

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'Your garden stories',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF25392D),
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        'Little notes from your growing journey.',
        style: TextStyle(color: Color(0xFF788278)),
      ),
      const SizedBox(height: 20),
      const _JournalCard(
        date: 'NOVEMBER 8 · SATURDAY',
        title: 'First tiny tomato!',
        body:
            'Spotted the first little green tomato today. I can’t believe it started from such a tiny seed.',
        emoji: '🍅',
      ),
      const _JournalCard(
        date: 'NOVEMBER 3 · MONDAY',
        title: 'A sunny afternoon',
        body:
            'Moved the basil closer to the window. It already looks perkier and smells amazing.',
        emoji: '☀️',
      ),
      const _JournalCard(
        date: 'OCTOBER 23 · THURSDAY',
        title: 'A new beginning',
        body:
            'Planted sweet basil seeds in the terracotta pot. Here’s to fresh pesto someday!',
        emoji: '🌱',
      ),
    ],
  );
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({
    required this.date,
    required this.title,
    required this.body,
    required this.emoji,
  });
  final String date, title, body, emoji;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: .8,
                  color: Color(0xFF849082),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E4034),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF788278),
            ),
          ),
        ],
      ),
    ),
  );
}

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
