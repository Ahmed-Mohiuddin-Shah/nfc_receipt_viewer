#include <SPI.h>
#include <MFRC522.h>
#include <NfcAdapter.h>
#include <string.h>

#define CS_PIN 10
MFRC522 mfrc522(CS_PIN, 9); // Create MFRC522 instance
NfcAdapter nfc = NfcAdapter(&mfrc522);

char imageBase64[] = "Qk2mAAAAAAAAAD4AAAAoAAAAIAAAABoAAAABAAEAAAAAAAAAAADEDgAAxA4AAAIAAAACAAAAAAAA/////////////////8AAAAOAAAADgAAAA4AAAAPAAAAH4A/gB+Af8A/wH/AP+A/wH/gP4D/8B+B//gPAf/4DgP//AAH//4AB//+AA///wAf//+AH///gD///8B////gf///4P////H///////w==";
String superMarketName = "Client's SuperMarket";
String customerName = "Client's Name";
String receiptID = "aaaaaaaaaaaaaaaa";

char entries[][41] = {
    "Logitech Mouse/2/5000",
    "Water Bottle/3/550"};

void setup()
{
  Serial.begin(9600);
  Serial.println("NDEF writer\nPlace a formatted Mifare Classic or Ultralight NFC tag on the reader.");
  SPI.begin();        // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522
  nfc.begin();
}

void loop()
{
  if (nfc.tagPresent())
  {
    Serial.println("Writing record to NFC tag");

    NdefMessage message = NdefMessage();
    message.addTextRecord(imageBase64);
    message.addTextRecord(combineData().c_str());
    message.addTextRecord(combineProductEntries().c_str());

    bool success = nfc.write(message);
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

String combineData()
{
  String tempString = superMarketName + "#" + customerName + "#" + receiptID;
  return tempString;
}

String combineProductEntries()
{
  String tempString = "";
  int numOfEntries = sizeof(entries) / (sizeof(uint8_t) * sizeof(entries[0]));
  for (int i = 0; i < numOfEntries; i++)
  {
    tempString.concat(entries[i]);
    if (i < numOfEntries - 1)
    {
      tempString.concat("#");
    }
  }
  return tempString;
}
