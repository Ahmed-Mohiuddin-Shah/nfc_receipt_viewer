#include <SPI.h>
#include <MFRC522.h>
#include <NfcAdapter.h>
#include <string.h>

#define CS_PIN 10 // Chip select pin
MFRC522 mfrc522(CS_PIN, 9); // Create MFRC522 instance
NfcAdapter nfc = NfcAdapter(&mfrc522); // Create NfcAdapter Instance

// char imageBase64[] = "Qk2+AAAAAAAAAD4AAAAoAAAAIAAAACAAAAABAAEAAAAAAIAAAADEDgAAxA4AAAAAAAAAAAAAAAAAAP///wD///////////AAP//wAD//z/AP/8/wD//P/AP/z/wD/8Pz8P/D8/D/wPAw/8DwMP/AwDM/wMAzP8//8w/P//MPz//zD8//8w/P/8DPz//Az/PwDD/z8Aw/8AAwP/AAMD/wD8zz8A/M8/wAMA/8ADAP//P/P//z/z///////////w==";
// String superMarketName = "Hobby Store";
// String customerName = "Ben Dover";
// String receiptID = "02/07/2023-69420";

// // Product entries seperated by slashes (/) and ordered as productName/Qty/unitPrice
// char entries[][41] = {
//     "Model Airplane SAAD Draken/1/50000",
//     "FlySky Fi6/1/1600"
//     };

void setup()
{
  Serial.begin(9600);
  Serial.println("NDEF writer\nPlace a formatted Mifare Classic or Ultralight NFC tag on the reader.");
  SPI.begin();        // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522
  nfc.begin();        // Begin NfcAdapter
}

void loop()
{
  if (nfc.tagPresent())
  {
    Serial.println("Writing record to NFC tag");

    // Adding ndef records
    NdefMessage message = NdefMessage();
    message.addTextRecord("Qk2+AAAAAAAAAD4AAAAoAAAAIAAAACAAAAABAAEAAAAAAIAAAADEDgAAxA4AAAAAAAAAAAAAAAAAAP///wD///////////AAP//wAD//z/AP/8/wD//P/AP/z/wD/8Pz8P/D8/D/wPAw/8DwMP/AwDM/wMAzP8//8w/P//MPz//zD8//8w/P/8DPz//Az/PwDD/z8Aw/8AAwP/AAMD/wD8zz8A/M8/wAMA/8ADAP//P/P//z/z///////////w==");
  message.addTextRecord("Hobby Store#Ben Dover#02/07/2023-69420");
  message.addTextRecord("Model Airplane SAAB Draken/1/50000#FlySky Fi6/1/1600");   // ^^^^

    bool success = nfc.write(message);                        // Writing to nfc card and taking return value to check for successfull read and write
    if (success)
    {
      Serial.println("\tSuccess. Try reading this tag with your phone.");
      delay(1000);
    }
    else
    {
      Serial.println("\tWrite failed.");
    }
  }
  delay(500);
}

// // Function for combing receipt info
// String combineData()
// {
//   String tempString = superMarketName + "#" + customerName + "#" + receiptID;
//   return tempString;
// }

// // Function for combining product entries by joining them with a "#" seperator
// String combineProductEntries()
// {
//   String tempString = "";
//   int numOfEntries = sizeof(entries) / (sizeof(uint8_t) * sizeof(entries[0]));
//   for (int i = 0; i < numOfEntries; i++)
//   {
//     tempString.concat(entries[i]);
//     if (i < numOfEntries - 1)
//     {
//       tempString.concat("#");
//     }
//   }
//   return tempString;
// }
