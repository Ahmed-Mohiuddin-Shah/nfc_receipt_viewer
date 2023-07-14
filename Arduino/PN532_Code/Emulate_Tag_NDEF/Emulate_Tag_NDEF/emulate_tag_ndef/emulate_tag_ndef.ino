// Libraries
// https://github.com/Seeed-Studio/PN532


#include "SPI.h"
#include "PN532_SPI.h"
#include "emulatetag.h"
#include "NdefMessage.h"

PN532_SPI pn532spi(SPI, 10);
EmulateTag nfc(pn532spi);

uint8_t ndefBuf[400];
NdefMessage message;
int messageSize;

uint8_t uid[3] = { 0x12, 0x34, 0x56 };

void setup()
{
  Serial.begin(115200);
  Serial.println("------- Emulate Tag --------");
  
  message = NdefMessage();
  message.addTextRecord("Qk2+AAAAAAAAAD4AAAAoAAAAIAAAACAAAAABAAEAAAAAAIAAAADEDgAAxA4AAAAAAAAAAAAAAAAAAP///wD///////////AAP//wAD//z/AP/8/wD//P/AP/z/wD/8Pz8P/D8/D/wPAw/8DwMP/AwDM/wMAzP8//8w/P//MPz//zD8//8w/P/8DPz//Az/PwDD/z8Aw/8AAwP/AAMD/wD8zz8A/M8/wAMA/8ADAP//P/P//z/z///////////w==");
  message.addTextRecord("Hobby Store#Ben Dover#02/07/2023-69420");
  message.addTextRecord("Model Airplane SAAB Draken/1/50000#FlySky Fi6/1/1600");
  
  messageSize = message.getEncodedSize();
  if (messageSize > sizeof(ndefBuf)) {
      Serial.println("ndefBuf is too small");
      while (1) { }
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

void loop(){
    // uncomment for overriding ndef in case a write to this tag occured
    nfc.setNdefFile(ndefBuf, messageSize); 
    
    // start emulation (blocks)
    // nfc.emulate();
        
    // or start emulation with timeout
    if(!nfc.emulate(1000)){ // timeout 1 second
      Serial.println("timed out");
    }
    
    // deny writing to the tag
    nfc.setTagWriteable(false);
    
    // if(nfc.writeOccured()){
    //    Serial.println("\nWrite occured !");
    //    uint8_t* tag_buf;
    //    uint16_t length;
       
    //    nfc.getContent(&tag_buf, &length);
    //    NdefMessage msg = NdefMessage(tag_buf, length);
    //    msg.print();
    // }

    delay(1000);
}
