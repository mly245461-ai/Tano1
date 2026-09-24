import 'package:flutter/material.dart';

void main() {
  runApp(const TanoApp());
}

class TanoApp extends StatefulWidget {
  const TanoApp({super.key});

  @override
  State<TanoApp> createState() => _TanoAppState();
}

class _TanoAppState extends State<TanoApp> {
  bool arabic = true;
  int tab = 0;

  void changeLanguage(bool value) => setState(() => arabic = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tano',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2477B9)),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        fontFamily: 'Arial',
      ),
      home: Directionality(
        textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
        child: AppShell(
          arabic: arabic,
          tab: tab,
          onTabChanged: (v) => setState(() => tab = v),
          onLanguageChanged: changeLanguage,
        ),
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  final bool arabic;
  final int tab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<bool> onLanguageChanged;

  const AppShell({
    super.key,
    required this.arabic,
    required this.tab,
    required this.onTabChanged,
    required this.onLanguageChanged,
  });

  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        arabic: arabic,
        onNavigate: onTabChanged,
        onLanguageChanged: onLanguageChanged,
      ),
      LivePage(arabic: arabic),
      HistoryPage(arabic: arabic),
      AlertsPage(arabic: arabic),
      AiPage(arabic: arabic),
    ];

    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: onTabChanged,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: t('الرئيسية', 'Home')),
          NavigationDestination(icon: const Icon(Icons.monitor_heart_outlined), selectedIcon: const Icon(Icons.monitor_heart), label: t('مباشر', 'Live')),
          NavigationDestination(icon: const Icon(Icons.history), label: t('السجل', 'History')),
          NavigationDestination(icon: const Icon(Icons.notifications_none), selectedIcon: const Icon(Icons.notifications), label: t('التنبيهات', 'Alerts')),
          NavigationDestination(icon: const Icon(Icons.auto_awesome_outlined), selectedIcon: const Icon(Icons.auto_awesome), label: t('AI', 'AI')),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool arabic;
  final ValueChanged<int> onNavigate;
  final ValueChanged<bool> onLanguageChanged;

  const HomePage({
    super.key,
    required this.arabic,
    required this.onNavigate,
    required this.onLanguageChanged,
  });

  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 18,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFF2477B9), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.health_and_safety, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('Tano', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: t('الإعدادات', 'Settings'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(arabic: arabic, onLanguageChanged: onLanguageChanged))),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
        children: [
          Text(t('لوحة التحكم الصحية', 'Health Dashboard'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(t('المتابعة الذكية للفحص الدوري والوقاية.', 'Smart monitoring for routine screening and prevention.'), style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
          const SizedBox(height: 18),
          _heroCard(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _metricCard(Icons.thermostat, t('درجة الحرارة', 'Temperature'), '36.8°C', t('طبيعية', 'Normal'))),
              const SizedBox(width: 12),
              Expanded(child: _metricCard(Icons.show_chart, t('متوسط ΔT', 'Average ΔT'), '0.4°C', t('مستقر', 'Stable'))),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFEAF4FB), child: const Icon(Icons.verified, color: Color(0xFF2477B9))),
              title: Text(t('الحالة العامة', 'Overall status'), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(t('لا توجد مؤشرات تستدعي تنبيهاً عاجلاً.', 'No indicators currently require an urgent alert.')),
            ),
          ),
          const SizedBox(height: 20),
          Text(t('الوصول السريع', 'Quick access'), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _actionTile(Icons.monitor_heart, t('المراقبة الحية', 'Live Monitoring'), t('درجات الحرارة والقراءات الحالية', 'Current temperature and readings'), () => onNavigate(1)),
          _actionTile(Icons.history, t('السجل التاريخي', 'History Log'), t('مراجعة القراءات حسب التاريخ', 'Review readings by date'), () => onNavigate(2)),
          _actionTile(Icons.notifications_active, t('التنبيهات', 'Alerts'), t('التنبيهات والتنبيهات المهمة', 'Alerts and important notices'), () => onNavigate(3)),
          _actionTile(Icons.auto_awesome, t('تحليل الذكاء الاصطناعي', 'AI Analysis'), t('تحليل مبسط لنمط القراءات', 'Simple analysis of reading patterns'), () => onNavigate(4)),
          _actionTile(Icons.settings_outlined, t('الإعدادات', 'Settings'), t('اللغة والحساب والإشعارات والخصوصية', 'Language, account, notifications and privacy'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(arabic: arabic, onLanguageChanged: onLanguageChanged)))),
          const SizedBox(height: 18),
          _infoCard(),
          const SizedBox(height: 14),
          Center(child: Text('Tano • v1.1.0', style: TextStyle(color: Colors.grey.shade600))),
        ],
      ),
    );
  }

  Widget _heroCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF2477B9), Color(0xFF45A3D9)], begin: Alignment.topRight, end: Alignment.bottomLeft),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.16), blurRadius: 18, offset: const Offset(0, 8))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t('الحالة الحالية', 'Current status'), style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 7),
      Text(t('القراءات مستقرة', 'Readings are stable'), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      Row(children: [const Icon(Icons.verified, color: Colors.white), const SizedBox(width: 8), Text(t('آخر تحديث: الآن', 'Last update: now'), style: const TextStyle(color: Colors.white))]),
    ]),
  );

  Widget _metricCard(IconData icon, String title, String value, String subtitle) => Card(
    elevation: 0,
    child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: const Color(0xFF2477B9)), const SizedBox(height: 12),
      Text(title, style: TextStyle(color: Colors.grey.shade700)), const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 4),
      Text(subtitle, style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
    ]),
  );

  Widget _actionTile(IconData icon, String title, String subtitle, VoidCallback onTap) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: CircleAvatar(backgroundColor: const Color(0xFFEAF4FB), child: Icon(icon, color: const Color(0xFF2477B9))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    ),
  );

  Widget _infoCard() => Card(
    elevation: 0,
    color: const Color(0xFFEAF4FB),
    child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
      const Icon(Icons.info_outline, color: Color(0xFF2477B9), size: 30), const SizedBox(width: 12),
      Expanded(child: Text(t('هذا التطبيق أداة مساعدة ولا يغني عن استشارة الطبيب أو الفحص الطبي.', 'This app is an assistive tool and does not replace professional medical advice or examination.'), style: const TextStyle(height: 1.45))),
    ])),
  );
}

class LivePage extends StatelessWidget {
  final bool arabic;
  const LivePage({super.key, required this.arabic});
  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('المراقبة الحية', 'Live Monitoring'))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFEAF4FB), borderRadius: BorderRadius.circular(20)), child: Row(children: [
          const Icon(Icons.circle, color: Colors.green, size: 13), const SizedBox(width: 8),
          Expanded(child: Text(t('المتابعة تعمل الآن', 'Monitoring is active now'), style: const TextStyle(fontWeight: FontWeight.bold))),
          Text(t('مباشر', 'LIVE'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ])),
        const SizedBox(height: 18),
        _bigReading(Icons.thermostat, t('درجة الحرارة', 'Temperature'), '36.8°C', t('القراءة الحالية', 'Current reading')),
        const SizedBox(height: 12),
        _bigReading(Icons.show_chart, t('الفرق الحراري ΔT', 'Thermal difference ΔT'), '0.4°C', t('متوسط مستقر', 'Stable average')),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _small('37.0°C', t('أعلى قراءة', 'Highest'), Colors.orange)),
          const SizedBox(width: 12),
          Expanded(child: _small('36.5°C', t('أقل قراءة', 'Lowest'), Colors.blue)),
        ]),
        const SizedBox(height: 18),
        Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t('الحالة', 'Status'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Text(t('القراءات ضمن النطاق المعروض حالياً. البيانات في هذه النسخة تجريبية وليست من مستشعر حقيقي.', 'Readings are within the displayed range. In this version the data is demo data and not from a real sensor.')),
        ]))),
      ]),
    );
  }

  Widget _bigReading(IconData icon, String title, String value, String subtitle) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
    Container(width: 54, height: 54, decoration: BoxDecoration(color: const Color(0xFFEAF4FB), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFF2477B9), size: 30)),
    const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)), Text(subtitle, style: const TextStyle(color: Colors.green))]))
  ])));

  Widget _small(String value, String label, Color color) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text(value, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 5), Text(label)])));
}

class HistoryPage extends StatelessWidget {
  final bool arabic;
  const HistoryPage({super.key, required this.arabic});
  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final records = [
      ('24 سبتمبر 2026', '36.8°C', '0.4°C'),
      ('23 سبتمبر 2026', '36.7°C', '0.3°C'),
      ('22 سبتمبر 2026', '36.9°C', '0.5°C'),
      ('21 سبتمبر 2026', '36.6°C', '0.4°C'),
      ('20 سبتمبر 2026', '36.8°C', '0.3°C'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t('السجل التاريخي', 'History Log'))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [const Icon(Icons.calendar_month, color: Color(0xFF2477B9)), const SizedBox(width: 12), Expanded(child: Text(t('القراءات السابقة', 'Previous readings'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))]))),
        const SizedBox(height: 12),
        ...records.map((r) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 10), child: ListTile(
          leading: CircleAvatar(backgroundColor: const Color(0xFFEAF4FB), child: const Icon(Icons.thermostat, color: Color(0xFF2477B9))),
          title: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${t('الحرارة', 'Temp')}: ${r.$2}   •   ΔT: ${r.$3}'),
          trailing: const Icon(Icons.chevron_right),
        ))),
        const SizedBox(height: 6),
        Center(child: Text(t('البيانات المعروضة تجريبية حالياً.', 'The displayed data is currently demo data.'), style: TextStyle(color: Colors.grey.shade600))),
      ]),
    );
  }
}

class AlertsPage extends StatelessWidget {
  final bool arabic;
  const AlertsPage({super.key, required this.arabic});
  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('التنبيهات', 'Alerts'))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        _alert(Icons.check_circle, Colors.green, t('القراءات مستقرة', 'Readings stable'), t('لا توجد تنبيهات عاجلة حالياً.', 'No urgent alerts right now.')),
        _alert(Icons.notifications_none, Colors.orange, t('التحديثات', 'Updates'), t('سيظهر هنا أي تنبيه أو تذكير جديد.', 'New alerts and reminders will appear here.')),
        _alert(Icons.shield_outlined, const Color(0xFF2477B9), t('حماية البيانات', 'Data protection'), t('لا تشارك بياناتك الطبية مع أي جهة من داخل هذه النسخة التجريبية.', 'Do not share medical data with any service from this demo version.')),
      ]),
    );
  }

  Widget _alert(IconData icon, Color color, String title, String body) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 12), child: ListTile(isThreeLine: true, contentPadding: const EdgeInsets.all(14), leading: CircleAvatar(backgroundColor: color.withOpacity(.12), child: Icon(icon, color: color)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(body))));
}

class AiPage extends StatefulWidget {
  final bool arabic;
  const AiPage({super.key, required this.arabic});
  @override State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final controller = TextEditingController();
  bool analyzing = false;
  String result = '';
  String t(String ar, String en) => widget.arabic ? ar : en;

  void analyze() async {
    setState(() => analyzing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      analyzing = false;
      result = t('التحليل التجريبي: نمط القراءات الحالي مستقر، ومتوسط ΔT منخفض. هذا التحليل لا يُعد تشخيصاً طبياً.', 'Demo analysis: the current reading pattern is stable and the average ΔT is low. This is not a medical diagnosis.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('تحليل الذكاء الاصطناعي', 'AI Analysis'))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5B46C5), Color(0xFF2477B9)]), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 34), const SizedBox(height: 12),
          Text(t('مساعد Tano الذكي', 'Tano AI Assistant'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6), Text(t('حلّل نمط القراءات واحصل على شرح مبسط.', 'Analyze your readings and get a simple explanation.'), style: const TextStyle(color: Colors.white70)),
        ])),
        const SizedBox(height: 16),
        Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          TextField(controller: controller, maxLines: 3, decoration: InputDecoration(labelText: t('اكتب سؤالك', 'Ask a question'), hintText: t('مثال: ماذا تعني القراءات الحالية؟', 'Example: What do my current readings mean?'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: analyzing ? null : analyze, icon: const Icon(Icons.auto_awesome), label: Text(analyzing ? t('جاري التحليل...', 'Analyzing...') : t('تحليل الآن', 'Analyze now')))),
        ]))),
        if (result.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.smart_toy, color: Color(0xFF2477B9)), const SizedBox(width: 12), Expanded(child: Text(result, style: const TextStyle(height: 1.5)))]))),
        ],
        const SizedBox(height: 12),
        Card(elevation: 0, color: const Color(0xFFFFF7E6), child: Padding(padding: const EdgeInsets.all(16), child: Text(t('ملاحظة: واجهة الذكاء الاصطناعي جاهزة، لكن الاتصال بخدمة AI خارجية ومفتاح API يحتاجان إعداد خدمة آمنة قبل النشر.', 'Note: the AI interface is ready, but connecting to an external AI service and API key requires secure service setup before publishing.')))),
      ]),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final bool arabic;
  final ValueChanged<bool> onLanguageChanged;
  const SettingsPage({super.key, required this.arabic, required this.onLanguageChanged});
  @override State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool arabic;
  bool notifications = true;
  bool reminders = true;
  bool signedIn = false;

  @override
  void initState() { super.initState(); arabic = widget.arabic; }
  String t(String ar, String en) => arabic ? ar : en;

  void setLang(bool value) {
    setState(() => arabic = value);
    widget.onLanguageChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(t('الإعدادات', 'Settings'))),
        body: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 28), children: [
          _profileCard(),
          const SizedBox(height: 14),
          _sectionTitle(t('الحساب', 'Account')),
          Card(elevation: 0, child: Column(children: [
            ListTile(leading: const Icon(Icons.account_circle_outlined, color: Color(0xFF2477B9)), title: Text(signedIn ? t('حساب Google متصل', 'Google account connected') : t('تسجيل الدخول بحساب Google', 'Sign in with Google')), subtitle: Text(signedIn ? 'Google' : t('للمزامنة وحماية الحساب', 'For account sync and protection')), trailing: const Icon(Icons.chevron_right), onTap: _googleSignIn),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.person_outline), title: Text(t('الملف الشخصي', 'Profile')), subtitle: Text(t('الاسم والصورة الشخصية', 'Name and profile photo')), trailing: const Icon(Icons.chevron_right), onTap: _profileDialog),
          ])),
          const SizedBox(height: 14),
          _sectionTitle(t('اللغة', 'Language')),
          Card(elevation: 0, child: SwitchListTile(value: arabic, onChanged: setLang, title: Text(t('العربية', 'Arabic')), subtitle: Text(arabic ? 'عربي' : 'English'), secondary: const Icon(Icons.language))),
          const SizedBox(height: 14),
          _sectionTitle(t('الإشعارات', 'Notifications')),
          Card(elevation: 0, child: Column(children: [
            SwitchListTile(value: notifications, onChanged: (v) => setState(() => notifications = v), title: Text(t('الإشعارات', 'Notifications')), subtitle: Text(t('استقبال التنبيهات المهمة', 'Receive important alerts')), secondary: const Icon(Icons.notifications_outlined)),
            const Divider(height: 1),
            SwitchListTile(value: reminders, onChanged: notifications ? (v) => setState(() => reminders = v) : null, title: Text(t('التذكيرات', 'Reminders')), subtitle: Text(t('تذكير بمراجعة القراءات', 'Remind me to review readings')), secondary: const Icon(Icons.alarm_outlined)),
          ])),
          const SizedBox(height: 14),
          _sectionTitle(t('الخصوصية والأمان', 'Privacy & Security')),
          Card(elevation: 0, child: Column(children: [
            ListTile(leading: const Icon(Icons.lock_outline), title: Text(t('خصوصية البيانات', 'Data privacy')), subtitle: Text(t('تحكم في بياناتك وإعدادات الحساب', 'Control your data and account settings')), trailing: const Icon(Icons.chevron_right)),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.info_outline), title: Text(t('عن Tano', 'About Tano')), subtitle: const Text('Tano v1.1.0'), trailing: const Icon(Icons.chevron_right)),
          ])),
          const SizedBox(height: 18),
          Text(t('ملاحظة: تسجيل Google والإشعارات الفورية الحقيقية يحتاجان ربط Firebase/Google وإعدادات التطبيق الخاصة بالمشروع قبل النشر.', 'Note: real Google sign-in and push notifications require Firebase/Google project configuration before publishing.'), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)));

  Widget _profileCard() => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
    CircleAvatar(radius: 32, backgroundColor: const Color(0xFFEAF4FB), child: const Icon(Icons.person, size: 36, color: Color(0xFF2477B9))),
    const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(signedIn ? t('حسابي', 'My account') : t('مرحباً بك في Tano', 'Welcome to Tano'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(signedIn ? 'Google' : t('أضف حسابك لتفعيل المزامنة', 'Add your account to enable sync'), style: TextStyle(color: Colors.grey.shade700))])),
  ])));

  void _googleSignIn() {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text(t('حساب Google', 'Google account')), content: Text(t('واجهة تسجيل Google جاهزة هنا، لكن تسجيل الدخول الحقيقي يحتاج ربط Google/Firebase بالمشروع.', 'The Google sign-in interface is ready here, but real sign-in requires Google/Firebase project configuration.')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t('إلغاء', 'Cancel'))), FilledButton(onPressed: () { Navigator.pop(context); setState(() => signedIn = true); }, child: Text(t('تجربة الحساب', 'Demo account')))]));
  }

  void _profileDialog() {
    final name = TextEditingController(text: t('مستخدم Tano', 'Tano User'));
    showDialog(context: context, builder: (_) => AlertDialog(title: Text(t('الملف الشخصي', 'Profile')), content: TextField(controller: name, decoration: InputDecoration(labelText: t('الاسم', 'Name'))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t('إلغاء', 'Cancel'))), FilledButton(onPressed: () => Navigator.pop(context), child: Text(t('حفظ', 'Save')))]));
  }
}
