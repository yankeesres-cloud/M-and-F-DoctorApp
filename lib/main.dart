import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/demo_repository.dart';
import 'services/chat_service.dart';
import 'services/device_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'M&F — Sexual & Mental Wellness',
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [Locale('hi'), Locale('en')],
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Brand.teal,
        primary: Brand.teal,
        secondary: const Color(0xff8b77bd),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Brand.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Brand.ink,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Brand.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Brand.teal,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Brand.ink,
          side: const BorderSide(color: Brand.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Brand.mint,
      ),
    ),
    home: const WellnessApp(),
  );
}

/// Conversation topics: main topic → group → subsection → concern.
/// Men's sexual-health lists follow the M&F web design.
class Topic {
  final Label label;
  final List<Topic> children;
  const Topic(this.label, [this.children = const []]);
}

const topicTree = [
  Topic(Label('यौन स्वास्थ्य', 'Sexual health'), [
    Topic(Label('पुरुषों से संबंधित समस्याएँ', "Men's concerns"), [
      Topic(Label('यौन समस्याएँ', 'Sexual problems'), [
        Topic(Label('शीघ्रपतन', 'Premature ejaculation')),
        Topic(
          Label(
            'इरेक्शन बनने या बनाए रखने में परेशानी',
            'Trouble getting or keeping an erection',
          ),
        ),
        Topic(Label('यौन इच्छा में कमी', 'Low sexual desire')),
        Topic(Label('विलंबित स्खलन', 'Delayed ejaculation')),
        Topic(Label('स्खलन न होना', 'No ejaculation')),
        Topic(Label('स्वप्नदोष को लेकर चिंता', 'Worry about night emissions')),
        Topic(Label('धात संबंधी चिंता', 'Worry about dhat')),
        Topic(
          Label(
            'वीर्य की मात्रा या गुणवत्ता को लेकर चिंता',
            'Worry about semen amount or quality',
          ),
        ),
        Topic(Label('लिंग में दर्द या टेढ़ापन', 'Penile pain or curvature')),
        Topic(Label('प्रदर्शन संबंधी चिंता', 'Performance anxiety')),
      ]),
      Topic(Label('प्रजनन संबंधी समस्याएँ', 'Fertility problems'), [
        Topic(
          Label(
            'पुरुष प्रजनन क्षमता / गर्भधारण में कठिनाई',
            'Male fertility / difficulty conceiving',
          ),
        ),
        Topic(Label('शुक्राणुओं की संख्या कम होना', 'Low sperm count')),
        Topic(Label('शुक्राणुओं की गतिशीलता में कमी', 'Low sperm motility')),
      ]),
      Topic(Label('यौन संक्रमण एवं लक्षण', 'Sexual infections and symptoms'), [
        Topic(Label('HIV से जुड़ा सवाल', 'A question about HIV')),
        Topic(Label('सिफलिस', 'Syphilis')),
        Topic(Label('गोनोरिया', 'Gonorrhoea')),
        Topic(Label('क्लैमाइडिया', 'Chlamydia')),
        Topic(Label('जननांग हर्पीज', 'Genital herpes')),
        Topic(Label('HPV / जननांग मस्से', 'HPV / genital warts')),
        Topic(
          Label(
            'जननांगों में खुजली, जलन या असामान्य स्राव',
            'Genital itching, burning or unusual discharge',
          ),
        ),
      ]),
    ]),
    Topic(Label('महिलाओं से संबंधित समस्याएँ', "Women's concerns"), [
      Topic(Label('यौन समस्याएँ', 'Sexual problems'), [
        Topic(Label('यौन इच्छा में कमी', 'Low sexual desire')),
        Topic(Label('संबंध के दौरान दर्द', 'Pain during sex')),
        Topic(Label('उत्तेजना या चरम सुख में कठिनाई', 'Difficulty with arousal or orgasm')),
        Topic(Label('प्रदर्शन या शरीर को लेकर चिंता', 'Worry about performance or body')),
      ]),
      Topic(Label('प्रजनन संबंधी समस्याएँ', 'Fertility problems'), [
        Topic(Label('गर्भधारण में कठिनाई', 'Difficulty conceiving')),
        Topic(Label('अनियमित मासिक धर्म', 'Irregular periods')),
      ]),
      Topic(Label('यौन संक्रमण एवं लक्षण', 'Sexual infections and symptoms'), [
        Topic(
          Label(
            'योनि में खुजली, जलन या असामान्य स्राव',
            'Vaginal itching, burning or unusual discharge',
          ),
        ),
        Topic(Label('HIV या अन्य STI से जुड़ा सवाल', 'A question about HIV or other STIs')),
      ]),
    ]),
  ]),
  Topic(Label('मानसिक स्वास्थ्य', 'Mental health'), [
    Topic(Label('चिंता और मनोदशा', 'Anxiety and mood'), [
      Topic(Label('बार-बार चिंता', 'Frequent worry')),
      Topic(Label('उदासी', 'Low mood')),
    ]),
    Topic(Label('नींद और दिनचर्या', 'Sleep and routine'), [
      Topic(Label('नींद में परेशानी', 'Trouble sleeping')),
      Topic(Label('थकान', 'Fatigue')),
    ]),
    Topic(Label('रिश्ते', 'Relationships'), [
      Topic(Label('बात शुरू करना', 'Starting a conversation')),
      Topic(Label('मतभेद', 'Disagreements')),
      Topic(Label('विश्वास की चिंता', 'Trust concerns')),
    ]),
  ]),
];

/// Colours taken from the M&F customer web design.
abstract final class Brand {
  static const teal = Color(0xff23706b);
  static const ink = Color(0xff1c2b33);
  static const muted = Color(0xff5b6870);
  static const background = Color(0xfff0f5f2);
  static const border = Color(0xffe2e9e5);
  static const mint = Color(0xffe3f3ec);
  static const heroCard = Color(0xffdaeae5);
  static const lavender = Color(0xffede4f6);
  static const peach = Color(0xfffbebdd);
  static const cream = Color(0xfff6f6e6);
  static const videoGreen = Color(0xffe3e9e3);
  static const videoLavender = Color(0xffeae2f0);
  static const videoPeach = Color(0xfff1e6da);
}

class WellnessApp extends StatefulWidget {
  const WellnessApp({super.key});
  @override
  State<WellnessApp> createState() => _WellnessAppState();
}

class _WellnessAppState extends State<WellnessApp> {
  bool hindi = true, busy = false;
  int page = 0, stars = 0;
  final WellnessRepository repository = DemoRepository();
  final ChatService chatService = DemoChatService();
  final device = DeviceService();
  final input = TextEditingController(), feedback = TextEditingController();
  final messages = <ChatMessage>[];
  final selections = <Topic>[];
  Topic? concern;
  final inputFocus = FocusNode();
  final kit = <Product, int>{};
  final appointments = <Label>[];
  DateTime date = DateTime.now();
  int slide = 0;
  bool autoplay = true;
  Timer? slideTimer;
  @override
  void initState() {
    super.initState();
    slideTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (autoplay && page == 0 && mounted) {
        setState(() => slide = (slide + 1) % heroSlides.length);
      }
    });
  }

  String? slot;
  int doctorIndex = 0, generation = 0;
  String t(String hi, String en) => hindi ? hi : en;
  String l(Label label) => label.text(hindi);
  @override
  void dispose() {
    slideTimer?.cancel();
    input.dispose();
    inputFocus.dispose();
    feedback.dispose();
    super.dispose();
  }

  void go(int value) => setState(() => page = value);
  void notice(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> preview(String title, String body) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(body)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('बंद करें', 'Close')),
        ),
      ],
    ),
  );
  Widget heading(String hi, String en) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(t(hi, en), style: Theme.of(context).textTheme.headlineSmall),
  );
  Widget card(Widget child) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
  Widget action(String hi, String en, IconData icon, VoidCallback onTap) =>
      card(
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Brand.teal),
          title: Text(t(hi, en)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
  Widget banner() => card(
    Text(
      t(
        'स्थानीय डेमो • AI बंद है। मोबाइल API और authentication अभी pending हैं। भुगतान, बुकिंग या संदेश भेजना उपलब्ध नहीं है।',
        'Local demo • AI is off. Mobile API and authentication are pending. Payments, booking and delivery of messages are unavailable.',
      ),
    ),
  );
  Widget helpline() => Card(
    color: const Color(0xfffff4e5),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        t(
          'मदद तुरंत चाहिए? मानसिक स्वास्थ्य हेल्पलाइन Tele-MANAS: 14416 (24x7, निःशुल्क)। जान का खतरा या आपात स्थिति: 112।',
          'Need help now? Mental health helpline Tele-MANAS: 14416 (24x7, free). Danger to life or emergency: 112.',
        ),
      ),
    ),
  );
  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  List<String> openSlots() {
    final now = DateTime.now();
    return repository.slots(date).where((s) {
      final parts = s.split(':');
      final at = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      return at.isAfter(now);
    }).toList();
  }

  // Bottom bar (same as web): Home, My Kit, Store, Profile.
  static const navPages = [0, 6, 3, 9];
  int get navIndex => switch (page) {
    6 => 1,
    3 => 2,
    9 || 4 || 5 => 3,
    _ => 0,
  };
  @override
  Widget build(BuildContext context) {
    final titles = [
      t('होम', 'Home'),
      t('बातचीत', 'Chat'),
      t('डॉक्टर', 'Doctors'),
      t('स्टोर', 'Store'),
      t('मेरी देखभाल', 'My Care'),
      t('रेटिंग', 'Rating'),
      t('मेरी किट', 'My Kit'),
      t('वीडियो', 'Videos'),
      t('सवाल-जवाब', 'FAQ'),
      t('प्रोफाइल', 'Profile'),
    ];
    return Localizations.override(
      context: context,
      locale: Locale(hindi ? 'hi' : 'en'),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'M&F',
                style: TextStyle(
                  color: Brand.teal,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Text(
                'SEXUAL & MENTAL WELLNESS',
                style: TextStyle(
                  color: Brand.teal,
                  fontSize: 8,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            DropdownButton<bool>(
              value: hindi,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: true, child: Text('हिंदी')),
                DropdownMenuItem(value: false, child: Text('English')),
              ],
              onChanged: (value) => setState(() => hindi = value!),
            ),
            IconButton(
              tooltip: t('गोपनीयता', 'Privacy'),
              onPressed: privacy,
              icon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: ListView(
            // New scroll position per page, so every page opens at the top.
            key: ValueKey(page),
            padding: const EdgeInsets.all(16),
            children: [
              if (!navPages.contains(page))
                TextButton.icon(
                  onPressed: () => go(0),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(t('होम पर जाएँ', 'Go home')),
                ),
              if (page != 0) heading(titles[page], titles[page]),
              ...content(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navIndex,
          onDestinationSelected: (i) => go(navPages[i]),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              label: titles[0],
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              label: titles[6],
            ),
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              label: titles[3],
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              label: titles[9],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> content() => switch (page) {
    1 => chat(),
    2 => doctors(),
    3 => store(),
    4 => care(),
    5 => rating(),
    6 => myKit(),
    7 => videos(),
    8 => faq(),
    9 => profile(),
    _ => home(),
  };
  Widget pill(String text, {IconData? icon}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Brand.mint,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Brand.teal),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Brand.ink),
          ),
        ),
      ],
    ),
  );
  Widget iconTile(IconData icon, Color background) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: Brand.ink),
  );
  Widget serviceCard(
    String hi,
    String en,
    String subHi,
    String subEn,
    IconData icon,
    Color tile,
    int target,
  ) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => go(target),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconTile(icon, tile),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: Text(
                    t(hi, en),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.north_east, color: Brand.teal, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t(subHi, subEn),
              style: const TextStyle(color: Brand.muted, height: 1.5),
            ),
          ],
        ),
      ),
    ),
  );
  Widget section(String hi, String en, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            t(hi, en),
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
        ),
        ?trailing,
      ],
    ),
  );

  static const heroSlides = [
    [
      Label('अपनी गति से।\nअपने लिए।', 'At your pace.\nFor you.'),
      Label(
        'तनाव और रिश्तों के सवाल पर मदद की शुरुआत करें।',
        'Start getting help with stress and relationship questions.',
      ),
    ],
    [
      Label(
        'मन की बात हो या\nसेहत का सवाल।',
        'A matter of the mind\nor a health question.',
      ),
      Label(
        'बिना नाम या मोबाइल नंबर के, अपनी गति से शुरू करें।',
        'Start without a name or mobile number, at your own pace.',
      ),
    ],
    [
      Label('बिना शर्म,\nबिना जल्दी।', 'No shame,\nno hurry.'),
      Label(
        'जितना सहज लगे, उतना बताएँ। विशेषज्ञ आपकी बात समझते हैं।',
        'Share only what feels comfortable. Experts understand you.',
      ),
    ],
  ];

  Widget heroCard() {
    final s = heroSlides[slide];
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Brand.heroCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('M&F की पहल · प्रचार', 'AN M&F INITIATIVE · PROMOTION'),
            style: const TextStyle(
              color: Brand.teal,
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l(s[0]),
            style: const TextStyle(
              fontSize: 32,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(l(s[1]), style: const TextStyle(color: Brand.muted)),
          const SizedBox(height: 20),
          Center(child: heroArt()),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => go(1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t('अपनी बात बताएँ', 'Share your concern'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.north_east, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < heroSlides.length; i++)
                GestureDetector(
                  onTap: () => setState(() => slide = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width: i == slide ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == slide ? Brand.teal : const Color(0xffa9c3bd),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => autoplay = !autoplay),
                child: Text(
                  autoplay ? t('रोकें', 'Pause') : t('चलाएँ', 'Play'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget floatingNote(IconData icon, String hi, String en) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Brand.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Brand.ink),
        const SizedBox(width: 8),
        Text(t(hi, en), style: const TextStyle(fontSize: 12)),
      ],
    ),
  );

  Widget heroArt() => SizedBox(
    width: 260,
    height: 230,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffb7cdc8)),
          ),
        ),
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Brand.cream,
          ),
          child: const Icon(
            Icons.emergency,
            size: 64,
            color: Brand.teal,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: floatingNote(
            Icons.auto_awesome_outlined,
            'एक छोटा कदम, अपने लिए',
            'A small step, for you',
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: floatingNote(
            Icons.favorite_border,
            'हम सुनने के लिए हैं',
            'We are here to listen',
          ),
        ),
      ],
    ),
  );

  static const videoTopics = [
    [
      'MENTAL WELLNESS',
      Label('बात करने की शुरुआत', 'Starting the conversation'),
      Label('वीडियो के लिए निर्धारित स्थान', 'Reserved space for video'),
      Label(
        'अपनी भावना को शांत शब्दों में लिखें। बात करने के लिए सही समय पूछें।',
        'Write your feelings in calm words. Ask for a good time to talk.',
      ),
    ],
    [
      'SEXUAL WELLNESS',
      Label('सवाल पूछना सामान्य है', 'Asking questions is normal'),
      Label('वीडियो के लिए निर्धारित स्थान', 'Reserved space for video'),
      Label(
        'शरीर और रिश्तों के बारे में सवाल पूछना स्वाभाविक है। विशेषज्ञ बिना judge किए सुनते हैं।',
        'Questions about the body and relationships are natural. Experts listen without judging.',
      ),
    ],
    [
      'YOUR STORY',
      Label('डॉक्टर के लिए वीडियो', 'Video for doctors'),
      Label('निजी वीडियो का स्थानीय प्रीव्यू', 'Local preview of a private video'),
      Label(
        'निजी वीडियो का स्थानीय preview। अभी कुछ upload या साझा नहीं होता।',
        'Local preview of a private video. Nothing is uploaded or shared yet.',
      ),
    ],
  ];
  static const videoColors = [
    Brand.videoGreen,
    Brand.videoLavender,
    Brand.videoPeach,
  ];

  Widget videoCard(int i, {double? width}) {
    final v = videoTopics[i];
    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => preview(
            t('पाठ preview • वीडियो नहीं', 'Text preview • No video'),
            l(v[3] as Label),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: videoColors[i],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(
                      i == 2 ? Icons.add : Icons.play_arrow_outlined,
                      color: Brand.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  v[0] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: Brand.teal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l(v[1] as Label),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l(v[2] as Label),
                  style: const TextStyle(color: Brand.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const faqs = [
    [
      Label(
        'क्या शुरुआत में मोबाइल नंबर देना जरूरी है?',
        'Do I need to give a mobile number to start?',
      ),
      Label(
        'नहीं। login की ज़रूरत नहीं है और आप सवाल छोड़ भी सकते हैं। संपर्क जानकारी बाद में booking या order के समय माँगी जाएगी।',
        'No. Login is not needed and you can skip questions. Contact details are asked later, for booking or orders.',
      ),
    ],
    [
      Label('मेरी जानकारी कौन देख सकता है?', 'Who can see my information?'),
      Label(
        'यह prototype कोई data server पर नहीं भेजता। Live app में जानकारी आपकी अनुमति और भूमिका के आधार पर ही विशेषज्ञों से साझा होगी।',
        'This prototype sends no data to a server. In the live app, information is shared with experts only based on your consent and their role.',
      ),
    ],
    [
      Label('क्या AI दवा लिखेगा?', 'Will AI prescribe medicine?'),
      Label(
        'नहीं। AI केवल जानकारी जुटाने में मदद करता है। प्रिस्क्रिप्शन केवल licensed डॉक्टर की समीक्षा के बाद मिलता है।',
        'No. AI only helps gather information. Prescriptions come only after review by a licensed doctor.',
      ),
    ],
    [
      Label('मेरी किट कहाँ दिखेगी?', 'Where will my kit appear?'),
      Label(
        'डॉक्टर की सलाह के बाद निर्देश और order की स्थिति "मेरी किट" में दिखेगी।',
        'After a doctor\'s advice, instructions and order status will appear in "My Kit".',
      ),
    ],
    [
      Label('शीघ्रपतन क्या है?', 'What is premature ejaculation?'),
      Label(
        'जब ज़्यादातर बार संबंध के दौरान वीर्य बहुत जल्दी, अपनी इच्छा से पहले निकल जाए और इससे परेशानी हो। यह आम है और अक्सर इलाज योग्य है। तनाव और चिंता इसे बढ़ा सकते हैं। सही कारण और उपाय के लिए डॉक्टर से बात करें।',
        'When ejaculation usually happens sooner than wanted during sex and causes distress. It is common and often treatable. Stress and anxiety can make it worse. Talk to a doctor about the cause and options.',
      ),
    ],
    [
      Label(
        'इरेक्शन की कमी का क्या मतलब है?',
        'What does difficulty with erections mean?',
      ),
      Label(
        'संबंध के लिए पर्याप्त इरेक्शन बार-बार न बन पाना या न टिक पाना। कभी-कभार होना सामान्य है। लगातार हो तो यह डायबिटीज़, BP, दिल की सेहत या तनाव का संकेत हो सकता है, इसलिए डॉक्टर से जाँच कराएँ।',
        'Repeatedly being unable to get or keep an erection firm enough for sex. Occasional difficulty is normal. If it keeps happening it can be linked to diabetes, blood pressure, heart health or stress, so get a doctor\'s check-up.',
      ),
    ],
    [
      Label('क्या स्वप्नदोष हमेशा बीमारी है?', 'Are night emissions always an illness?'),
      Label(
        'नहीं। नींद में वीर्य निकलना (स्वप्नदोष) शरीर की सामान्य प्रक्रिया है, खासकर युवाओं में। इससे कमज़ोरी नहीं आती। अगर इसके साथ दर्द, जलन या कोई और परेशानी हो तो डॉक्टर से मिलें।',
        'No. Ejaculation during sleep (night emission) is a normal body process, especially in young people. It does not cause weakness. See a doctor if it comes with pain, burning or other problems.',
      ),
    ],
    [
      Label(
        'धात या सफेद स्राव दिखे तो क्या करें?',
        'What should I do about a white discharge (dhat)?',
      ),
      Label(
        'पेशाब या मल त्याग के समय थोड़ा साफ़/सफेद स्राव अक्सर सामान्य होता है और इससे ताकत कम नहीं होती। अगर स्राव के साथ जलन, दर्द, बदबू या रंग बदलना हो तो यह संक्रमण हो सकता है, डॉक्टर से जाँच कराएँ।',
        'A little clear or white discharge while urinating or passing stool is often normal and does not reduce strength. If it comes with burning, pain, a bad smell or a change in colour it may be an infection, so see a doctor.',
      ),
    ],
    [
      Label(
        'वीर्य की समस्या कैसे पता चलती है?',
        'How are semen problems found?',
      ),
      Label(
        'आमतौर पर वीर्य जाँच (semen analysis) से, जिसमें शुक्राणुओं की संख्या, गति और आकार देखे जाते हैं। जाँच डॉक्टर की सलाह पर, बताए गए निर्देशों के अनुसार करानी चाहिए।',
        'Usually with a semen analysis, which checks sperm count, movement and shape. Get it done on a doctor\'s advice, following the instructions given.',
      ),
    ],
    [
      Label(
        'पुरुष संतानहीनता की जाँच कैसे होती है?',
        'How is male infertility checked?',
      ),
      Label(
        'डॉक्टर इतिहास पूछते हैं, शारीरिक जाँच करते हैं और वीर्य जाँच कराते हैं। ज़रूरत हो तो हार्मोन की खून जाँच या ultrasound भी हो सकता है। अक्सर दोनों साथियों की जाँच साथ में की जाती है।',
        'A doctor takes your history, does a physical exam and orders a semen analysis. Hormone blood tests or an ultrasound may follow if needed. Often both partners are checked together.',
      ),
    ],
    [
      Label(
        'क्या इम्पोटेंस और इरेक्शन की परेशानी अलग हैं?',
        'Are impotence and erection problems different?',
      ),
      Label(
        'आम बोलचाल में "इम्पोटेंस" शब्द अक्सर इरेक्शन की परेशानी के लिए ही इस्तेमाल होता है। डॉक्टर इसे erectile dysfunction कहते हैं। यह संतान न होने (infertility) से अलग बात है।',
        'In everyday speech "impotence" usually means erection problems. Doctors call it erectile dysfunction. It is different from infertility (being unable to have children).',
      ),
    ],
  ];
  Widget faqTile(List<Label> item) => Card(
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(l(item[0]), style: const TextStyle(fontSize: 15)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              l(item[1]),
              style: const TextStyle(color: Brand.muted, height: 1.5),
            ),
          ),
        ],
      ),
    ),
  );
  Widget disclaimer() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Text(
      t(
        'प्रोटोटाइप · वास्तविक AI, डॉक्टर, खरीदारी और क्लाउड अभी जुड़े नहीं हैं।\nइस डेमो में वास्तविक निजी स्वास्थ्य जानकारी दर्ज न करें।',
        'Prototype · Real AI, doctors, shopping and cloud are not connected yet.\nDo not enter real personal health information in this demo.',
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(color: Brand.muted, fontSize: 12, height: 1.6),
    ),
  );
  void privacy() => preview(
    t('गोपनीयता', 'Privacy'),
    t(
      'बातचीत, चुनी फोटो, किट और feedback केवल इस session की memory में हैं; ऐप process खत्म होने पर हटते हैं; background में रहने पर बने रह सकते हैं। मूल gallery फोटो नहीं मिटती। कोई backend upload नहीं होता। Speech service आपके डिवाइस के provider को आवाज भेज सकती है। यह आपातकालीन सेवा नहीं है।',
      'Chat, selected photos, kit and feedback exist only in session memory; they are discarded when the app process ends and can remain while backgrounded. Original gallery photos are not deleted. No backend uploads occur. Speech service may send audio to your device provider. This is not an emergency service.',
    ),
  );

  List<Widget> home() => [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        pill(
          t('निजी बात, भरोसेमंद साथ', 'Private talk, trusted care'),
          icon: Icons.spa_outlined,
        ),
        pill(
          t('आपकी अनुमति मायने रखती है', 'Your consent matters'),
          icon: Icons.verified_user_outlined,
        ),
      ],
    ),
    const SizedBox(height: 20),
    const Text(
      'YOUR SPACE. YOUR PACE.',
      style: TextStyle(
        color: Brand.teal,
        fontSize: 12,
        letterSpacing: 2,
        fontWeight: FontWeight.w700,
      ),
    ),
    const SizedBox(height: 6),
    Text(
      t('आपकी देखभाल, आपके लिए।', 'Your care, for you.'),
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
    ),
    const SizedBox(height: 6),
    Text(
      t(
        'बिना झिझक बात करें। पहला कदम हम साथ लेंगे।',
        'Talk without hesitation. We will take the first step together.',
      ),
      style: const TextStyle(color: Brand.muted),
    ),
    heroCard(),
    const SizedBox(height: 12),
    serviceCard(
      'बिना शर्माए बात करें',
      'Talk without embarrassment',
      'बिना लॉगिन शुरू करें।\nजितना सहज लगे, उतना बताएँ।',
      'Start without login.\nShare only what feels comfortable.',
      Icons.chat_bubble_outline,
      Brand.mint,
      1,
    ),
    serviceCard(
      'विशेषज्ञ से मिलें',
      'Meet an expert',
      'परामर्श का तरीका और अपनी पसंद का समय चुनें।',
      'Choose the consultation mode and a time that suits you.',
      Icons.medical_services_outlined,
      Brand.lavender,
      2,
    ),
    serviceCard(
      'मेरी देखभाल',
      'My care',
      'आपकी सलाह, प्रिस्क्रिप्शन और फॉलो-अप एक जगह।',
      'Your advice, prescriptions and follow-ups in one place.',
      Icons.favorite_border,
      Brand.peach,
      4,
    ),
    helpline(),
    section('आपकी रोज़ की देखभाल', 'Your daily care'),
    serviceCard(
      'मेरी किट',
      'My kit',
      'निर्देश और रीफिल',
      'Instructions and refills',
      Icons.inventory_2_outlined,
      Brand.mint,
      6,
    ),
    serviceCard(
      'मेरा स्टोर',
      'My store',
      'वेलनेस की जरूरी चीजें',
      'Wellness essentials',
      Icons.storefront_outlined,
      Brand.mint,
      3,
    ),
    serviceCard(
      'वीडियो',
      'Videos',
      'जानें, समझें और साझा करें',
      'Learn, understand and share',
      Icons.play_arrow_outlined,
      Brand.mint,
      7,
    ),
    section(
      'थोड़ी समझ, बेहतर देखभाल',
      'A little understanding, better care',
      trailing: TextButton(
        onPressed: () => go(7),
        child: Text(t('सभी वीडियो →', 'All videos →')),
      ),
    ),
    SizedBox(
      height: 330,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videoTopics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => videoCard(i, width: 230),
      ),
    ),
    section('आपके अनुभव मायने रखते हैं', 'Your experience matters'),
    Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            iconTile(Icons.star_border, Brand.mint),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('आपका अनुभव कैसा रहा?', 'How was your experience?'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    t(
                      'अभी कोई सत्यापित समीक्षा नहीं है।',
                      'No verified reviews yet.',
                    ),
                    style: const TextStyle(color: Brand.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => go(5),
              child: Text(t('रेटिंग दें', 'Rate')),
            ),
          ],
        ),
      ),
    ),
    section('अक्सर पूछे जाने वाले सवाल', 'Frequently asked questions'),
    for (final item in faqs) faqTile(item),
    disclaimer(),
  ];
  List<Widget> profile() => [
    card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('बिना login का demo profile', 'Demo profile without login'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            t(
              'आपका नाम या मोबाइल नंबर नहीं लिया गया है।',
              'Your name or mobile number has not been collected.',
            ),
          ),
        ],
      ),
    ),
    card(
      Row(
        children: [
          Expanded(child: Text(t('भाषा', 'Language'))),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('हिंदी')),
              ButtonSegment(value: false, label: Text('English')),
            ],
            selected: {hindi},
            onSelectionChanged: (v) => setState(() => hindi = v.first),
          ),
        ],
      ),
    ),
    action('मेरी देखभाल', 'My care', Icons.favorite_outline, () => go(4)),
    action('रेटिंग दें', 'Give a rating', Icons.star_outline, () => go(5)),
    action('सवाल-जवाब', 'FAQ', Icons.help_outline, () => go(8)),
    action('गोपनीयता', 'Privacy', Icons.lock_outline, privacy),
    action(
      'इस session का सारा data मिटाएँ',
      'Delete all data in this session',
      Icons.delete_outline,
      clearAll,
    ),
    helpline(),
    disclaimer(),
  ];
  Future<void> clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('सारा data मिटाएँ?', 'Delete all data?')),
        content: Text(
          t(
            'बातचीत, फोटो, किट, appointment draft और रेटिंग हटेंगे।',
            'Chat, photos, kit, appointment drafts and rating will be removed.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('रद्द करें', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('मिटाएँ', 'Delete')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        generation++;
        messages.clear();
        selections.clear();
        concern = null;
        kit.clear();
        appointments.clear();
        input.clear();
        feedback.clear();
        stars = 0;
        busy = false;
      });
    }
  }

  void share() {
    final doctor = repository.doctors[doctorIndex];
    preview(
      t('साझा करने का preview', 'Sharing preview'),
      '${l(doctor.name)}\n${[...selections, ?concern].map((x) => l(x.label)).join(' → ')}\n${messages.map((m) => '${m.fromUser ? t('आप', 'You') : t('डेमो', 'DEMO')}: ${l(m.body)}${m.photo != null ? t(' [फोटो संलग्न]', ' [Photo attached]') : ''}').join('\n')}\n\n${t('केवल preview। कुछ भेजा नहीं गया है। वास्तविक मोबाइल API/auth integration pending है।', 'Preview only. Nothing has been sent. Real mobile API/auth integration is pending.')}',
    );
  }

  Future<void> send([ChatMessage? attached]) async {
    if (busy || (attached == null && input.text.trim().isEmpty)) {
      return;
    }
    final token = generation;
    setState(() {
      messages.add(
        attached ??
            ChatMessage(
              Label(input.text.trim(), input.text.trim()),
              fromUser: true,
            ),
      );
      input.clear();
      busy = true;
    });
    final reply = await chatService.reply(List.unmodifiable(messages));
    if (!mounted || token != generation) {
      return;
    }
    setState(() {
      messages.add(reply);
      busy = false;
    });
  }

  Future<void> photo() async {
    try {
      final bytes = await device.pickPhoto();
      if (!mounted || bytes == null) {
        return;
      }
      await send(
        ChatMessage(
          const Label('चुनी हुई फोटो', 'Selected photo'),
          fromUser: true,
          photo: bytes,
        ),
      );
    } on PlatformException {
      if (mounted) {
        notice(
          t(
            'फोटो नहीं चुनी जा सकी। छोटा चित्र चुनें।',
            'Could not select photo. Choose a smaller image.',
          ),
        );
      }
    } on MissingPluginException {
      if (!mounted) return;
      notice(
        t(
          'Android डिवाइस पर फोटो चयन उपलब्ध है।',
          'Photo selection is available on Android.',
        ),
      );
    }
  }

  Future<void> voice() async {
    await preview(
      t('आवाज की गोपनीयता', 'Voice privacy'),
      t(
        'Android speech service इस्तेमाल होगी और उसका provider आवाज process कर सकता है। अगली स्क्रीन में आप शुरू या cancel कर सकते हैं। लिखित संदेश सीधे भी दे सकते हैं।',
        'Android speech service will be used and its provider may process audio. You can start or cancel on the next screen. You can also type directly.',
      ),
    );
    if (!mounted) {
      return;
    }
    try {
      final result = await device.transcribe(hindi);
      if (mounted && result != null) {
        setState(() => input.text = result);
      }
    } on PlatformException {
      if (mounted) {
        notice(
          t(
            'Speech service उपलब्ध नहीं। कृपया लिखें।',
            'Speech service unavailable. Please type.',
          ),
        );
      }
    } on MissingPluginException {
      if (!mounted) return;
      notice(
        t(
          'Android डिवाइस पर voice-to-text उपलब्ध है।',
          'Voice-to-text is available on Android.',
        ),
      );
    }
  }

  Future<void> clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('बातचीत मिटाएँ?', 'Delete conversation?')),
        content: Text(
          t(
            'इस session की बातचीत, फोटो और चुने विषय हटेंगे।',
            'Chat, photos and selected topics in this session will be removed.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('रद्द करें', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('मिटाएँ', 'Delete')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        generation++;
        messages.clear();
        selections.clear();
        concern = null;
        input.clear();
        busy = false;
      });
    }
  }

  List<Topic> get topicOptions =>
      selections.isEmpty ? topicTree : selections.last.children;

  void chooseTopic(Topic topic) => setState(() {
    if (topic.children.isEmpty) {
      concern = topic;
      input.text = t(
        'मेरा सवाल ${topic.label.hi} के बारे में है।',
        'My question is about: ${topic.label.en}.',
      );
    } else {
      selections.add(topic);
    }
  });

  Widget topicLink(String hi, String en, VoidCallback onTap) => TextButton(
    onPressed: onTap,
    child: Text(
      t(hi, en),
      style: const TextStyle(color: Brand.teal, fontSize: 13),
    ),
  );

  Widget topicPicker() {
    final options = topicOptions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selections.isEmpty
              ? t('आप किस बारे में बात करना चाहते हैं?', 'What would you like to talk about?')
              : l(selections.first.label),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        if (selections.length > 1) ...[
          const SizedBox(height: 16),
          Text(
            selections.skip(1).map((x) => l(x.label)).join(' → '),
            style: const TextStyle(fontSize: 15),
          ),
        ],
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < options.length; i++)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  side: BorderSide(
                    color: identical(options[i], concern)
                        ? Brand.teal
                        : Brand.border,
                    width: identical(options[i], concern) ? 2 : 1,
                  ),
                ),
                onPressed: () => chooseTopic(options[i]),
                child: Text(
                  '${i + 1}. ${l(options[i].label)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            if (selections.length >= 3)
              topicLink(
                '← उपविभाग पर वापस',
                '← Back to subsection',
                () => setState(() {
                  selections.removeLast();
                }),
              )
            else if (selections.isNotEmpty)
              topicLink(
                '← मुख्य विषय',
                '← Main topics',
                () => setState(selections.clear),
              ),
            topicLink(
              'अन्य सवाल / अभी छोड़ें',
              'Other question / skip for now',
              () {
                setState(() {
                  selections.clear();
                  concern = null;
                });
                inputFocus.requestFocus();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          t('ये बातचीत के विषय हैं, निदान नहीं।', 'These are conversation topics, not a diagnosis.'),
          style: const TextStyle(fontSize: 11, color: Brand.muted),
        ),
      ],
    );
  }

  List<Widget> chat() => [
    helpline(),
    const SizedBox(height: 12),
    topicPicker(),
    const SizedBox(height: 16),
    for (final m in messages)
      Align(
        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: m.fromUser ? Brand.mint : Brand.lavender,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l(m.body)),
              if (m.photo != null)
                Image.memory(
                  m.photo!,
                  height: 160,
                  errorBuilder: (_, e, s) => Text(
                    t('फोटो preview उपलब्ध नहीं', 'Photo preview unavailable'),
                  ),
                ),
            ],
          ),
        ),
      ),
    const SizedBox(height: 8),
    TextField(
      controller: input,
      focusNode: inputFocus,
      minLines: 3,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: t(
          'अपना सवाल पूछें या अपनी बात लिखें...',
          'Ask your question or write your message...',
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.border),
        ),
      ),
    ),
    const SizedBox(height: 14),
    Row(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          ),
          onPressed: busy ? null : photo,
          child: Text(t('+ फोटो', '+ Photo')),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            onPressed: busy ? null : voice,
            child: Text(
              t('🎙️ बोलकर टाइप करें', '🎙️ Voice typing'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Spacer(),
        FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          onPressed: busy ? null : send,
          child: Text(
            t('भेजें →', 'Send →'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
    const SizedBox(height: 20),
    DropdownButtonFormField<int>(
      initialValue: doctorIndex,
      decoration: InputDecoration(
        labelText: t('साझा करने के लिए डॉक्टर', 'Doctor to share with'),
      ),
      items: [
        for (var i = 0; i < repository.doctors.length; i++)
          DropdownMenuItem(
            value: i,
            child: Text(l(repository.doctors[i].name)),
          ),
      ],
      onChanged: (value) => setState(() => doctorIndex = value!),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: share,
        child: Text(
          t(
            'मेरी बातचीत इस डॉक्टर से साझा करें',
            'Share my conversation with this doctor',
          ),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ),
    const SizedBox(height: 8),
    Text(
      t(
        'अभी केवल प्रीव्यू है; बातचीत डॉक्टर को नहीं भेजी जाएगी।',
        'Preview only for now; the conversation will not be sent to a doctor.',
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 11, color: Brand.muted),
    ),
    const SizedBox(height: 8),
    Center(
      child: TextButton.icon(
        onPressed: clear,
        icon: const Icon(Icons.delete_outline),
        label: Text(t('बातचीत मिटाएँ', 'Delete conversation')),
      ),
    ),
  ];
  List<Widget> doctors() => [
    banner(),
    for (var i = 0; i < repository.doctors.length; i++) doctorCard(i),
  ];
  Widget doctorCard(int i) {
    final d = repository.doctors[i];
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/doctor$i.jpg',
              height: 160,
              width: 160,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            t(
              'AI-निर्मित काल्पनिक नमूना फोटो',
              'AI-generated fictional sample photo',
            ),
          ),
          heading(l(d.name), l(d.name)),
          Text(
            '${l(d.qualification)}\n${l(d.languages)}\n${t('नमूना फीस', 'Sample fee')}: ₹${d.fee}',
          ),
          TextButton.icon(
            onPressed: () async {
              if (date.isBefore(today)) {
                setState(() {
                  date = today;
                  slot = null;
                });
              }
              final chosen = await showDatePicker(
                context: context,
                locale: Locale(hindi ? 'hi' : 'en'),
                initialDate: date.isBefore(today) ? today : date,
                firstDate: today,
                lastDate: today.add(const Duration(days: 60)),
                helpText: t('तारीख चुनें', 'Select date'),
                cancelText: t('रद्द करें', 'Cancel'),
                confirmText: t('चुनें', 'Select'),
              );
              if (chosen != null) {
                setState(() {
                  date = chosen;
                  slot = null;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
            label: Text(
              '${t('तारीख', 'Date')}: ${date.day}/${date.month}/${date.year}',
            ),
          ),
          Text(t('नमूना उपलब्ध समय', 'Sample available times')),
          if (openSlots().isEmpty)
            Text(
              t(
                'इस तारीख का कोई समय नहीं बचा। दूसरी तारीख चुनें।',
                'No times left on this date. Choose another date.',
              ),
            ),
          Wrap(
            spacing: 8,
            children: openSlots()
                .map(
                  (s) => ChoiceChip(
                    label: Text(s),
                    selected: slot == s && doctorIndex == i,
                    onSelected: (_) => setState(() {
                      slot = s;
                      doctorIndex = i;
                    }),
                  ),
                )
                .toList(),
          ),
          FilledButton(
            onPressed: slot == null || doctorIndex != i
                ? null
                : () => setState(() {
                    appointments.add(
                      Label(
                        '${d.name.hi} • ${date.day}/${date.month}/${date.year} • $slot — स्थानीय draft, बुक नहीं हुआ',
                        '${d.name.en} • ${date.day}/${date.month}/${date.year} • $slot — Local draft, not booked',
                      ),
                    );
                    go(4);
                  }),
            child: Text(
              t('अपॉइंटमेंट का स्थानीय draft', 'Local appointment draft'),
            ),
          ),
          TextButton(
            onPressed: () => setState(() {
              doctorIndex = i;
              page = 1;
            }),
            child: Text(
              t('बातचीत का साझा preview', 'Conversation sharing preview'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> store() => [
    banner(),
    for (final p in repository.products)
      card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/product${p.code}.jpg',
                height: 170,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              t(
                'AI-निर्मित नमूना उत्पाद फोटो',
                'AI-generated sample product photo',
              ),
            ),
            heading(l(p.name), l(p.name)),
            Text('${p.code} • ₹${p.price}\n${l(p.description)}'),
            FilledButton(
              onPressed: () => setState(
                () => kit.update(p, (q) => q + 1, ifAbsent: () => 1),
              ),
              child: Text(t('मेरी किट में जोड़ें', 'Add to My Kit')),
            ),
            if (kit.containsKey(p))
              Text(t('किट में: ${kit[p]}', 'In kit: ${kit[p]}')),
          ],
        ),
      ),
    action('मेरी किट देखें', 'View My Kit', Icons.inventory, () => go(6)),
  ];
  List<Widget> myKit() => [
    Text(
      t(
        'केवल स्थानीय सूची। कोई खरीद या भुगतान नहीं।',
        'Local list only. No purchase or payment.',
      ),
    ),
    if (kit.isEmpty) card(Text(t('आपकी किट खाली है।', 'Your kit is empty.'))),
    for (final entry in kit.entries)
      card(
        ListTile(
          title: Text(l(entry.key.name)),
          subtitle: Text(
            '₹${entry.key.price} × ${entry.value} = ₹${entry.key.price * entry.value}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: t('एक कम करें', 'Remove one'),
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() {
                  if (entry.value <= 1) {
                    kit.remove(entry.key);
                  } else {
                    kit[entry.key] = entry.value - 1;
                  }
                }),
              ),
              Text('${entry.value}'),
              IconButton(
                tooltip: t('एक और जोड़ें', 'Add one'),
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () =>
                    setState(() => kit[entry.key] = entry.value + 1),
              ),
            ],
          ),
        ),
      ),
    if (kit.isNotEmpty)
      FilledButton(
        onPressed: () => preview(
          t('ऑर्डर preview', 'Order preview'),
          '${kit.entries.map((e) => '${l(e.key.name)} × ${e.value} • ₹${e.key.price * e.value}').join('\n')}\n${t('कुल', 'Total')}: ₹${kit.entries.fold<int>(0, (sum, e) => sum + e.key.price * e.value)}\n${t('ऑर्डर नहीं हुआ। भुगतान/API pending।', 'No order placed. Payment/API pending.')}',
        ),
        child: Text(t('ऑर्डर preview देखें', 'View order preview')),
      ),
    action('स्टोर खोलें', 'Open Store', Icons.store, () => go(3)),
  ];
  List<Widget> care() => [
    heading('अपॉइंटमेंट', 'Appointments'),
    if (appointments.isEmpty)
      card(
        Text(
          t(
            'अभी कोई अपॉइंटमेंट नहीं। डॉक्टर से स्थानीय draft बनाएँ।',
            'No appointments yet. Create a local draft from Doctors.',
          ),
        ),
      ),
    for (var i = 0; i < appointments.length; i++)
      card(
        ListTile(
          title: Text(l(appointments[i])),
          trailing: IconButton(
            tooltip: t('Draft हटाएँ', 'Remove draft'),
            onPressed: () => setState(() => appointments.removeAt(i)),
            icon: const Icon(Icons.delete_outline),
          ),
        ),
      ),
    heading('प्रिस्क्रिप्शन', 'Prescriptions'),
    card(
      Text(
        t(
          'कोई वास्तविक प्रिस्क्रिप्शन नहीं। डॉक्टर integration pending है।',
          'No real prescriptions. Doctor integration is pending.',
        ),
      ),
    ),
    heading('ऑर्डर ट्रैकिंग', 'Order tracking'),
    card(
      Text(
        t(
          'कोई ऑर्डर नहीं भेजा गया है। वास्तविक tracking API pending है।',
          'No orders have been placed. Real tracking API is pending.',
        ),
      ),
    ),
    action('रेटिंग दें', 'Rating', Icons.star, () => go(5)),
  ];
  List<Widget> rating() => [
    Text(t('ऐप के डेमो अनुभव की रेटिंग', 'Rate the demo app experience')),
    Wrap(
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            tooltip: t('$i सितारे', '$i stars'),
            onPressed: () => setState(() => stars = i),
            icon: Icon(
              i <= stars ? Icons.star : Icons.star_border,
              color: Colors.amber.shade800,
            ),
          ),
      ],
    ),
    TextField(
      controller: feedback,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: t('आपका संदेश', 'Your message'),
        border: const OutlineInputBorder(),
      ),
    ),
    FilledButton(
      onPressed: stars == 0
          ? null
          : () => preview(
              t('स्थानीय रेटिंग preview', 'Local rating preview'),
              '$stars / 5\n${feedback.text}\n${t('कहीं भेजा नहीं गया। केवल इस session में है।', 'Not sent anywhere. Only in this session.')}',
            ),
      child: Text(t('रेटिंग preview', 'Rating preview')),
    ),
  ];
  List<Widget> videos() => [
    card(
      Text(
        t(
          'वीडियो streaming अभी जुड़ी नहीं है। नीचे निर्धारित स्थान और पाठ preview हैं।',
          'Video streaming is not connected yet. Reserved spaces and text previews are below.',
        ),
      ),
    ),
    for (var i = 0; i < videoTopics.length; i++) videoCard(i),
  ];
  List<Widget> faq() => [for (final item in faqs) faqTile(item), disclaimer()];
}
