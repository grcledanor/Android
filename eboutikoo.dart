import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EBoutikoo',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}

class Produit {
  final String nom, categorie, prix, imageUrl, descCourte, descLongue;
  final Color couleur;
  Produit({required this.nom, required this.categorie, required this.prix, required this.imageUrl, required this.descCourte, required this.descLongue, required this.couleur});
}

class ArticlePanier {
  final Produit produit;
  int quantite;
  ArticlePanier({required this.produit, this.quantite = 1});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<ArticlePanier> _panier = [];

  final List<Produit> produits = [
    Produit(nom: 'PC HP', categorie: 'Électronique', prix: '899.99 €', imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400', descCourte: '15.6", 8Go RAM', descLongue: 'PC HP 15.6", 8Go RAM, 256Go SSD.', couleur: Colors.blue.shade400),
    Produit(nom: 'Samsung', categorie: 'Électronique', prix: '699.99 €', imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400', descCourte: '6.4", 128Go', descLongue: 'Samsung Galaxy A54, 6.4", 128Go.', couleur: Colors.green.shade400),
    Produit(nom: 'Tablette', categorie: 'Électronique', prix: '399.99 €', imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400', descCourte: '10", 64Go', descLongue: 'Tablette Android 10", 64Go.', couleur: Colors.teal.shade400),
    Produit(nom: 'Casque', categorie: 'Électronique', prix: '129.99 €', imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', descCourte: 'Sans fil', descLongue: 'Casque Bluetooth, batterie 20h.', couleur: Colors.red.shade400),
    Produit(nom: 'Montre', categorie: 'Électronique', prix: '249.99 €', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', descCourte: 'Connectée', descLongue: 'Montre GPS, cardio, notifications.', couleur: Colors.purple.shade400),
    Produit(nom: 'Appareil Photo', categorie: 'Électronique', prix: '549.99 €', imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400', descCourte: '24MP', descLongue: 'Appareil photo numérique 24MP.', couleur: Colors.amber.shade700),
  ];

  void _ajouterPanier(Produit p) {
    setState(() {
      int idx = _panier.indexWhere((a) => a.produit.nom == p.nom);
      if (idx >= 0) _panier[idx].quantite++; else _panier.add(ArticlePanier(produit: p));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✓ ${p.nom} ajouté'), backgroundColor: Colors.green));
  }

  void _retirerPanier(Produit p) => setState(() => _panier.removeWhere((a) => a.produit.nom == p.nom));
  void _changerQuantite(Produit p, int c) => setState(() {
    int idx = _panier.indexWhere((a) => a.produit.nom == p.nom);
    if (idx >= 0) { _panier[idx].quantite += c; if (_panier[idx].quantite <= 0) _panier.removeAt(idx); }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: [
        AccueilScreen(produits: produits, onAjouter: _ajouterPanier),
        PanierScreen(panier: _panier, onRetirer: _retirerPanier, onChanger: _changerQuantite),
        ListeScreen(produits: produits, onAjouter: _ajouterPanier),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ACCUEIL'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'PANIER'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'LISTE'),
        ],
        selectedItemColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => selectedIndex = 1),
        backgroundColor: const Color(0xFFF39C12),
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  final List<Produit> produits;
  const MenuDrawer({super.key, required this.produits});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green,
        child: SafeArea(
          child: Column(children: [
            Padding(padding: const EdgeInsets.all(20), child: Text('EBoutikoo', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
            const Divider(color: Colors.white54),
            ListTile(leading: const Icon(Icons.list, color: Colors.white), title: const Text('LISTE PRODUITS', style: TextStyle(color: Colors.white)), onTap: () {
              Navigator.pop(context);
              final state = context.findAncestorStateOfType<_HomeScreenState>();
              state?.setState(() => state.selectedIndex = 2);
            }),
            ListTile(leading: const Icon(Icons.login, color: Colors.white), title: const Text('CONNEXION', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.logout, color: Colors.white), title: const Text('DÉCONNEXION', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ]),
        ),
      ),
    );
  }
}

class AccueilScreen extends StatelessWidget {
  final List<Produit> produits; final Function(Produit) onAjouter;
  const AccueilScreen({super.key, required this.produits, required this.onAjouter});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBoutikoo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => Scaffold.of(c).openDrawer())),
        actions: [Container(margin: const EdgeInsets.only(right: 16), child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Text('PAYER')))],
      ),
      drawer: MenuDrawer(produits: produits),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Catégories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _carteCategorie('Électronique & Informatique', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400', Colors.blue, context),
          const SizedBox(height: 12),
          _carteCategorie('Gadgets & Accessoires', 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400', Colors.teal, context),
          const SizedBox(height: 24),
          const Text('Produits populaires', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _carteProduit(produits[0], context)), const SizedBox(width: 16), Expanded(child: _carteProduit(produits[1], context))]),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _carteProduit(produits[2], context)), const SizedBox(width: 16), Expanded(child: _carteProduit(produits[3], context))]),
          const SizedBox(height: 24),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('📦 EBoutikoo - Votre boutique électronique!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              Text('Achetez les dernières technologies: PC, smartphones, tablettes, gadgets et plus. Livraison rapide.', style: TextStyle(fontSize: 14, color: Colors.white)),
            ]),
          ),
        ]),
      ),
    );
  }
  
  Widget _carteCategorie(String nom, String url, Color c, BuildContext ctx) => GestureDetector(
    onTap: () {
      final state = ctx.findAncestorStateOfType<_HomeScreenState>();
      state?.setState(() => state.selectedIndex = 2);
    },
    child: Container(
      width: double.infinity, height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(fit: StackFit.expand, children: [
          Image.network(url, fit: BoxFit.cover),
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)]))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(padding: const EdgeInsets.only(left: 20), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 4, color: Colors.black54)])),
              const SizedBox(height: 4),
              Text('Découvrir', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.95), shadows: const [Shadow(blurRadius: 3, color: Colors.black54)])),
            ])),
            Container(width: 70, height: 70, margin: const EdgeInsets.only(right: 16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.5))),
              child: const Icon(Icons.shopping_bag, color: Colors.white, size: 35)),
          ]),
        ]),
      ),
    ),
  );
  
  Widget _carteProduit(Produit p, BuildContext ctx) => GestureDetector(
    onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => DetailScreen(produit: p, onAjouter: onAjouter))),
    child: Card(
      child: Column(children: [
        Container(height: 120, width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(p.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: p.couleur.withOpacity(0.2), child: Center(child: Icon(Icons.broken_image, color: p.couleur))),
              loadingBuilder: (_, c, l) => l == null ? c : Container(color: p.couleur.withOpacity(0.1), child: const Center(child: CircularProgressIndicator())),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(p.descCourte, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextButton(onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => DetailScreen(produit: p, onAjouter: onAjouter))), child: const Text('DÉTAIL', style: TextStyle(color: Colors.green)))),
            Expanded(child: ElevatedButton(onPressed: () => onAjouter(p), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: const Text('ACHETER'))),
          ]),
        ])),
      ]),
    ),
  );
}

class DetailScreen extends StatefulWidget {
  final Produit produit; final Function(Produit) onAjouter;
  const DetailScreen({super.key, required this.produit, required this.onAjouter});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DÉTAIL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [Container(margin: const EdgeInsets.only(right: 16), child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Text('PAYER')))],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(height: 300, width: double.infinity,
            child: Stack(children: [
              Image.network(widget.produit.imageUrl, width: double.infinity, height: 300, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: widget.produit.couleur.withOpacity(0.2), child: Center(child: Icon(Icons.broken_image, size: 80, color: widget.produit.couleur)))),
              Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.3)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
              Positioned(top: 16, right: 16, child: GestureDetector(
                onTap: () => setState(() => fav = !fav),
                child: Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(fav ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 28)),
              )),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(widget.produit.nom, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: widget.produit.couleur.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(widget.produit.categorie, style: TextStyle(color: widget.produit.couleur))),
            ]),
            const SizedBox(height: 16),
            Text(widget.produit.prix, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE67E22))),
            const SizedBox(height: 20),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.produit.descLongue, style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.6)),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
              onPressed: () => widget.onAjouter(widget.produit),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF39C12), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text('Ajouter au panier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            )),
          ])),
        ]),
      ),
    );
  }
}

class ListeScreen extends StatelessWidget {
  final List<Produit> produits; final Function(Produit) onAjouter;
  const ListeScreen({super.key, required this.produits, required this.onAjouter});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LISTE PRODUITS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => Scaffold.of(c).openDrawer())),
        actions: [Container(margin: const EdgeInsets.only(right: 16), child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Text('PAYER')))],
      ),
      drawer: MenuDrawer(produits: produits),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Liste produits', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 16),
          const Text('Produits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85),
            itemCount: produits.length,
            itemBuilder: (c, i) => _carteProduit(produits[i], c),
          ),
        ]),
      ),
    );
  }
  
  Widget _carteProduit(Produit p, BuildContext ctx) => GestureDetector(
    onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => DetailScreen(produit: p, onAjouter: onAjouter))),
    child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 110, width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(p.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: p.couleur.withOpacity(0.2), child: Center(child: Icon(Icons.broken_image, color: p.couleur))),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.nom, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(p.descCourte, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(p.prix, style: const TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.w700, fontSize: 14)),
            Row(children: [
              GestureDetector(onTap: () => onAjouter(p), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('🛒', style: TextStyle(fontSize: 16)))),
              const SizedBox(width: 8),
              GestureDetector(onTap: () => ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('❤️ ${p.nom}'), backgroundColor: Colors.red, duration: const Duration(milliseconds: 800))),
                child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('❤️', style: TextStyle(fontSize: 16)))),
            ]),
          ]),
        ])),
      ]),
    ),
  );
}

class PanierScreen extends StatelessWidget {
  final List<ArticlePanier> panier; final Function(Produit) onRetirer; final Function(Produit, int) onChanger;
  const PanierScreen({super.key, required this.panier, required this.onRetirer, required this.onChanger});

  double get total => panier.fold(0, (s, a) => s + double.parse(a.produit.prix.replaceAll('€', '').trim()) * a.quantite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PANIER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        leading: null, automaticallyImplyLeading: false,
        actions: [Container(margin: const EdgeInsets.only(right: 16), child: ElevatedButton(onPressed: panier.isEmpty ? null : () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Text('PAYER')))],
      ),
      body: panier.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16), const Text('Panier vide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8), Text('Ajoutez des produits', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          ]))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: panier.length,
            itemBuilder: (c, i) {
              final a = panier[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: a.produit.couleur.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(a.produit.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(child: Icon(Icons.image, color: a.produit.couleur.withOpacity(0.5)))))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a.produit.nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(a.produit.prix, style: const TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.w700)),
                    ])),
                    Row(children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => onChanger(a.produit, -1)),
                      Text('${a.quantite}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.green), onPressed: () => onChanger(a.produit, 1)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.grey), onPressed: () => onRetirer(a.produit)),
                    ]),
                  ]),
                ),
              );
            },
          ),
    );
  }
}
