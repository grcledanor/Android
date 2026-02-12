import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Stockage {
  static final List<String> _data = [];
  Future<void> write(String url) async => _data.add(url);
  Future<List<String>> readAll() async => _data;
  void clear() => _data.clear();
  void removeAt(int index) => _data.removeAt(index);
}
final stockage = Stockage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> pwodwi = const [
    {'non': 'T-shirt Blan', 'pri': '450 Gdes', 'link': 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?w=500'},
    {'non': 'Chemiz Ble', 'pri': '650 Gdes', 'link': 'https://images.pexels.com/photos/1082529/pexels-photo-1082529.jpeg?w=500'},
    {'non': 'Pantalon Nwa', 'pri': '850 Gdes', 'link': 'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?w=500'},
    {'non': 'Soulye Espò', 'pri': '1200 Gdes', 'link': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?w=500'},
    {'non': 'Kaskèt', 'pri': '350 Gdes', 'link': 'https://images.pexels.com/photos/1595333/pexels-photo-1595333.jpeg?w=500'},
    {'non': 'Chemiz Karo', 'pri': '700 Gdes', 'link': 'https://images.pexels.com/photos/1036622/pexels-photo-1036622.jpeg?w=500'},
    {'non': 'T-shirt Nwa', 'pri': '450 Gdes', 'link': 'https://images.pexels.com/photos/8346276/pexels-photo-8346276.jpeg?w=500'},
    {'non': 'Chapo Pay', 'pri': '300 Gdes', 'link': 'https://images.pexels.com/photos/1370750/pexels-photo-1370750.jpeg?w=500'},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('EBoutikoo', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListeAchatPage())),
        ),
      ],
    ),
    body: GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pwodwi.length,
      itemBuilder: (context, i) {
        final p = pwodwi[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  p['link']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.image, color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Text(p['non']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(p['pri']!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await stockage.write(p['link']!);
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('✓ ${p['non']}'), backgroundColor: Colors.green[700]),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text('Achte'),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        );
      },
    ),
  );
}

class ListeAchatPage extends StatefulWidget {
  const ListeAchatPage({super.key});
  @override
  State<ListeAchatPage> createState() => _ListeAchatPageState();
}

class _ListeAchatPageState extends State<ListeAchatPage> {
  List<String> a = [];
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { final data = await stockage.readAll(); setState(() => a = data); }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Panye'),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      actions: [
        if (a.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              stockage.clear();
              setState(() => a = []);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Panye vid')));
            },
          ),
      ],
    ),
    body: a.isEmpty
      ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Panye vid', style: TextStyle(fontSize: 22, color: Colors.grey[600], fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Pa gen pwodwi', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
        ]))
      : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: a.length,
          itemBuilder: (context, i) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  a[i],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('Pwodwi ${i+1}', style: const TextStyle(fontWeight: FontWeight.w500))),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  stockage.removeAt(i);
                  setState(() => a.removeAt(i));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pwodwi retire')));
                },
              ),
            ]),
          ),
        ),
  );
}
