import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GregTechnology',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

List<Map<String, String>> userDatabase = [];

class GregColors {
  static const Color beige = Color(0xFFF5F0E1);
  static const Color vertPal = Color(0xFFB6D7A8);
  static const Color blePa = Color(0xFFA7C7E7);
  static const Color nwa = Color(0xFF2C3E50);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [GregColors.blePa, GregColors.vertPal])),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 120, height: 120, decoration: BoxDecoration(color: GregColors.beige, shape: BoxShape.circle, boxShadow: [BoxShadow(color: GregColors.nwa.withOpacity(0.3), blurRadius: 25)]), 
                  child: Icon(Icons.laptop, size: 70, color: GregColors.nwa)),
                const SizedBox(height: 30),
                Text('GregTechnology', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: GregColors.nwa, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text('Ayiti', style: TextStyle(fontSize: 16, color: GregColors.nwa.withOpacity(0.8))),
              ]))),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: AnimatedBuilder(animation: _controller, builder: (_, __) => LinearProgressIndicator(value: _controller.value, backgroundColor: GregColors.beige.withOpacity(0.3), valueColor: AlwaysStoppedAnimation(GregColors.nwa), minHeight: 6))),
                  const SizedBox(height: 16),
                  AnimatedBuilder(animation: _controller, builder: (_, __) => Text('${(_controller.value * 100).toInt()}%', style: TextStyle(color: GregColors.nwa))),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (userDatabase.any((u) => u['email'] == _email.text && u['password'] == _password.text)) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        setState(() => _error = 'Imèl oswa modpas pa kòrèk');
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [GregColors.beige, GregColors.vertPal.withOpacity(0.3)])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: GregColors.nwa.withOpacity(0.1), blurRadius: 15)]), 
                  child: Icon(Icons.laptop, size: 50, color: GregColors.nwa)),
                const SizedBox(height: 20),
                Text('GregTechnology', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: GregColors.nwa)),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Imèl',
                        hintText: 'egzanp@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.email, color: GregColors.nwa, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: GregColors.blePa, width: 1.5)),
                        filled: true, fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Antre imèl ou';
                        if (!_isValidEmail(v)) return 'Imèl pa bon';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Modpas',
                        hintText: 'antre modpas ou',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.lock, color: GregColors.nwa, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: GregColors.blePa, width: 1.5)),
                        filled: true, fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Antre modpas ou' : null,
                    ),
                    if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                    const SizedBox(height: 20),
                    SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _login, 
                      style: ElevatedButton.styleFrom(backgroundColor: GregColors.nwa, foregroundColor: GregColors.beige, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 2),
                      child: const Text('Konekte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Pa gen kont? ', style: TextStyle(color: GregColors.nwa.withOpacity(0.6), fontSize: 14)),
                      TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), 
                        child: Text('Enskri', style: TextStyle(color: GregColors.nwa, fontWeight: FontWeight.w600, fontSize: 14))),
                    ]),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      if (userDatabase.any((u) => u['email'] == _email.text)) {
        setState(() => _error = 'Imèl sa deja itilize');
      } else {
        userDatabase.add({'email': _email.text, 'password': _password.text});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enskripsyon reyisi!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enskripsyon'), backgroundColor: GregColors.nwa, foregroundColor: GregColors.beige, elevation: 0),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [GregColors.beige, GregColors.vertPal.withOpacity(0.2)])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: GregColors.nwa.withOpacity(0.1), blurRadius: 15)]), 
                  child: Icon(Icons.person_add, size: 40, color: GregColors.nwa)),
                const SizedBox(height: 20),
                Text('Kreye kont ou', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: GregColors.nwa)),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Imèl',
                        hintText: 'egzanp@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.email, color: GregColors.nwa, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: GregColors.blePa, width: 1.5)),
                        filled: true, fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Antre imèl ou';
                        if (!_isValidEmail(v)) return 'Imèl pa bon';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Modpas',
                        hintText: 'omwen 8 karaktè',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.lock, color: GregColors.nwa, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: GregColors.blePa, width: 1.5)),
                        filled: true, fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Antre modpas ou';
                        if (v.length < 8) return '8 karaktè minimòm';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirm,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Konfimasyon',
                        hintText: 'antre modpas la ankò',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.lock_outline, color: GregColors.nwa, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: GregColors.blePa, width: 1.5)),
                        filled: true, fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Konfime modpas ou';
                        if (v != _password.text) return 'Modpas yo pa menm';
                        return null;
                      },
                    ),
                    if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                    const SizedBox(height: 20),
                    SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _signUp, 
                      style: ElevatedButton.styleFrom(backgroundColor: GregColors.nwa, foregroundColor: GregColors.beige, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 2),
                      child: const Text('Enskri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.pop(context), 
                      child: Text('Deja gen kont? Konekte', style: TextStyle(color: GregColors.nwa, fontSize: 14, fontWeight: FontWeight.w500))),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [GregColors.beige, GregColors.vertPal.withOpacity(0.3)])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 110, height: 110, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: GregColors.nwa.withOpacity(0.2), blurRadius: 20)]), 
                  child: Icon(Icons.laptop, size: 60, color: GregColors.nwa)),
                const SizedBox(height: 25),
                Text('Byenvini!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: GregColors.nwa)),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: GregColors.nwa.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.school, color: GregColors.nwa, size: 32),
                      const SizedBox(height: 16),
                      Text(
                        'GregTechnology',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: GregColors.nwa),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'GregTechnology se mwayen pi fasil pou w aprann tout sa ki gen pou wè ak enfòmatik kelkeswa kote w ye nan mond lan ak sèlman tlf ou. '
                        'Nou ofri w kou ki adapte epi ki ap ede w avanse byen. '
                        'Gen pou depanaj, pwogramasyon ak anpil lòt bagay.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: GregColors.nwa.withOpacity(0.8), height: 1.6, letterSpacing: 0.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GregColors.nwa, 
                    foregroundColor: GregColors.beige, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('Dekonekte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
