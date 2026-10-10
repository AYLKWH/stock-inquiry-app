import 'package:flutter/material.dart';
import 'main.dart' show kRed, kBlue;
import 'widgets.dart';

class DetailsTab extends StatefulWidget {
  final Map<String, dynamic> d;
  const DetailsTab(this.d, {super.key});
  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  late String uom;
  @override
  void initState() {
    super.initState();
    uom = widget.d['defaultUom'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final core = d['core'] ?? {};
    final uoms = (d['uoms'] as List).cast<Map<String, dynamic>>();
    final cur = uoms.firstWhere((u) => u['UOM'] == uom,
        orElse: () => uoms.isNotEmpty ? uoms.first : {});
    final price = d['detailPrice'] ?? {};
    return pad(Column(children: [
      row2(
        FieldBox('Item Code', s(core['ItemCode'])),
        _uomPicker(uoms),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FieldBox('Description', s(core['Description']), minHeight: 120),
      ),
      row2(
        FieldBox('Price(RM)', num2(price['Price1'] ?? cur['Price'])),
        FieldBox('Rate', num3(cur['Rate'])),
      ),
      dashHeader('Promotion Details', color: const Color(0xFFF5A623)),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FieldBox('Promotion', '--', color: const Color(0xFFF5A623)),
      ),
      row2(
        FieldBox('Promotion Price(RM)', '--', color: const Color(0xFFF5A623)),
        FieldBox('Discount', '--', color: const Color(0xFFF5A623)),
      ),
      row2(
        FieldBox('Member Price(RM)', '--', color: const Color(0xFFF5A623)),
        FieldBox('Member Discount', '--', color: const Color(0xFFF5A623)),
      ),
    ]));
  }

  Widget _uomPicker(List<Map<String, dynamic>> uoms) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
            border: Border.all(color: kRed),
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('UOM', style: TextStyle(color: kRed, fontSize: 13)),
          DropdownButton<String>(
            value: uom.isEmpty ? null : uom,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: kRed),
            items: uoms
                .map((u) => DropdownMenuItem(
                    value: u['UOM'] as String,
                    child: Center(
                        child: Text(u['UOM'],
                            style: const TextStyle(fontSize: 20)))))
                .toList(),
            onChanged: (v) => setState(() => uom = v ?? uom),
          ),
        ]),
      );
}

class PricingTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const PricingTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final uoms = (d['uoms'] as List).cast<Map<String, dynamic>>();
    final u = uoms.isNotEmpty ? uoms.first : {};
    final utd = (d['upToDateCost'] as List).cast<Map<String, dynamic>>();
    return pad(Column(children: [
      row2(FieldBox('Price 1', num2(u['Price'])), FieldBox('Price 2', num2(u['Price2']))),
      row2(FieldBox('Price 3', num2(u['Price3'])), FieldBox('Price 4', num2(u['Price4']))),
      row2(FieldBox('Price 5', num2(u['Price5'])), FieldBox('Price 6', num2(u['Price6']))),
      row2(FieldBox('Min. Selling Price(RM)', num2(u['MinSalePrice'])),
          FieldBox('Max. Selling Price(RM)', num2(u['MaxSalePrice']))),
      row2(FieldBox('Min. Purchase Price(RM)', num3(u['MinPurchasePrice'])),
          FieldBox('Max. Purchase Price(RM)', num3(u['MaxPurchasePrice']))),
      row2(FieldBox('Cost Price(RM)', num4(u['Cost'])),
          FieldBox('Real Cost Price(RM)', num4(u['RealCost']))),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Up To Date Cost',
                  style: TextStyle(color: kRed, fontWeight: FontWeight.bold)))),
      ...utd.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: kRed),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(s(r['Location']),
                    style: const TextStyle(color: kRed, fontSize: 18)),
                Text(s(r['UOM']),
                    style: const TextStyle(color: kRed, fontSize: 18)),
              ]),
              const SizedBox(height: 8),
              row2(FieldBox('Quantity', num3(r['Qty'])),
                  FieldBox('Average Cost', num4(r['AvgCost']))),
            ]),
          )),
    ]));
  }
}

class MoreTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const MoreTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = d['core'] ?? {};
    final uoms = (d['uoms'] as List).cast<Map<String, dynamic>>();
    final u = uoms.isNotEmpty ? uoms.first : {};
    final active = (c['IsActive'] == true || c['IsActive'] == 1 ||
        c['IsActive'] == 'T' || c['IsActive'] == 'True');
    return pad(Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FieldBox('Status', active ? 'Active' : 'Inactive',
            valueColor: active ? Colors.green : kRed),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FieldBox('BarCode', s(u['BarCode'])),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FieldBox('Desc 2', s(c['Desc2']), minHeight: 120),
      ),
      row2(FieldBox('Item Group', s(c['ItemGroupDesc'] ?? c['ItemGroup'])),
          FieldBox('Item Type', s(c['ItemTypeDesc'] ?? c['ItemType']))),
      row2(FieldBox('Supply Tax Code', s(c['SupplyTaxCode'])),
          FieldBox('Purchase Tax Code', s(c['PurchaseTaxCode']))),
      row2(FieldBox('Weight', num2(u['Weight'])),
          FieldBox('WeightUOM', s(u['WeightUOM']))),
      row2(FieldBox('Volume', num2(u['Volume'])),
          FieldBox('VolumeUOM', s(u['VolumeUOM']))),
      row2(FieldBox('Shelf', s(u['Shelf'])),
          FieldBox('Normal Level', num3(u['NormalLevel']))),
      row2(FieldBox('ReOrder Level', num3(u['ReOLevel'])),
          FieldBox('ReOrder Quantity', num3(u['ReOQty']))),
    ]));
  }
}

class ImageTab extends StatelessWidget {
  const ImageTab({super.key});
  @override
  Widget build(BuildContext context) => pad(Container(
        height: 400,
        decoration: BoxDecoration(
            border: Border.all(color: kRed),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: Text('Image Not Available',
                style: TextStyle(color: kRed, fontSize: 22))),
      ));
}

class StockBalanceTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const StockBalanceTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = d['core'] ?? {};
    final rows = (d['stockBalance'] as List).cast<Map<String, dynamic>>();
    return pad(Column(children: [
      FieldBox('Description', s(c['Description']), minHeight: 120),
      dashHeader('Stock Balance Details'),
      ...rows.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: kBlue),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(s(r['Location']),
                    style: const TextStyle(color: kBlue, fontSize: 18)),
                Text(s(r['UOM']),
                    style: const TextStyle(color: kBlue, fontSize: 18)),
              ]),
              const SizedBox(height: 8),
              FieldBox('Quantity', num3(r['Qty']), color: kBlue),
            ]),
          )),
    ]));
  }
}

const _kOrange = Color(0xFFF5A623);

class PromotionsTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const PromotionsTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final rows = (d['promotions'] as List).cast<Map<String, dynamic>>();
    if (rows.isEmpty) {
      return const Center(
          child: Text('No Promotions Found For This Item',
              style: TextStyle(fontSize: 20)));
    }
    return pad(Column(
      children: rows.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: _kOrange),
                borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 2),
                child: Text(s(r['Scope'], dash: 'All Outlet'),
                    style: const TextStyle(
                        color: _kOrange, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              row2(FieldBox('Promotion Code', s(r['Code']), color: _kOrange),
                  FieldBox('Priority', s(r['Priority'], dash: '0'), color: _kOrange)),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FieldBox('Promotion Description', s(r['Description']), color: _kOrange),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FieldBox('Promotion Period', s(r['Period']), color: _kOrange),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FieldBox('Promotion UOM', s(r['UOM']), color: _kOrange),
              ),
              row2(FieldBox('Promotion Price(RM)', num2(r['PromoPrice']), color: _kOrange),
                  FieldBox('Discount', s(r['Discount'], dash: ''), color: _kOrange)),
              row2(FieldBox('Member Price(RM)', num2(r['MemberPrice']), color: _kOrange),
                  FieldBox('Member Discount', s(r['MemberDiscount'], dash: ''), color: _kOrange)),
            ]),
          )).toList(),
    ));
  }
}

class SalesHistoryTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const SalesHistoryTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = d['core'] ?? {};
    final rows = (d['salesHistory'] as List).cast<Map<String, dynamic>>();
    return pad(Column(children: [
      FieldBox('Description', s(c['Description']), minHeight: 120),
      dashHeader('Sales History Details'),
      if (rows.isEmpty)
        const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No sales records', style: TextStyle(fontSize: 16))),
      ...rows.map((r) => _histCard(
            r['DocNo'], r['Party'] ?? r['Location'], r['DocDate'],
            r['Qty'], r['UnitPrice'], r['UOM'], r['Discount'])),
    ]));
  }
}

class PurchaseHistoryTab extends StatelessWidget {
  final Map<String, dynamic> d;
  const PurchaseHistoryTab(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = d['core'] ?? {};
    final rows = (d['purchaseHistory'] as List).cast<Map<String, dynamic>>();
    final err = d['purchaseHistoryError'];
    return pad(Column(children: [
      FieldBox('Description', s(c['Description']), minHeight: 120),
      dashHeader('Purchase History Details'),
      if (err != null)
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Purchase query needs schema fix:\n$err',
                style: const TextStyle(color: kRed))),
      ...rows.map((r) => _histCard(
            r['DocNo'], r['Supplier'], r['DocDate'],
            r['Qty'], r['UnitPrice'], r['UOM'], r['Discount'])),
    ]));
  }
}

Widget _histCard(docNo, party, date, qty, price, uom, disc) => Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: kBlue),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(s(docNo), style: const TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
          Text(_fmtDate(date), style: const TextStyle(color: kBlue)),
        ]),
        Text(s(party), style: const TextStyle(color: kBlue)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: FieldBox('Qty', num3(qty), color: kBlue, minHeight: 56)),
          const SizedBox(width: 6),
          Expanded(child: FieldBox('Unit Price', num2(price), color: kBlue, minHeight: 56)),
          const SizedBox(width: 6),
          Expanded(child: FieldBox('UOM', s(uom), color: kBlue, minHeight: 56)),
          const SizedBox(width: 6),
          Expanded(child: FieldBox('Discount', s(disc, dash: '--'), color: kBlue, minHeight: 56)),
        ]),
      ]),
    );

String _fmtDate(v) {
  if (v == null) return '--';
  try {
    final dt = DateTime.parse(v.toString());
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day.toString().padLeft(2, '0')}-${m[dt.month - 1]}-${dt.year}';
  } catch (_) { return v.toString(); }
}
