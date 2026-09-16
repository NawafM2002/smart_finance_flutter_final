import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color navy = Color(0xFF071525);
const Color blue = Color(0xFF102A43);
const Color blue2 = Color(0xFF173F5F);
const Color gold = Color(0xFFD9A52B);
const Color cyanAccent = Color(0xFF00E5FF);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartFinanceApp());
}

class SmartFinanceApp extends StatelessWidget {
  const SmartFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'التقييم الذكي للتمويل',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withAlpha(18),
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIconColor: gold,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withAlpha(45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: gold, width: 1.5),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ====================== بوابة التحقق وبدء التطبيق ======================

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogged = prefs.getBool('login') ?? false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: gold)),
      );
    }
    return _isLogged ? const BiometricScreen() : const AuthScreen();
  }
}

// ====================== شاشة تسجيل الدخول وإنشاء الحساب ======================

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void showMsg(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleAuth() async {
    final prefs = await SharedPreferences.getInstance();

    if (isSignUp) {
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passController.text.trim().isEmpty) {
        showMsg('يرجى تعبئة جميع الحقول المطلوبة');
        return;
      }

      await prefs.setString('name', nameController.text.trim());
      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('pass', passController.text.trim());
      await prefs.setBool('login', true);

      if (!mounted) return;
      showMsg('تم إنشاء الحساب بنجاح', isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BiometricScreen()),
      );
    } else {
      final savedEmail = prefs.getString('email');
      final savedPass = prefs.getString('pass');

      if (emailController.text.trim() == savedEmail &&
          passController.text.trim() == savedPass) {
        await prefs.setBool('login', true);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BiometricScreen()),
        );
      } else {
        showMsg('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [navy, blue, blue2],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 440,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: navy.withAlpha(235),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: gold.withAlpha(120)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 25,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance,
                            size: 100,
                            color: gold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'التقييم الذكي للتمويل',
                        style: TextStyle(
                          color: gold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'تقييم اليوم... لتمويل نجاح الغد',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      if (isSignUp) ...[
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'الاسم بالكامل',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isSignUp ? 'إنشاء الحساب' : 'تسجيل الدخول',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                        },
                        child: Text(
                          isSignUp
                              ? 'لديك حساب بالفعل؟ تسجيل الدخول'
                              : 'ليس لديك حساب؟ إنشاء حساب جديد',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====================== شاشة التحقق بالبصمة الحيوية ======================

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authStatus = 'يرجى وضع بصمة إصبعك على المستشعر للتحقق من هويتك';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authStatus = 'جاري التحقق...';
      });

      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _authStatus = 'الجهاز لا يدعم الفحص الحيوي أو لم تُضبط بصمة بالنظام';
          _isAuthenticating = false;
        });
        _navigateToHome();
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'يرجى إدخال البصمة لتسجيل الدخول بأمان',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
        _authStatus = authenticated ? 'تم التحقق بنجاح!' : 'فشلت عملية التحقق';
      });

      if (authenticated && mounted) {
        _navigateToHome();
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authStatus = 'خطأ: ${e.message}';
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text(
                  'التحقق من الهوية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      boxShadow: [
                        BoxShadow(
                          color: cyanAccent.withOpacity(0.25),
                          blurRadius: 35,
                          spreadRadius: 10,
                        ),
                      ],
                      border: Border.all(
                        color: cyanAccent.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 90,
                      color: cyanAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  _authStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isAuthenticating ? null : _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF334155)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.fingerprint, color: cyanAccent),
                  label: Text(
                    _isAuthenticating ? 'جاري الفحص...' : 'المتابعة باستخدام البصمة',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _navigateToHome,
                  child: const Text('تخطي الفحص (تجريبي)',
                      style: TextStyle(color: Colors.white54)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================== الصفحة الرئيسية (Dashboard) ======================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'الرئيسية',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              title: 'لوحة التحكم',
              subtitle: 'نظرة سريعة ومباشرة على طلبات التمويل',
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 750 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.35,
                  children: const [
                    DashboardCard(
                      title: 'إجمالي الطلبات',
                      number: '25',
                      icon: Icons.assignment_outlined,
                    ),
                    DashboardCard(
                      title: 'الطلبات المقبولة',
                      number: '15',
                      icon: Icons.check_circle_outline,
                    ),
                    DashboardCard(
                      title: 'قيد المراجعة',
                      number: '6',
                      icon: Icons.pending_actions,
                    ),
                    DashboardCard(
                      title: 'الطلبات المرفوضة',
                      number: '4',
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ابدأ طلب تمويل جديد',
                          style: TextStyle(
                            color: gold,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'أدخل بيانات العميل والمشروع لتقييم الجدارة المالية بنقرة واحدة.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FinancingPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('طلب تمويل جديد'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.analytics,
                    size: 70,
                    color: gold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.number,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DarkPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: gold, size: 30),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== صفحة طلب التمويل ======================

class FinancingPage extends StatefulWidget {
  const FinancingPage({super.key});

  @override
  State<FinancingPage> createState() => _FinancingPageState();
}

class _FinancingPageState extends State<FinancingPage> {
  final salaryController = TextEditingController();
  final loanAmountController = TextEditingController();
  final obligationsController = TextEditingController();
  String loanDuration = '3';

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'طلب تمويل',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              title: 'طلب تمويل جديد',
              subtitle: 'أدخل البيانات المالية للعميل لإجراء التحليل الذكي',
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Column(
                children: [
                  const AppField(label: 'الاسم الكامل للعميل', icon: Icons.person_outline),
                  const SizedBox(height: 14),
                  const AppField(label: 'رقم الهوية الوطنية / الإقامة', icon: Icons.badge_outlined),
                  const SizedBox(height: 14),
                  const AppField(label: 'المجال / الوظيفة', icon: Icons.work_outline),
                  const SizedBox(height: 14),
                  AppField(
                    label: 'الراتب / الدخل الشهري الإجمالي',
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    controller: salaryController,
                  ),
                  const SizedBox(height: 14),
                  AppField(
                    label: 'مبلغ التمويل المطلوب',
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType: TextInputType.number,
                    controller: loanAmountController,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: loanDuration,
                    dropdownColor: blue,
                    decoration: const InputDecoration(
                      labelText: 'مدة سداد التمويل',
                      prefixIcon: Icon(Icons.date_range_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('سنة واحدة')),
                      DropdownMenuItem(value: '3', child: Text('3 سنوات')),
                      DropdownMenuItem(value: '5', child: Text('5 سنوات')),
                      DropdownMenuItem(value: '10', child: Text('10 سنوات')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => loanDuration = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  AppField(
                    label: 'الالتزامات والأقساط الشهرية الحالية',
                    icon: Icons.receipt_long_outlined,
                    keyboardType: TextInputType.number,
                    controller: obligationsController,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EvaluationPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('إرسال الطلب للتقييم الفوري'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: navy,
                      ),
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
}

class AppField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const AppField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

// ====================== صفحة نتائج التقييم ======================

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'نتيجة التقييم',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              title: 'نتيجة التقييم الائتماني',
              subtitle: 'تحليل المؤشرات المالية والمخاطر المتوقعة',
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 95,
                      height: 95,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.check_circle, size: 80, color: gold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'درجة الجدارة الائتمانية',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '82%',
                    style: TextStyle(
                      color: gold,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF173F5F),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: gold),
                    ),
                    child: const Text(
                      'مستوى المخاطرة: منخفض',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'القرار الموصى به',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'موافق عليه مبدئياً للتمويل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const DarkPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عوامل التقييم المعتمدة',
                    style: TextStyle(
                      color: gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  EvaluationFactor(text: 'الدخل الشهري كافٍ لتغطية التزامات القسط'),
                  EvaluationFactor(text: 'نسبة عبء الدين أقل من 35%'),
                  EvaluationFactor(text: 'مبلغ التمويل متوافق مع رأس المال المطلوب'),
                  EvaluationFactor(text: 'مدة التمويل ملائمة لقدرة التدفق النقدي'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EvaluationFactor extends StatelessWidget {
  final String text;

  const EvaluationFactor({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== صفحة الطلبات وأسماء الطلاب ======================

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'طلباتي',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              title: 'سجل الطلبات',
              subtitle: 'متابعة حركة الطلبات المقدمة وحالاتها',
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: const TextStyle(
                    color: gold,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(color: Colors.white),
                  columns: const [
                    DataColumn(label: Text('رقم الطلب')),
                    DataColumn(label: Text('التاريخ')),
                    DataColumn(label: Text('المبلغ')),
                    DataColumn(label: Text('الحالة')),
                    DataColumn(label: Text('التقييم')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('1001')),
                        DataCell(Text('20/08/2026')),
                        DataCell(Text('10,000')),
                        DataCell(StatusBadge(text: 'مقبول', icon: Icons.check)),
                        DataCell(Text('85%')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('1002')),
                        DataCell(Text('21/08/2026')),
                        DataCell(Text('15,000')),
                        DataCell(StatusBadge(
                            text: 'قيد المراجعة', icon: Icons.hourglass_empty)),
                        DataCell(Text('-')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('1003')),
                        DataCell(Text('22/08/2026')),
                        DataCell(Text('8,000')),
                        DataCell(StatusBadge(text: 'مرفوض', icon: Icons.close)),
                        DataCell(Text('42%')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const DarkPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إعداد وتنفيذ المشروع',
                    style: TextStyle(
                      color: gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  StudentName(name: 'نواف محمد علي'),
                  StudentName(name: 'عبد الله صالح بن عماني'),
                  StudentName(name: 'فاطمة الكاف'),
                  StudentName(name: 'سريا المطحني'),
                  StudentName(name: 'ملاك رسام'),
                  StudentName(name: 'ربا عمر'),
                  StudentName(name: 'رؤى محمد'),
                  StudentName(name: 'محمد النمر'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentName extends StatelessWidget {
  final String name;

  const StudentName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: gold, size: 20),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final IconData icon;

  const StatusBadge({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 17),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

// ====================== العناصر المشتركة والهيكل ======================

class PageTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class DarkPanel extends StatelessWidget {
  final Widget child;

  const DarkPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withAlpha(60)),
      ),
      child: child,
    );
  }
}

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MainLayout({
    super.key,
    required this.title,
    required this.child,
  });

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', false);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  void openPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: navy,
        appBar: AppBar(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 12,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 42,
                  height: 42,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.account_balance, color: gold),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'التقييم الذكي للتمويل',
                  style: TextStyle(
                    color: gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: navy,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 230,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [navy, blue2],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 95,
                        height: 95,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance,
                            size: 70,
                            color: gold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'التقييم الذكي للتمويل',
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              DrawerItem(
                icon: Icons.home_outlined,
                title: 'الرئيسية',
                onTap: () => openPage(context, const HomePage()),
              ),
              DrawerItem(
                icon: Icons.request_quote_outlined,
                title: 'طلب تمويل',
                onTap: () => openPage(context, const FinancingPage()),
              ),
              DrawerItem(
                icon: Icons.analytics_outlined,
                title: 'نتيجة التقييم',
                onTap: () => openPage(context, const EvaluationPage()),
              ),
              DrawerItem(
                icon: Icons.assignment_outlined,
                title: 'طلباتي',
                onTap: () => openPage(context, const RequestsPage()),
              ),
              const Divider(color: Colors.white24),
              DrawerItem(
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chevron_left, color: gold),
      trailing: Icon(icon, color: gold),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
         MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF071525),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 85, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'التقييم الذكي للتمويل البنكي',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'منصة ذكية لتقييم المخاطر والجدارة الائتمانية لطلبات التمويل',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(color: Color(0xFF00E5FF)),
          ],
        ),
      ),
    );
  }
}
