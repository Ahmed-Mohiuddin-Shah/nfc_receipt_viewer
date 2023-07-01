#include <SPI.h>
#include <MFRC522.h>
#include <NfcAdapter.h>
#include <string.h>

#define CS_PIN 10 // Chip select pin
MFRC522 mfrc522(CS_PIN, 9); // Create MFRC522 instance
NfcAdapter nfc = NfcAdapter(&mfrc522); // Create NfcAdapter Instance

char imageBase64[] = "Qk2mAAAAAAAAAD4AAAAoAAAAIAAAABoAAAABAAEAAAAAAAAAAADEDgAAxA4AAAIAAAACAAAAAAAA/////////////////8AAAAOAAAADgAAAA4AAAAPAAAAH4A/gB+Af8A/wH/AP+A/wH/gP4D/8B+B//gPAf/4DgP//AAH//4AB//+AA///wAf//+AH///gD///8B////gf///4P////H///////w==";
String superMarketName = "Imtiaz SuperMart";
String customerName = "Ali Shah";
String receiptID = "02/07/2023-00000";

// Product entries seperated by slashes (/) and ordered as productName/Qty/unitPrice
char entries[][41] = {
    "Chaki Ata/1/5000",
    "Water Bottle/3/170",
    "Quice Icecream Syrup/2/565",
    "Pizza Dough/5/350"};

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
    message.addTextRecord(imageBase64);
    message.addTextRecord(combineData().c_str());             // Converting String returned by function to char array and adding as text record
    message.addTextRecord(combineProductEntries().c_str());   // ^^^^

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

// Function for combing receipt info
String combineData()
{
  String tempString = superMarketName + "#" + customerName + "#" + receiptID;
  return tempString;
}

// Function for combining product entries by joining them with a "#" seperator
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
