#include "emulatetag.h"
#include "NdefMessage.h"
#include <SPI.h>
#include "PN532_SPI.h"
#include "PN532.h"
#include <string.h>

PN532_SPI pn532spi(SPI, 10);
EmulateTag nfc(pn532spi);

uint8_t ndefBuf[1000]; // the size of the emulated tag, size can be any number of bytes but nothing too ridiculous
NdefMessage message;
int messageSize;

uint8_t uid[3] = {0x12, 0x34, 0x56}; // UID of tag, only 3 bytes

const char imageBase64[] PROGMEM = "Qk2+AAAAAAAAAD4AAAAoAAAAIAAAACAAAAABAAEAAAAAAIAAAADEDgAAxA4AAAAAAAAAAAAAAAAAAP///wD///////////AAP//wAD//z/AP/8/wD//P/AP/z/wD/8Pz8P/D8/D/wPAw/8DwMP/AwDM/wMAzP8//8w/P//MPz//zD8//8w/P/8DPz//Az/PwDD/z8Aw/8AAwP/AAMD/wD8zz8A/M8/wAMA/8ADAP//P/P//z/z///////////w==";
const char superMarketName[] PROGMEM = "Hobby Store";
const char customerName[] PROGMEM = "Ben Dover";
const char receiptID[] PROGMEM = "02/07/2023-69420";

// Product entries seperated by slashes (/) and ordered as productName/Qty/unitPrice
const char entries[][41] PROGMEM = {
    "Model Airplane SAAB Draken/1/50000",
    "FlySky Fi6/1/1600"};

void setup()
{
  Serial.begin(115200);
  Serial.println("------- Emulate Tag --------");

  // Adding ndef records
  message = NdefMessage();
  message.addTextRecord(imageBase64);                     // Add image as text record
  message.addTextRecord(combineData().c_str());           // Converting String returned by function to char array and adding as text record
  message.addTextRecord(combineProductEntries().c_str()); // ^^^^
  messageSize = message.getEncodedSize();
  if (messageSize > sizeof(ndefBuf))
  {
    Serial.println("ndefBuf is too small");
    while (1)
    {
    }
  }

  Serial.print("Ndef encoded message size: ");
  Serial.println(messageSize);

  message.encode(ndefBuf);

  // comment out this command for no ndef message
  nfc.setNdefFile(ndefBuf, messageSize);

  // uid must be 3 bytes!
  nfc.setUid(uid);

  nfc.init();
}

void loop()
{
  // start emulation (blocks)
  nfc.emulate();

  // emulate wih 10 second time out
  if (!nfc.emulate(10000))
  {
    Serial.print(" Timed out");
  }
  else
  {
    Serial.println("Mobile device found!");
  }

  // print message to serial monitor if write occurred
  if (nfc.writeOccured())
  {
    Serial.println("\nWrite occured !");
    uint8_t *tag_buf;
    uint16_t length;

    nfc.getContent(&tag_buf, &length);
    NdefMessage msg = NdefMessage(tag_buf, length);
    msg.print();
  }

  delay(1000);
}

// Function for combing receipt info
String combineData()
{
  String str1 = superMarketName;
  String str2 = customerName;
  String str3 = receiptID;

  String tempString = str1 + "#" + str2 + "#" + str3;
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
