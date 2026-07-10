import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ProfilAnakScreen extends StatefulWidget {
  const ProfilAnakScreen({super.key});

  @override
  State<ProfilAnakScreen> createState() => _ProfilAnakScreenState();
}

class _ProfilAnakScreenState extends State<ProfilAnakScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController    = TextEditingController();
  final _ageController     = TextEditingController();
  final _notesController   = TextEditingController();

  String _selectedGender = 'L';
  bool _isLoading  = true;
  bool _isSaving   = false;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── Load data dari API ───────────────────────────────────────────────────
  Future<void> _loadProfil() async {
    setState(() => _isLoading = true);

    final data = await ApiService.getProfilAnak();

    if (data != null && mounted) {
      setState(() {
        _nameController.text  = data['child_name']   ?? '';
        _ageController.text   = (data['child_age'] ?? '').toString();
        _notesController.text = data['child_notes']  ?? '';
        _selectedGender       = data['child_gender'] ?? 'L';
      });
    }

    if (mounted) setState(() => _isLoading = false);
  }

  // ── Simpan ke API ────────────────────────────────────────────────────────
  Future<void> _saveProfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await ApiService.updateProfilAnak(
      childName:   _nameController.text.trim(),
      childAge:    int.tryParse(_ageController.text.trim()) ?? 0,
      childGender: _selectedGender,
      childNotes:  _notesController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Profil berhasil disimpan!' : 'Gagal menyimpan profil.'),
          backgroundColor: success ? const Color(0xFF6C63FF) : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatarSection(),
                    const SizedBox(height: 28),
                    _buildSectionLabel('Nama Anak'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Masukkan nama anak',
                      icon: Icons.person_outline_rounded,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Usia Anak'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _ageController,
                      hint: 'Masukkan usia anak (tahun)',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Usia tidak boleh kosong';
                        final age = int.tryParse(v.trim());
                        if (age == null || age < 0 || age > 18) return 'Usia harus antara 0–18 tahun';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Jenis Kelamin'),
                    const SizedBox(height: 8),
                    _buildGenderToggle(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Catatan (opsional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _notesController,
                      hint: 'Contoh: suka menggambar, aktif bergerak...',
                      icon: Icons.notes_rounded,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Widgets ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6C63FF),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Profil Anak',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  Widget _buildAvatarSection() {
    final bool isBoy = _selectedGender == 'L';
    return Center(
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isBoy ? const Color(0xFFD6ECFF) : const Color(0xFFFFD6EC),
              boxShadow: [
                BoxShadow(
                  color: (isBoy ? const Color(0xFF6C63FF) : const Color(0xFFFF63A5)).withOpacity(0.25),
                  blurRadius: 16, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isBoy ? '👦' : '👧',
                style: const TextStyle(fontSize: 52),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _nameController.text.isEmpty ? 'Nama Anak' : _nameController.text,
            style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6C63FF),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: (_) => setState(() {}), // update avatar nama real-time
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenderToggle() {
    return Row(
      children: [
        Expanded(child: _genderOption('L', '👦 Laki-laki')),
        const SizedBox(width: 12),
        Expanded(child: _genderOption('P', '👧 Perempuan')),
      ],
    );
  }

  Widget _genderOption(String value, String label) {
    final bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.35),
                blurRadius: 10, offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProfil,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          disabledBackgroundColor: const Color(0xFF6C63FF).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Text(
                'Simpan Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }
}