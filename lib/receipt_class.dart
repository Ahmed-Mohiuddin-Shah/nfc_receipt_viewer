class Receipt {
  final int? id;
  final String receiptID;
  final String imageBase64;
  final String superMarketName;
  final String customerName;
  final String productEntries;
  final String receiptTotal;

  Receipt(
      {this.id,
      required this.receiptID,
      required this.imageBase64,
      required this.superMarketName,
      required this.customerName,
      required this.productEntries,
      required this.receiptTotal});

  Receipt.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        receiptID = res["receiptID"],
        imageBase64 = res["image"],
        superMarketName = res["shopName"],
        customerName = res["name"],
        productEntries = res["entries"],
        receiptTotal = res["total"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'receiptID': receiptID,
      'shopName': superMarketName,
      'name': customerName,
      'entries': productEntries,
      'total': receiptTotal,
    };
  }
}
