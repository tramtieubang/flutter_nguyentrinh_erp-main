import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../main/main_screen.dart';
import '../../core/services/auth_service.dart';

// ==================== LOGIN SCREEN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  bool _pressed = false;

  late AnimationController _mainCtrl;
  late AnimationController _shakeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnim = CurvedAnimation(parent: _mainCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(CurvedAnimation(parent: _mainCtrl, curve: Curves.easeOutCubic));

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(_shakeCtrl);

    _mainCtrl.forward();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() => _loading = true);

    final user = await AuthService.login(
      _userCtrl.text.trim(),
      _passCtrl.text,
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai tên đăng nhập hoặc mật khẩu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ Login thành công
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _goForgotPassword() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _shakeCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final height = constraints.maxHeight;
            final isPortrait = constraints.maxHeight > constraints.maxWidth;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: isPortrait ? height * 0.08 : 20),
                      Image.asset('assets/icons/logo.png', height: 70),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              'ĐĂNG NHẬP HỆ THỐNG',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                     
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(_shakeAnim.value, 0),
                          child: child, // child tĩnh, không rebuild
                        ),
                        child: _loginCard(), // giữ child ngoài builder
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _loginCard() {
  return Container(
    width: double.infinity, // chiếm hết chiều ngang
    margin: const EdgeInsets.symmetric(horizontal: 0), // sát viền
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24), // tăng padding ngang
    decoration: BoxDecoration(
      color: Colors.white.withAlpha((0.8 * 255).round()), // 0.85 = hơi trong suốt
      borderRadius: BorderRadius.circular(22), // bo tròn lớn hơn
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 12),
          _input(
            hint: 'Tên đăng nhập',
            icon: Icons.person_outline,
            controller: _userCtrl,
            validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
          ),
          const SizedBox(height: 22),
          _input(
            hint: 'Mật khẩu',
            icon: Icons.lock_outline,
            controller: _passCtrl,
            obscure: _obscure,
            //validator: (v) => v == null || v.length < 6 ? 'Tối thiểu 6 ký tự' : null,
            validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
            suffix: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _goForgotPassword,
              child: const Text(
                'Quên mật khẩu?',
                style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _loginButton(),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

  Widget _input( {
    required String hint,
      required IconData icon,
      TextEditingController? controller,
      String? Function(String?)? validator,
      bool obscure = false,
      Widget? suffix}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _loading ? null : _login,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
        ),
      ),
    );
  }
}

