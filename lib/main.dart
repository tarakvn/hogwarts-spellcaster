import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:torch_light/torch_light.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HogwartsApp());
}

class HogwartsApp extends StatelessWidget {
  const HogwartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hogwarts Spellcaster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFC9A227),
        scaffoldBackgroundColor: const Color(0xFF0D0515),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ===================== SPELL DATA =====================
class Spell {
  final String id;
  final String name;
  final String incant;
  final String type;
  final List<String> keywords;
  final String desc;
  final String lore;
  final IconData icon;

  const Spell({
    required this.id,
    required this.name,
    required this.incant,
    required this.type,
    required this.keywords,
    required this.desc,
    required this.lore,
    required this.icon,
  });
}

const List<Spell> allSpells = [
  Spell(
    id: 'lumos',
    name: 'Lumos',
    incant: 'لوموس',
    type: 'Charm',
    keywords: ['lumos', 'لوموس'],
    desc: 'چراغ‌قوه نوک چوبدستی را روشن می‌کند و نور ملایمی ایجاد می‌کند.',
    lore: 'یکی از اولین طلسم‌هایی است که دانش‌آموزان سال اول یاد می‌گیرند. توسط جادوگرانی که در تاریکی نیاز به نور داشتند ابداع شد.',
    icon: Icons.lightbulb,
  ),
  Spell(
    id: 'nox',
    name: 'Nox',
    incant: 'ناکس',
    type: 'Charm',
    keywords: ['nox', 'ناکس'],
    desc: 'اثر طلسم Lumos را خنثی می‌کند و نور چوبدستی را خاموش می‌سازد.',
    lore: 'طلسم متقابل Lumos. معمولاً بلافاصله بعد از یادگیری Lumos آموزش داده می‌شود.',
    icon: Icons.lightbulb_outline,
  ),
  Spell(
    id: 'wingardium',
    name: 'Wingardium Leviosa',
    incant: 'وینگاردیم لویوسا',
    type: 'Charm',
    keywords: ['wingardium', 'leviosa', 'وینگاردیم', 'لویوسا'],
    desc: 'اجسام را شناور و قابل کنترل در هوا می‌کند. یکی از معروف‌ترین طلسم‌های Levitation است.',
    lore: 'در سال اول توسط پروفسور فلیتوک تدریس می‌شود. معروف‌ترین استفاده آن توسط هرمیونه برای شناور کردن پر است.',
    icon: Icons.air,
  ),
  Spell(
    id: 'incendio',
    name: 'Incendio',
    incant: 'اینسندیو',
    type: 'Charm',
    keywords: ['incendio', 'اینسندیو', 'آتش'],
    desc: 'آتش تولید می‌کند. می‌تواند برای روشن کردن شمع یا ایجاد دیوار آتش استفاده شود.',
    lore: 'طلسم آتش‌زای کلاسیک. نسخه‌های قوی‌تر مانند Fiendfyre بسیار خطرناک‌تر هستند.',
    icon: Icons.local_fire_department,
  ),
  Spell(
    id: 'expelliarmus',
    name: 'Expelliarmus',
    incant: 'اکسپلیارموس',
    type: 'Charm',
    keywords: ['expelliarmus', 'اکسپلیارموس'],
    desc: 'سلاح یا چوبدستی حریف را از دستش می‌پراند.',
    lore: 'امضای هری پاتر. در دوئل‌های متعدد از جمله نبرد نهایی با ولدمورت استفاده شد.',
    icon: Icons.flash_on,
  ),
  Spell(
    id: 'patronum',
    name: 'Expecto Patronum',
    incant: 'اکسپکتو پاترونوم',
    type: 'Charm',
    keywords: ['expecto', 'patronum', 'پاترونوم'],
    desc: 'یک نگهبان نقره‌ای (Patronus) از خاطرات خوش ایجاد می‌کند که در برابر Dementor محافظت می‌کند.',
    lore: 'یکی از پیشرفته‌ترین و دشوارترین طلسم‌های دفاعی. شکل Patronus برای هر فرد منحصر به فرد است.',
    icon: Icons.auto_awesome,
  ),
  Spell(
    id: 'accio',
    name: 'Accio',
    incant: 'آکیو',
    type: 'Charm',
    keywords: ['accio', 'آکیو'],
    desc: 'شیء مورد نظر را به سمت جادوگر می‌کشد (Summoning Charm).',
    lore: 'در سال چهارم توسط مادام هوف تدریس شد. هری از آن برای احضار جاروی خود استفاده کرد.',
    icon: Icons.arrow_downward,
  ),
  Spell(
    id: 'protego',
    name: 'Protego',
    incant: 'پروتگو',
    type: 'Charm',
    keywords: ['protego', 'پروتگو'],
    desc: 'یک سپر جادویی ایجاد می‌کند که طلسم‌های جزئی را دفع یا منحرف می‌کند.',
    lore: 'پایه دفاعی. نسخه‌های قوی‌تر مانند Protego Maxima برای محافظت از مکان‌های بزرگ استفاده می‌شوند.',
    icon: Icons.shield,
  ),
  Spell(
    id: 'stupefy',
    name: 'Stupefy',
    incant: 'استوپفای',
    type: 'Charm',
    keywords: ['stupefy', 'استوپفای'],
    desc: 'حریف را بیهوش و بی‌حرکت می‌کند (Stunning Spell).',
    lore: 'یکی از پرکاربردترین طلسم‌های دوئل. پرتو قرمز رنگی تولید می‌کند.',
    icon: Icons.bolt,
  ),
];

// ===================== HOME PAGE =====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _status = 'برای شروع روی میکروفون بزن';
  String _lastHeard = 'منتظر طلسم...';
  bool _torchOn = false;

  // انیمیشن‌ها
  late AnimationController _featherController;
  late AnimationController _fireController;
  bool _showFeather = false;
  bool _showFire = false;
  bool _showFlash = false;

  @override
  void initState() {
    super.initState();
    _featherController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _fireController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.camera.request(); // برای چراغ‌قوه در بعضی گوشی‌ها لازم است
  }

  @override
  void dispose() {
    _featherController.dispose();
    _fireController.dispose();
    super.dispose();
  }

  // ---------- تشخیص صدا ----------
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
        _status = 'گوش دادن متوقف شد';
      });
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          // اگر هنوز باید گوش بده، دوباره شروع کن
          if (_isListening) {
            _startListening();
          }
        }
      },
      onError: (error) {
        setState(() {
          _status = 'خطا در تشخیص صدا';
          _isListening = false;
        });
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _status = 'در حال گوش دادن... طلسم بگو';
      });
      _startListening();
    } else {
      setState(() {
        _status = 'تشخیص صدا در دسترس نیست';
      });
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final text = result.recognizedWords.toLowerCase();
          setState(() => _lastHeard = result.recognizedWords);
          _castSpell(text);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: false,
      localeId: 'en_US', // برای طلسم‌های انگلیسی بهتر است
      cancelOnError: false,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  // ---------- کنترل چراغ‌قوه ----------
  Future<void> _setTorch(bool on) async {
    try {
      if (on) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
      setState(() => _torchOn = on);
    } catch (e) {
      // بعضی گوشی‌ها پشتیبانی نمی‌کنند
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('چراغ‌قوه روی این دستگاه پشتیبانی نمی‌شود')),
      );
    }
  }

  // ---------- اجرای طلسم ----------
  void _castSpell(String text) {
    for (final spell in allSpells) {
      if (spell.keywords.any((k) => text.contains(k))) {
        switch (spell.id) {
          case 'lumos':
            _setTorch(true);
            _triggerFlash();
            setState(() => _lastHeard = '✨ Lumos! چراغ روشن شد');
            break;
          case 'nox':
            _setTorch(false);
            setState(() => _lastHeard = '🌑 Nox! چراغ خاموش شد');
            break;
          case 'wingardium':
            _triggerFeather();
            setState(() => _lastHeard = '🪶 Wingardium Leviosa!');
            break;
          case 'incendio':
            _triggerFire();
            setState(() => _lastHeard = '🔥 Incendio!');
            break;
          case 'expelliarmus':
            _triggerFlash();
            setState(() => _lastHeard = '⚡ Expelliarmus!');
            break;
          case 'patronum':
            _triggerFlash();
            setState(() => _lastHeard = '🦌 Expecto Patronum!');
            break;
          default:
            setState(() => _lastHeard = '✨ ${spell.name}!');
        }
        return;
      }
    }
  }

  void _triggerFeather() {
    setState(() => _showFeather = true);
    _featherController.forward(from: 0).then((_) {
      setState(() => _showFeather = false);
    });
  }

  void _triggerFire() {
    setState(() => _showFire = true);
    _fireController.forward(from: 0).then((_) {
      setState(() => _showFire = false);
    });
  }

  void _triggerFlash() {
    setState(() => _showFlash = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showFlash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // پس‌زمینه
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A0A2E), Color(0xFF0D0515)],
              ),
            ),
          ),

          // محتوای اصلی
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  '✨ Hogwarts Spellcaster',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC9A227),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _status,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // دکمه میکروفون
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFC9A227), width: 3),
                      color: _isListening
                          ? const Color(0xFFC9A227).withOpacity(0.35)
                          : const Color(0xFFC9A227).withOpacity(0.12),
                      boxShadow: _isListening
                          ? [
                              BoxShadow(
                                color: const Color(0xFFC9A227).withOpacity(0.6),
                                blurRadius: 25,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 42,
                      color: const Color(0xFFC9A227),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // لاگ
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF5C4A1E)),
                  ),
                  child: Text(
                    _lastHeard,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),

                const Spacer(),

                // دکمه کتاب طلسم‌ها
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SpellbookPage()),
                      );
                    },
                    icon: const Icon(Icons.menu_book),
                    label: const Text('کتاب طلسم‌ها'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A227).withOpacity(0.15),
                      foregroundColor: const Color(0xFFC9A227),
                      side: const BorderSide(color: Color(0xFFC9A227)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // فلش نور
          if (_showFlash)
            AnimatedOpacity(
              opacity: _showFlash ? 0.4 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(color: const Color(0xFFFFFAC8)),
            ),

          // پر
          if (_showFeather)
            AnimatedBuilder(
              animation: _featherController,
              builder: (context, child) {
                final value = _featherController.value;
                return Positioned(
                  left: MediaQuery.of(context).size.width * (0.3 + 0.4 * value),
                  top: MediaQuery.of(context).size.height * (0.7 - 0.8 * value),
                  child: Transform.rotate(
                    angle: value * 6,
                    child: const Text('🪶', style: TextStyle(fontSize: 48)),
                  ),
                );
              },
            ),

          // آتش
          if (_showFire)
            ...List.generate(12, (i) {
              return AnimatedBuilder(
                animation: _fireController,
                builder: (context, child) {
                  final progress = (_fireController.value + i * 0.08) % 1.0;
                  return Positioned(
                    left: MediaQuery.of(context).size.width * (0.1 + (i % 6) * 0.15),
                    bottom: MediaQuery.of(context).size.height * progress * 0.7,
                    child: Opacity(
                      opacity: 1 - progress,
                      child: Text(
                        i % 2 == 0 ? '🔥' : '✨',
                        style: TextStyle(fontSize: 20 + (1 - progress) * 20),
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }
}

// ===================== SPELLBOOK =====================
class SpellbookPage extends StatelessWidget {
  const SpellbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0515),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0515),
        title: const Text(
          'کتاب طلسم‌های هاگوارتز',
          style: TextStyle(color: Color(0xFFC9A227)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFC9A227)),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allSpells.length,
        itemBuilder: (context, index) {
          final spell = allSpells[index];
          return Card(
            color: const Color(0xFF1E0F32).withOpacity(0.7),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFF5C4A1E)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Icon(spell.icon, color: const Color(0xFFC9A227), size: 32),
              title: Text(
                spell.name,
                style: const TextStyle(
                  color: Color(0xFFC9A227),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                '${spell.incant}  ·  ${spell.type}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpellDetailPage(spell: spell),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ===================== DETAIL =====================
class SpellDetailPage extends StatelessWidget {
  final Spell spell;
  const SpellDetailPage({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0515),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0515),
        iconTheme: const IconThemeData(color: Color(0xFFC9A227)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spell.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC9A227),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              spell.incant,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC9A227)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                spell.type,
                style: const TextStyle(color: Color(0xFFC9A227), fontSize: 13),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'توضیح اثر',
              style: TextStyle(
                color: Color(0xFFC9A227),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              spell.desc,
              style: const TextStyle(color: Colors.white, height: 1.6, fontSize: 15),
            ),
            const SizedBox(height: 24),
            const Text(
              'تاریخچه و لور',
              style: TextStyle(
                color: Color(0xFFC9A227),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              spell.lore,
              style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
