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
  final plants = <PlantRecord>[
    PlantRecord(
      name: 'Sweet basil',
      category: 'Herb',
      planted: 'October 23',
      emoji: '🌿',
      notes:
          'Loves a sunny windowsill. Pinch the tips to encourage bushy growth.',
    ),
    PlantRecord(
      name: 'Cherry tomato',
      category: 'Vegetable',
      planted: 'October 17',
      emoji: '🍅',
      notes:
          'Keep the soil evenly moist and give this plant plenty of sunlight.',
    ),
    PlantRecord(
      name: 'Sunflower',
      category: 'Flower',
      planted: 'October 9',
      emoji: '🌻',
      notes: 'Growing tall in the brightest corner of the garden.',
    ),
    PlantRecord(
      name: 'Mint',
      category: 'Herb',
      planted: 'November 1',
      emoji: '🌱',
      notes:
          'Enjoys regular watering. Keep it in its own pot so it can spread happily.',
    ),
  ];
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
          onPressed: () => _showNotifications(context),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFDCE8D5),
              child: Icon(Icons.person_outline, color: Color(0xFF31543D)),
            ),
          ),
        ),
      ],
    ),
    body: IndexedStack(
      index: index,
      children: [
        HomePage(
          onSeeCalendar: () => setState(() => index = 2),
          onAllPlants: () => setState(() => index = 1),
          onOpenPlant: _openPlant,
          onOpenTask: _openTask,
        ),
        PlantsPage(plants: plants, onOpenPlant: _openPlant),
        CalendarPage(onOpenTask: _openTask),
        JournalPage(onAdd: _addJournalEntry),
      ],
    ),
    floatingActionButton: index == 0
        ? FloatingActionButton.extended(
            onPressed: _addJournalEntry,
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

  void _openPlant(PlantRecord plant) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => PlantDetailPage(plant: plant)));
  void _openTask(String title, String description) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              TaskDetailPage(title: title, description: description),
        ),
      );
  Future<void> _addJournalEntry() async {
    final entry = await showDialog<JournalRecord>(
      context: context,
      builder: (_) => const JournalEditorDialog(),
    );
    if (entry != null) setState(() => JournalPage.entries.insert(0, entry));
  }

  void _showNotifications(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Garden reminders',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 16),
            _NotificationRow(
              icon: Icons.water_drop_rounded,
              title: 'Water your plants',
              detail: 'Basil, tomatoes and mint are ready today.',
            ),
            _NotificationRow(
              icon: Icons.content_cut_rounded,
              title: 'Prune your basil',
              detail: 'Pinching the tips helps it grow fuller.',
            ),
            _NotificationRow(
              icon: Icons.wb_sunny_outlined,
              title: 'A bright day ahead',
              detail: 'Your sunflower will enjoy a sunny spot.',
            ),
          ],
        ),
      ),
    ),
  );
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.icon,
    required this.title,
    required this.detail,
  });
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF527B58)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                detail,
                style: const TextStyle(color: Color(0xFF788278), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class PlantRecord {
  PlantRecord({
    required this.name,
    required this.category,
    required this.planted,
    required this.emoji,
    required this.notes,
  });
  final String name, category, planted, emoji, notes;
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onSeeCalendar,
    required this.onAllPlants,
    required this.onOpenPlant,
    required this.onOpenTask,
  });
  final VoidCallback onSeeCalendar, onAllPlants;
  final ValueChanged<PlantRecord> onOpenPlant;
  final void Function(String, String) onOpenTask;

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
      _SectionHeading(
        title: 'Today in your garden',
        action: 'See calendar',
        onPressed: onSeeCalendar,
      ),
      const SizedBox(height: 12),
      _TaskCard(
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF5B9CA0),
        title: 'Water your plants',
        subtitle: '3 plants are ready for a drink',
        trailing: '10 min',
        onTap: () => onOpenTask(
          'Water your plants',
          'Water basil, cherry tomatoes and mint until the soil is evenly moist. Check the top of the soil first and avoid leaving the pots in standing water.',
        ),
      ),
      const SizedBox(height: 10),
      _TaskCard(
        icon: Icons.content_cut_rounded,
        color: const Color(0xFFD49248),
        title: 'Prune basil leaves',
        subtitle: 'Keep your herbs bushy & happy',
        trailing: '5 min',
        onTap: () => onOpenTask(
          'Prune basil leaves',
          'Pinch or snip the top pair of leaves just above a leaf node. This encourages your basil to grow fuller. Remove any yellow leaves too.',
        ),
      ),
      const SizedBox(height: 26),
      _SectionHeading(
        title: 'Growing right now',
        action: 'All plants',
        onPressed: onAllPlants,
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 188,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _PlantCard(
              emoji: '🍅',
              name: 'Cherry tomato',
              detail: 'Vegetable · 24 days',
              progress: .72,
              tint: Color(0xFFF3E6D8),
              onTap: () => onOpenPlant(
                PlantRecord(
                  name: 'Cherry tomato',
                  category: 'Vegetable',
                  planted: 'October 17',
                  emoji: '🍅',
                  notes:
                      'Keep the soil evenly moist and give this plant plenty of sunlight.',
                ),
              ),
            ),
            SizedBox(width: 12),
            _PlantCard(
              emoji: '🌿',
              name: 'Sweet basil',
              detail: 'Herb · 18 days',
              progress: .48,
              tint: Color(0xFFE5EEDC),
              onTap: () => onOpenPlant(
                PlantRecord(
                  name: 'Sweet basil',
                  category: 'Herb',
                  planted: 'October 23',
                  emoji: '🌿',
                  notes:
                      'Loves a sunny windowsill. Pinch the tips to encourage bushy growth.',
                ),
              ),
            ),
            SizedBox(width: 12),
            _PlantCard(
              emoji: '🌻',
              name: 'Sunflower',
              detail: 'Flower · 32 days',
              progress: .86,
              tint: Color(0xFFF4EDCE),
              onTap: () => onOpenPlant(
                PlantRecord(
                  name: 'Sunflower',
                  category: 'Flower',
                  planted: 'October 9',
                  emoji: '🌻',
                  notes: 'Growing tall in the brightest corner of the garden.',
                ),
              ),
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
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onPressed,
  });
  final String title, action;
  final VoidCallback onPressed;
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
        onPressed: onPressed,
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
    this.onTap,
  });
  final IconData icon;
  final Color color;
  final String title, subtitle, trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF858E85),
                  ),
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
    required this.onTap,
  });
  final String emoji, name, detail;
  final double progress;
  final Color tint;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
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
    ),
  );
}

class PlantsPage extends StatelessWidget {
  const PlantsPage({
    super.key,
    required this.plants,
    required this.onOpenPlant,
  });
  final List<PlantRecord> plants;
  final ValueChanged<PlantRecord> onOpenPlant;
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
      for (final plant in plants) ...[
        _TaskCard(
          icon: Icons.eco_rounded,
          color: const Color(0xFF69905D),
          title: plant.name,
          subtitle: '${plant.category} · Planted ${plant.planted}',
          trailing: plant.emoji,
          onTap: () => onOpenPlant(plant),
        ),
        const SizedBox(height: 12),
      ],
    ],
  );
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.onOpenTask});
  final void Function(String, String) onOpenTask;
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
      _CalendarItem(
        day: 'MON 10',
        title: 'Water your plants',
        note: 'Basil, tomatoes & mint',
        icon: Icons.water_drop_rounded,
        tint: Color(0xFFE3F0EF),
        onTap: () => onOpenTask(
          'Water your plants',
          'Water basil, tomatoes and mint until their soil is evenly moist.',
        ),
      ),
      _CalendarItem(
        day: 'TUE 11',
        title: 'Check soil moisture',
        note: 'Sunflower · 2 minutes',
        icon: Icons.touch_app_rounded,
        tint: Color(0xFFECEFE5),
        onTap: () => onOpenTask(
          'Check soil moisture',
          'Press a finger about two centimeters into the soil. Water if it feels dry at that depth.',
        ),
      ),
      _CalendarItem(
        day: 'WED 12',
        title: 'Feed the tomatoes',
        note: 'A little organic fertilizer',
        icon: Icons.compost_rounded,
        tint: Color(0xFFF3E8D8),
        onTap: () => onOpenTask(
          'Feed the tomatoes',
          'Use a balanced organic fertilizer according to its label, then water the soil around the plant.',
        ),
      ),
      _CalendarItem(
        day: 'FRI 14',
        title: 'Write a garden note',
        note: 'Notice what changed this week',
        icon: Icons.edit_note_rounded,
        tint: Color(0xFFF1E8F0),
        onTap: () => onOpenTask(
          'Write a garden note',
          'Capture a small observation: what changed this week, what is thriving, or what you want to try next.',
        ),
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
    required this.onTap,
  });
  final String day, title, note;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
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
    ),
  );
}

class JournalPage extends StatelessWidget {
  const JournalPage({super.key, required this.onAdd});
  final VoidCallback onAdd;
  static final List<JournalRecord> entries = [
    JournalRecord(
      date: 'NOVEMBER 8 · SATURDAY',
      title: 'First tiny tomato!',
      body:
          'Spotted the first little green tomato today. I can’t believe it started from such a tiny seed.',
      emoji: '🍅',
    ),
    JournalRecord(
      date: 'NOVEMBER 3 · MONDAY',
      title: 'A sunny afternoon',
      body:
          'Moved the basil closer to the window. It already looks perkier and smells amazing.',
      emoji: '☀️',
    ),
    JournalRecord(
      date: 'OCTOBER 23 · THURSDAY',
      title: 'A new beginning',
      body:
          'Planted sweet basil seeds in the terracotta pot. Here’s to fresh pesto someday!',
      emoji: '🌱',
    ),
  ];
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
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Write a diary entry'),
        ),
      ),
      const SizedBox(height: 16),
      for (final entry in entries)
        _JournalCard(
          entry: entry,
          onEdit: () async {
            final updated = await showDialog<JournalRecord>(
              context: context,
              builder: (_) => JournalEditorDialog(entry: entry),
            );
            if (updated != null) {
              final i = entries.indexOf(entry);
              if (i >= 0) entries[i] = updated;
              (context as Element).markNeedsBuild();
            }
          },
        ),
    ],
  );
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.entry, required this.onEdit});
  final JournalRecord entry;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(entry.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  entry.date,
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
              entry.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2E4034),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entry.body,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF788278),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class JournalRecord {
  JournalRecord({
    required this.date,
    required this.title,
    required this.body,
    required this.emoji,
  });
  final String date;
  final String title;
  final String body;
  final String emoji;
}

class JournalEditorDialog extends StatefulWidget {
  const JournalEditorDialog({super.key, this.entry});
  final JournalRecord? entry;
  @override
  State<JournalEditorDialog> createState() => _JournalEditorDialogState();
}

class _JournalEditorDialogState extends State<JournalEditorDialog> {
  late final title = TextEditingController(text: widget.entry?.title ?? '');
  late final body = TextEditingController(text: widget.entry?.body ?? '');
  @override
  void dispose() {
    title.dispose();
    body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.entry == null ? 'New diary entry' : 'Edit diary entry'),
    content: SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: body,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'What happened in your garden?',
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (title.text.trim().isEmpty || body.text.trim().isEmpty) return;
          Navigator.pop(
            context,
            JournalRecord(
              date: widget.entry?.date ?? 'NOVEMBER 10 · MONDAY',
              title: title.text.trim(),
              body: body.text.trim(),
              emoji: widget.entry?.emoji ?? '🌱',
            ),
          );
        },
        child: const Text('Save'),
      ),
    ],
  );
}

class PlantDetailPage extends StatelessWidget {
  const PlantDetailPage({super.key, required this.plant});
  final PlantRecord plant;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(plant.name)),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Container(
            width: 130,
            height: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE5EEDC),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(plant.emoji, style: const TextStyle(fontSize: 72)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          plant.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '${plant.category} · Planted ${plant.planted}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF788278)),
        ),
        const SizedBox(height: 28),
        const Text(
          'About this plant',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          plant.notes,
          style: const TextStyle(height: 1.5, color: Color(0xFF647365)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Care checklist',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const CheckboxListTile(
          value: false,
          onChanged: null,
          title: Text('Check the soil moisture'),
          contentPadding: EdgeInsets.zero,
        ),
        const CheckboxListTile(
          value: false,
          onChanged: null,
          title: Text('Look for new growth'),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({
    super.key,
    required this.title,
    required this.description,
  });
  final String title, description;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Garden task')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF647365),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('Mark as done'),
            ),
          ),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gardener profile')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFDCE8D5),
            child: Icon(
              Icons.person_outline,
              size: 42,
              color: Color(0xFF31543D),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Garden friend',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text(
          'Growing something wonderful',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF788278)),
        ),
        const SizedBox(height: 28),
        const ListTile(
          leading: Icon(Icons.eco_outlined),
          title: Text('Plants in my garden'),
          trailing: Text('12'),
        ),
        const ListTile(
          leading: Icon(Icons.menu_book_outlined),
          title: Text('Diary entries'),
          trailing: Text('3'),
        ),
        const ListTile(
          leading: Icon(Icons.notifications_outlined),
          title: Text('Garden reminders'),
          subtitle: Text('Watering and care tips'),
        ),
      ],
    ),
  );
}
