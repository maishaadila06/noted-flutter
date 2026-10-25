import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late String _category;
  late String _priority;
  late Color _selectedColor;

  static const _palette = [
    AppColors.babyBlue,
    AppColors.matcha,
    AppColors.shrek,
    AppColors.viridian,
    AppColors.sevenSeas,
    AppColors.eggshell,
  ];

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _category = note?.category ?? 'Pribadi';
    _priority = note?.priority ?? 'Sedang';
    _selectedColor = note?.color ?? AppColors.babyBlue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final old = widget.note;
    final note = Note(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _category,
      priority: _priority,
      color: _selectedColor,
      updatedAt: DateTime.now(),
      archived: old?.archived ?? false,
    );
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text(isEditing ? 'Edit Catatan' : 'Tambah Catatan', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const _FieldLabel('Judul Catatan'),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'Masukkan judul catatan'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Judul catatan wajib diisi' : null,
              ),
              const SizedBox(height: 22),
              const _FieldLabel('Isi Catatan'),
              TextFormField(
                controller: _contentController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 5,
                maxLines: 9,
                decoration: const InputDecoration(hintText: 'Tulis catatan Anda di sini...', alignLabelWithHint: true),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Isi catatan wajib diisi' : null,
              ),
              const SizedBox(height: 22),
              const _FieldLabel('Kategori'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
                items: const ['Pribadi', 'Kerja', 'Kuliah', 'Belanja', 'Lainnya']
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value ?? 'Pribadi'),
              ),
              const SizedBox(height: 22),
              const _FieldLabel('Warna Catatan'),
              Wrap(
                spacing: 14,
                runSpacing: 10,
                children: _palette.map((color) {
                  final selected = color == _selectedColor;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = color),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: selected ? AppColors.sevenSeas : AppColors.white, width: selected ? 3 : 1.5)),
                      child: selected ? const Icon(Icons.check_rounded, size: 19, color: AppColors.sevenSeas) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              const _FieldLabel('Prioritas'),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Rendah', label: Text('Rendah')),
                  ButtonSegment(value: 'Sedang', label: Text('Sedang')),
                  ButtonSegment(value: 'Tinggi', label: Text('Tinggi')),
                ],
                selected: {_priority},
                onSelectionChanged: (values) => setState(() => _priority = values.first),
                style: SegmentedButton.styleFrom(selectedBackgroundColor: AppColors.viridian, selectedForegroundColor: AppColors.white, textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.check_rounded), label: Text(isEditing ? 'Simpan Perubahan' : 'Simpan Catatan')),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.sevenSeas, fontSize: 13)),
      );
}
