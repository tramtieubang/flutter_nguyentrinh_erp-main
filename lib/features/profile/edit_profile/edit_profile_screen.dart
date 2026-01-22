import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/profile_model.dart';
import '../../../core/services/profile_service.dart';
import '../../../config/api_config.dart';
//import '../../../core/session/user_session.dart';
import 'widgets/edit_profile_appbar.dart';
import 'widgets/edit_profile_form_card.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  File? _avatarFile;
  String? _avatarUrl;

  bool _loading = false;
  bool _initLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  /// ============================
  /// 👤 LOAD PROFILE
  /// ============================
  Future<void> _loadProfile() async {
    final ProfileModel? profile = await ProfileService.getProfile();
    if (!mounted) return;

    if (profile != null) {
      _nameCtrl.text = profile.name;
      _emailCtrl.text = profile.email;
      _phoneCtrl.text = profile.phone;

      if (profile.avatar != null && profile.avatar!.isNotEmpty) {
        _avatarUrl =
            '${profile.avatar!.startsWith('http') ? profile.avatar : '${ApiConfig.baseUrl.replaceFirst('/api_hub/web', '')}/${profile.avatar}'}?v=${DateTime.now().millisecondsSinceEpoch}';
      }
    }

    setState(() => _initLoading = false);
  }

  /// ============================
  /// 📸 PICK AVATAR (CAMERA / GALLERY)
  /// ============================
  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
        _avatarUrl = null; // ưu tiên ảnh local
      });
    }
  }

  /// ============================
  /// 📸 CHOOSE SOURCE
  /// ============================
  void _showPickAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: Colors.orangeAccent),
              title: const Text(
                'Chụp ảnh bằng camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAvatar(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Colors.orangeAccent),
              title: const Text(
                'Chọn ảnh từ thư viện',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAvatar(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ============================
  /// 🚀 SUBMIT
  /// ============================
 Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  final success = await ProfileService.updateProfile(
    name: _nameCtrl.text.trim(),
    email: _emailCtrl.text.trim(),
    phone: _phoneCtrl.text.trim(),
    avatar: _avatarFile,
  );

  if (!mounted) return; // 🔥 BẮT BUỘC

  setState(() => _loading = false);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        success ? 'Cập nhật thông tin thành công' : 'Cập nhật thất bại',
      ),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );

  if (success) {
    Navigator.pop(context, true);
  }
}


  @override
  Widget build(BuildContext context) {
    if (_initLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    ImageProvider? avatarImage;
    if (_avatarFile != null) {
      avatarImage = FileImage(_avatarFile!);
    } else if (_avatarUrl != null) {
      avatarImage = NetworkImage(_avatarUrl!);
    }

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const UpdateProfileAppBar(),
                  const SizedBox(height: 24),

                  /// AVATAR
                  GestureDetector(
                    onTap: _showPickAvatarOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white24,
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white70,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  UpdateProfileFormCard(
                    formKey: _formKey,
                    nameCtrl: _nameCtrl,
                    emailCtrl: _emailCtrl,
                    phoneCtrl: _phoneCtrl,
                    onSubmit: _submit,
                  ),
                ],
              ),
            ),
          ),

          /// LOADING
          if (_loading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orangeAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
