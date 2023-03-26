import 'package:pdf/widgets.dart';

class QRInvoice {
  final InvoiceItem item;

  const QRInvoice({
    required this.item,
  });
}

class InvoiceItem {
  final String barcode;
  final String product;

  InvoiceItem({required this.barcode, required this.product});
}
