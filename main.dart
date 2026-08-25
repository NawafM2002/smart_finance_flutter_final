import 'package:flutter/material.dart';

const Color navy = Color(0xFF071525);
const Color blue = Color(0xFF102A43);
const Color blue2 = Color(0xFF173F5F);
const Color gold = Color(0xFFD9A52B);
const Color lightBlue = Color(0xFFEAF2F8);

void main() {
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
      home: const LoginPage(),
    );
  }
}

// ====================== LOGIN ======================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  width: 430,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: navy.withAlpha(235),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: gold.withAlpha(120)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 25,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.jpg',
                        width: 170,
                        height: 170,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'التقييم الذكي للتمويل',
                        style: TextStyle(
                          color: gold,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'تقييم اليوم... لتمويل نجاح الغد',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'اسم المستخدم',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const TextField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(color: Colors.white70),
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

// ====================== HOME ======================

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
              subtitle: 'نظرة سريعة على طلبات التمويل',
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
                  childAspectRatio: 1.4,
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
                          'أدخل بيانات العميل لعرض نتيجة التقييم المبدئية.',
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
                    Icons.account_balance,
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
          Icon(icon, color: gold, size: 31),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== FINANCING ======================

class FinancingPage extends StatelessWidget {
  const FinancingPage({super.key});

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
              subtitle: 'بيانات تجريبية لغرض عرض الواجهة فقط',
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Column(
                children: [
                  const AppField(
                    label: 'الاسم الكامل',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'رقم الهوية',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'العمر',
                    icon: Icons.cake_outlined,
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'الوظيفة',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'الراتب الشهري',
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'مبلغ التمويل المطلوب',
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    dropdownColor: blue,
                    decoration: const InputDecoration(
                      labelText: 'مدة التمويل',
                      prefixIcon: Icon(Icons.date_range_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: '1',
                        child: Text('سنة واحدة'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('3 سنوات'),
                      ),
                      DropdownMenuItem(
                        value: '5',
                        child: Text('5 سنوات'),
                      ),
                      DropdownMenuItem(
                        value: '10',
                        child: Text('10 سنوات'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 14),
                  const AppField(
                    label: 'الالتزامات الشهرية',
                    icon: Icons.receipt_long_outlined,
                    keyboardType: TextInputType.number,
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
                      label: const Text('إرسال الطلب للتقييم'),
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

  const AppField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

// ====================== EVALUATION ======================

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
              title: 'نتيجة التقييم',
              subtitle: 'نتيجة مبدئية لغرض عرض الواجهة',
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'درجة التقييم',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '82%',
                    style: TextStyle(
                      color: gold,
                      fontSize: 62,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
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
                  const SizedBox(height: 20),
                  const Text(
                    'التوصية',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'مناسب مبدئياً للتمويل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            DarkPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'عوامل التقييم',
                    style: TextStyle(
                      color: gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  EvaluationFactor(text: 'الدخل الشهري مناسب'),
                  EvaluationFactor(text: 'الالتزامات الشهرية منخفضة'),
                  EvaluationFactor(text: 'مبلغ التمويل مناسب'),
                  EvaluationFactor(text: 'مدة التمويل مناسبة'),
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

  const EvaluationFactor({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: gold),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ====================== REQUESTS ======================

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
              title: 'طلبات التمويل',
              subtitle: 'قائمة تجريبية لعرض شكل الواجهة',
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
                        DataCell(StatusBadge(
                          text: 'مقبول',
                          icon: Icons.check,
                        )),
                        DataCell(Text('85%')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('1002')),
                        DataCell(Text('21/08/2026')),
                        DataCell(Text('15,000')),
                        DataCell(StatusBadge(
                          text: 'قيد المراجعة',
                          icon: Icons.hourglass_empty,
                        )),
                        DataCell(Text('-')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('1003')),
                        DataCell(Text('22/08/2026')),
                        DataCell(Text('8,000')),
                        DataCell(StatusBadge(
                          text: 'مرفوض',
                          icon: Icons.close,
                        )),
                        DataCell(Text('42%')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            DarkPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                  StudentName(name: 'عبد الله صالح بن الرماني'),
                  StudentName(name: 'فاطمة الكاف'),
                  StudentName(name: 'سرية المطحني'),
                  StudentName(name: 'ملاك السلام'),
                  StudentName(name: 'ربا إسماعيل'),
                  StudentName(name: 'رؤى عمر'),
                  StudentName(name: 'محمد النمل'),
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

  const StudentName({
    super.key,
    required this.name,
  });

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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final IconData icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 17),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

// ====================== COMMON UI ======================

class PageTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

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
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class DarkPanel extends StatelessWidget {
  final Widget child;

  const DarkPanel({
    super.key,
    required this.child,
  });

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

// ====================== MAIN LAYOUT ======================

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MainLayout({
    super.key,
    required this.title,
    required this.child,
  });

  void openPage(BuildContext context, Widget page) {
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
              Image.asset(
                'assets/images/logo.jpg',
                width: 45,
                height: 45,
                fit: BoxFit.contain,
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
                    Image.asset(
                      'assets/images/logo.jpg',
                      width: 105,
                      height: 105,
                      fit: BoxFit.contain,
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
                onTap: () => openPage(context, const LoginPage()),
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
