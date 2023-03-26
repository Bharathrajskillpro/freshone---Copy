class Invoice {
  final List<InvoiceItem> items;

  const Invoice({
    required this.items,
  });
}

class InvoiceItem {
  final String category;
  final String url;
  final String name;
  final String date;
  final String company;
  final String faculty;
  final String room;
  final int price;
  final String spec;

  InvoiceItem(
      {required this.category,
      required this.url,
      required this.name,
      required this.date,
      required this.company,
      required this.faculty,
      required this.room,
      required this.price,
      required this.spec});
}
