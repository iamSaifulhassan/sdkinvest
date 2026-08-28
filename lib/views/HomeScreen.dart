import 'package:flutter/material.dart';
import 'package:sdkinvest/widgets/herocontainer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xff04111f),
        appBar: AppBar(
          backgroundColor: const Color(0xff04111f),
          surfaceTintColor: Colors.transparent,
          titleSpacing: 20,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xffdbe5eb)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Color(0xffdbe5eb)),
              onPressed: () {},
            ),
          ],
          title: Row(
            children: [
              const Text('SDK',
              style: TextStyle(
                color: Color(0xffd9c7a1),
                fontSize: 24,
                fontWeight: FontWeight.w700,)
              ),
              const SizedBox(width: 5),
              const Text('Investing',
              style: TextStyle(
                color: Color(0xffdbe5eb),
                fontSize: 21,
              ),
              ),
            ],
          ),
        ),
        body: const _DashboardBody(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good morning', style: TextStyle(color: Color(0xffdbe5eb), fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Your portfolio overview', style: TextStyle(color: Color(0xff75899a), fontSize: 12)),
            const SizedBox(height: 18),
            const HeroContainer(),
            const SizedBox(height: 18),
            Row(
              children: const [
                Expanded(child: MetricCard(icon: Icons.visibility_outlined, label: 'Watchlist', color: Color(0xff59a9d8))),
                SizedBox(width: 10),
                Expanded(child: MetricCard(icon: Icons.trending_up_rounded, label: 'Strong Buy', color: Color(0xff35bd75))),
                SizedBox(width: 10),
                Expanded(child: MetricCard(icon: Icons.notifications_none_rounded, label: 'Alerts', color: Color(0xffe16968))),
              ],
            ),
            const SizedBox(height: 22),
            const SectionTitle(title: 'Watchlist', action: 'View All'),
            const SizedBox(height: 10),
            const StockList(stocks: []),
            const SizedBox(height: 22),
            const SectionTitle(title: 'Action Center', action: 'View All'),
            const SizedBox(height: 10),
            const Row(children: [Expanded(child: ActionCard(icon: Icons.trending_up_rounded, color: Color(0xff35bd75))), SizedBox(width: 10), Expanded(child: ActionCard(icon: Icons.notifications_active_outlined, color: Color(0xffd9a941)))]),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.icon, required this.label, required this.color, this.value = '--'});
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xff0a2034), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xff18364c))), child: Row(children: [Icon(icon, color: color, size: 19), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xff8194a4), fontSize: 10)), const SizedBox(height: 2), Text(value, style: const TextStyle(color: Color(0xfff1f4f5), fontSize: 16, fontWeight: FontWeight.w700))])]));
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.action});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Color(0xffe1e8ec), fontSize: 16, fontWeight: FontWeight.w700)), Text(action, style: const TextStyle(color: Color(0xff67a9d2), fontSize: 11, fontWeight: FontWeight.w600))]);
}

class StockList extends StatelessWidget {
  const StockList({super.key, required this.stocks});
  final List<(String, String, String, String, Color)> stocks;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xff0a2034), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xff18364c))), child: Center(child: Text(stocks.isEmpty ? 'No items yet' : '')));
}

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.icon, required this.color, this.title = 'No action yet', this.symbol = '--'});
  final IconData icon;
  final String title;
  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xff0a2034), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xff18364c))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 20), const SizedBox(height: 10), Text(title, style: const TextStyle(color: Color(0xff8ba0ae), fontSize: 10)), const SizedBox(height: 4), Text(symbol, style: const TextStyle(color: Color(0xffe7eef1), fontSize: 11, fontWeight: FontWeight.w600))]));
}