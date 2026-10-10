import 'package:flutter/material.dart';
import 'api.dart';
import 'scan_page.dart';
import 'tabs.dart';

const kRed = Color(0xFFD01E24);
const kBlue = Color(0xFF2196F3);
const kBg = Color(0xFFFBF2F5);

void main() => runApp(const StockInquiryApp());

class StockInquiryApp extends StatelessWidget {
  const StockInquiryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Inquiry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBg,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: kRed, primary: kRed),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ctrl = TextEditingController();
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = false;

  Future<void> _search([String? kw]) async {
    final keyword = (kw ?? _ctrl.text).trim();
    if (keyword.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      final d = await Api.lookup(keyword);
      setState(() => _data = d);
    } catch (e) {
      setState(() { _error = e.toString(); _data = null; });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScanPage()),
    );
    if (code != null && code.isNotEmpty) {
      _ctrl.text = code;
      _search(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _data?['core']?['ItemCode'] ?? '';
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kRed,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('Stock Inquiry: $title',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: const [Icon(Icons.more_horiz), SizedBox(width: 12)],
        ),
        body: Column(
          children: [
            _searchBar(),
            const TabBar(
              isScrollable: true,
              labelColor: kRed,
              unselectedLabelColor: kRed,
              indicatorColor: kRed,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'DETAILS'), Tab(text: 'PRICING'), Tab(text: 'MORE'),
                Tab(text: 'IMAGE'), Tab(text: 'STOCK BALANCE'),
                Tab(text: 'PROMOTIONS'), Tab(text: 'SALES HISTORY'),
                Tab(text: 'PURCHASE HISTORY'),
              ],
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Keyword Here:',
                style: TextStyle(color: kRed, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  textAlign: TextAlign.center,
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kRed),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kRed, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _scan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SCAN',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ],
        ),
      );

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator(color: kRed));
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: kRed)));
    }
    if (_data == null) {
      return const Center(
          child: Text('Enter or scan an item code',
              style: TextStyle(color: Colors.black45)));
    }
    final d = _data!;
    return TabBarView(children: [
      DetailsTab(d), PricingTab(d), MoreTab(d), const ImageTab(),
      StockBalanceTab(d), PromotionsTab(d), SalesHistoryTab(d), PurchaseHistoryTab(d),
    ]);
  }
}
