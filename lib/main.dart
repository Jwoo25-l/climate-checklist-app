import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ClimateChecklistApp());
}

class ClimateChecklistApp extends StatelessWidget {
  const ClimateChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Checklist',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> checklist = [
    '텀블러 사용하기',
    '대중교통 이용',
    '채식 식사',
    '계단 이용하기',
    '플라스틱 컵 거절'
  ];
  List<bool> checked = [false, false, false, false, false];
  int points = 0;

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  Future<void> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> addPoint() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      points++;
      prefs.setInt('points', points);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기후 체크리스트')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('☁️ 포인트: $points', style: const TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: checklist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(checklist[index]),
                  trailing: checked[index]
                      ? const Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () {
                            if (!checked[index]) {
                              setState(() {
                                checked[index] = true;
                              });
                              addPoint();
                            }
                          },
                          child: const Text('인증'),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
