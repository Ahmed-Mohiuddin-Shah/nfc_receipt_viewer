/// A modal class for making Receipts from data received from NFC tag or Database
class Receipt {
  final int? id;
  final String receiptID;
  final String imageBase64;
  final String superMarketName;
  final String customerName;
  final String productEntries;

  /// This constructor returns an Object of receipt class and takes
  /// optional [id],  ID of receipt [receiptID], logo image [imageBase64],
  /// name of super market [superMarketName], customer's name [customerName]
  /// and productEntries [productEntries] seperated by "#" and thier info
  /// seperated by "/"
  Receipt(
      {this.id,
      required this.receiptID,
      required this.imageBase64,
      required this.superMarketName,
      required this.customerName,
      required this.productEntries});

  /// Returns a Receipt Object from a [Map] of [res] returned from database
  Receipt.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        receiptID = res["receiptID"],
        imageBase64 = res["image"],
        superMarketName = res["shopName"],
        customerName = res["name"],
        productEntries = res["entries"];

  /// Converts the Receipt object into a [Map] for storing in database
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'receiptID': receiptID,
      'image': imageBase64,
      'shopName': superMarketName,
      'name': customerName,
      'entries': productEntries,
    };
  }

  /// A static method for creating ad returning a receipt from logo image
  /// [logoImage], receipt info [receiptInfo] seperated by "#" and 
  /// productEntries [productEntries] seperated by "#" and thier info
  /// seperated by "/"
  static Receipt getReceipt(
      String logoImage, String receiptInfo, String productEntries) {
    List<String> temp1 = receiptInfo.split("#");              // Splitting product entries with "#"

    return Receipt(
        receiptID: temp1.elementAt(2),
        imageBase64: logoImage,
        superMarketName: temp1.elementAt(0),
        customerName: temp1.elementAt(1),
        productEntries: productEntries);                      // Returning a Receipt object
  }
}
