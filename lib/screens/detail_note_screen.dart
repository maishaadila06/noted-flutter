import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import 'add_note_screen.dart';

class DetailNoteScreen extends StatefulWidget {
  final Note note;
  final ValueChanged<Note> onUpdate;
  final ValueChanged<String> onDelete;

  const DetailNoteScreen({super.key, required this.note, required this.onUpdate, required this.onDelete});

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<Note>(MaterialPageRoute(builder: (_) => AddNoteScreen(note: _note)));
    if (updated == null || !mounted) return;
    setState(() => _note = updated);
    widget.onUpdate(updated);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: const Text('Catatan yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), style: FilledButton.styleFrom(backgroundColor: AppColors.sevenSeas), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      widget.onDelete(_note.id);
      Navigator.of(context).pop();
    }
  }

  void _toggleArchive() {
    final updated = _note.copyWith(archived: !_note.archived, updatedAt: DateTime.now());
    widget.onUpdate(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Detail Catatan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          IconButton(tooltip: 'Edit catatan', onPressed: _edit, icon: const Icon(Icons.edit_outlined)),
          IconButton(tooltip: 'Hapus catatan', onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFB54B43))),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: _note.color.withValues(alpha: .5), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.white.withValues(alpha: .7), borderRadius: BorderRadius.circular(15)), child: Icon(_iconForCategory(_note.category), color: AppColors.sevenSeas, size: 27)),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_note.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.sevenSeas)), const SizedBox(height: 7), _PriorityPill(priority: _note.priority)])),
              ],
            ),
          ),
          const SizedBox(height: 19),
          Row(children: [const Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.muted), const SizedBox(width: 8), Expanded(child: Text(formatNoteDate(_note.updatedAt), style: const TextStyle(color: AppColors.muted, fontSize: 13)))]),
          const Divider(height: 30, color: AppColors.line),
          Row(children: [const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.sevenSeas)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(20)), child: Text(_note.category, style: const TextStyle(color: AppColors.sevenSeas, fontWeight: FontWeight.w600, fontSize: 12)))]),
          const SizedBox(height: 24),
          const Text('Isi Catatan', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.sevenSeas, fontSize: 14)),
          const SizedBox(height: 12),
          Text(_note.content, style: const TextStyle(fontSize: 15, height: 1.7, color: AppColors.ink)),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: _toggleArchive,
            icon: Icon(_note.archived ? Icons.unarchive_outlined : Icons.archive_outlined),
            label: Text(_note.archived ? 'Keluarkan dari Arsip' : 'Arsipkan Catatan'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.sevenSeas, side: const BorderSide(color: AppColors.babyBlue), minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ],
      ),
    );
  }
}

IconData _iconForCategory(String category) {
  switch (category) {
    case 'Kerja': return Icons.work_outline_rounded;
    case 'Kuliah': return Icons.menu_book_rounded;
    case 'Belanja': return Icons.shopping_bag_outlined;
    default: return Icons.lightbulb_outline_rounded;
  }
}

class _PriorityPill extends StatelessWidget {
  final String priority;
  const _PriorityPill({required this.priority});
  @override
  Widget build(BuildContext context) {
    final color = priority == 'Tinggi' ? AppColors.shrek : priority == 'Sedang' ? AppColors.viridian : AppColors.sevenSeas;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.white.withValues(alpha: .75), borderRadius: BorderRadius.circular(8)), child: Text(priority, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11)));
  }
}
