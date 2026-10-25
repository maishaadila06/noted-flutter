import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import 'add_note_screen.dart';
import 'detail_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = Note.demoNotes();
  final _searchController = TextEditingController();
  int _tabIndex = 0;
  String _filter = 'Semua';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final note = await Navigator.of(context)
        .push<Note>(MaterialPageRoute(builder: (_) => const AddNoteScreen()));
    if (note != null && mounted) setState(() => _notes.insert(0, note));
  }

  Future<void> _openNote(Note note) async {
    await Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (_) => DetailNoteScreen(
          note: note, onUpdate: _updateNote, onDelete: _deleteNote),
    ));
    if (mounted) setState(() {});
  }

  void _updateNote(Note updated) {
    final index = _notes.indexWhere((note) => note.id == updated.id);
    if (index >= 0) setState(() => _notes[index] = updated);
  }

  void _deleteNote(String id) =>
      setState(() => _notes.removeWhere((note) => note.id == id));

  List<Note> get _visibleNotes {
    final isArchiveTab = _tabIndex == 1;
    return _notes.where((note) {
      if (note.archived != isArchiveTab) return false;
      final queryMatches = _query.isEmpty ||
          note.title.toLowerCase().contains(_query.toLowerCase()) ||
          note.content.toLowerCase().contains(_query.toLowerCase());
      final filterMatches = switch (_filter) {
        'Penting' => note.priority == 'Tinggi',
        'Pribadi' => note.category == 'Pribadi',
        'Kerja' => note.category == 'Kerja',
        _ => true,
      };
      return queryMatches && filterMatches;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: [
            _buildNotesPage(
                title: 'Catatan Harian',
                subtitle: 'Apa yang ingin kamu catat hari ini?',
                archive: false),
            _buildNotesPage(
                title: 'Arsip Catatan',
                subtitle: 'Catatan yang kamu simpan untuk nanti.',
                archive: true),
            _buildProfilePage(),
          ],
        ),
      ),
      floatingActionButton: _tabIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: _addNote,
              backgroundColor: AppColors.viridian,
              foregroundColor: AppColors.white,
              elevation: 3,
              child: const Icon(Icons.add_rounded, size: 31),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() {
          _tabIndex = index;
          _filter = 'Semua';
          _query = '';
          _searchController.clear();
        }),
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.matcha.withValues(alpha: .55),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda'),
          NavigationDestination(
              icon: Icon(Icons.archive_outlined),
              selectedIcon: Icon(Icons.archive_rounded),
              label: 'Arsip'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNotesPage(
      {required String title,
      required String subtitle,
      required bool archive}) {
    final notes = _visibleNotes;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverToBoxAdapter(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Halo,',
                          style: TextStyle(
                              color: AppColors.sevenSeas.withValues(alpha: .8),
                              fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(title == 'Catatan Harian' ? 'Maisha 👋' : title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.sevenSeas,
                              fontSize: 25,
                              letterSpacing: -.5))
                    ])),
                Container(
                    width: 43,
                    height: 43,
                    decoration: const BoxDecoration(
                        color: AppColors.babyBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.person_rounded,
                        color: AppColors.sevenSeas)),
              ]),
              const SizedBox(height: 7),
              Text(subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                    hintText: 'Cari catatan...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                        onPressed: () => setState(() {
                              _query = '';
                              _searchController.clear();
                            }),
                        icon: const Icon(Icons.close_rounded)),
                    contentPadding: EdgeInsets.zero),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children:
                        ['Semua', 'Penting', 'Pribadi', 'Kerja'].map((filter) {
                  final selected = _filter == filter;
                  return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          onSelected: (_) => setState(() => _filter = filter),
                          backgroundColor: AppColors.white,
                          selectedColor: AppColors.viridian,
                          labelStyle: TextStyle(
                              color: selected
                                  ? AppColors.white
                                  : AppColors.sevenSeas,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          side: BorderSide(
                              color: selected
                                  ? AppColors.viridian
                                  : AppColors.line)));
                }).toList()),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Text(archive ? 'Catatan tersimpan' : 'Semua catatan',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.sevenSeas,
                        fontSize: 15)),
                const Spacer(),
                Text('${notes.length} catatan',
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.muted))
              ]),
              const SizedBox(height: 10),
            ]),
          ),
        ),
        if (notes.isEmpty)
          SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                            archive
                                ? Icons.archive_outlined
                                : Icons.note_add_outlined,
                            size: 54,
                            color: AppColors.matcha),
                        const SizedBox(height: 12),
                        Text(
                            archive
                                ? 'Belum ada catatan di arsip'
                                : 'Belum ada catatan yang cocok',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w600)),
                        if (!archive)
                          const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                  'Tekan tombol + untuk membuat catatan baru.',
                                  style: TextStyle(
                                      color: AppColors.muted, fontSize: 12)))
                      ])))),
        if (notes.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 95),
            sliver: SliverList.separated(
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _NoteCard(
                  note: notes[index], onTap: () => _openNote(notes[index])),
            ),
          ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return ListView(padding: const EdgeInsets.all(22), children: const [
      SizedBox(height: 24),
      Center(
          child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.babyBlue,
              child: Icon(Icons.person_rounded,
                  size: 54, color: AppColors.sevenSeas))),
      SizedBox(height: 15),
      Text('Maisha',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.sevenSeas)),
      SizedBox(height: 5),
      Text('Pengguna Noted! · Mode demo',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12)),
      SizedBox(height: 30),
      _ProfileTile(
          icon: Icons.palette_outlined,
          title: 'Tema aplikasi',
          subtitle: 'Eggshell, Shrek, Baby Blue, Matcha'),
      _ProfileTile(
          icon: Icons.storage_outlined,
          title: 'Penyimpanan',
          subtitle: 'Data tersimpan sementara selama aplikasi berjalan'),
      _ProfileTile(
          icon: Icons.info_outline_rounded,
          title: 'Tentang Noted!',
          subtitle: 'Aplikasi catatan sederhana berbasis Flutter'),
      SizedBox(height: 15),
      Text(
          'Noted! dibuat untuk demonstrasi UI. Data belum tersimpan ke database dan akan kembali ke data awal setelah aplikasi dimulai ulang.',
          style: TextStyle(color: AppColors.muted, height: 1.5, fontSize: 12)),
    ]);
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  const _NoteCard({required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: note.color.withValues(alpha: .42),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: .75),
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(_categoryIcon(note.category),
                    color: AppColors.sevenSeas, size: 24)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Text(note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppColors.sevenSeas))),
                    if (note.priority == 'Tinggi')
                      const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.flag_rounded,
                              size: 15, color: AppColors.shrek))
                  ]),
                  const SizedBox(height: 5),
                  Text(note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 11, color: AppColors.ink)),
                  const SizedBox(height: 5),
                  Text('${note.category} · ${formatNoteDate(note.updatedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.muted)),
                ])),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.sevenSeas),
          ]),
        ),
      ),
    );
  }
}

IconData _categoryIcon(String category) {
  switch (category) {
    case 'Kerja':
      return Icons.work_outline_rounded;
    case 'Kuliah':
      return Icons.menu_book_rounded;
    case 'Belanja':
      return Icons.shopping_bag_outlined;
    default:
      return Icons.lightbulb_outline_rounded;
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ProfileTile(
      {required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line)),
      child: Row(children: [
        Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: AppColors.viridian)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.sevenSeas)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.muted))
        ]))
      ]));
}
