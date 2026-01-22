import 'package:flutter/material.dart';
import '../../core/models/profile_model.dart';
import '../../core/services/profile_service.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {

  bool _loading = true;
  ProfileModel? _profile;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// 📌 Load profile lần đầu
  Future<void> _loadProfile() async {
    setState(() => _loading = true);

    try {
      final profile = await ProfileService.getProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  /// 🔄 GỌI SAU KHI UPDATE PROFILE
  Future<void> _refreshProfile() async {
    try {
      final profile = await ProfileService.getProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    ProfileHeader(profile: _profile),
                    const SizedBox(height: 10),
                    ProfileInfoCard(profile: _profile),
                    const SizedBox(height: 24),

                    /// 🔥 TRUYỀN CALLBACK XUỐNG
                    ProfileActionCard(
                      onProfileUpdated: _refreshProfile,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
