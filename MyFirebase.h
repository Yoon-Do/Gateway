#ifndef MyFirebase_h
#define MyFirebase_h

#include <Arduino.h>
#include <FirebaseESP8266.h>
#include <IRremoteESP8266.h>
#include <IRrecv.h>
#include <IRutils.h>
#include <IRsend.h>

class MyFirebase{
  private:
     FirebaseData fbData;
     String FIREBASE_HOST;
     String FIREBASE_AUTH;
  public:
     MyFirebase();
     void Set_HOST_And_AUTH(String, String);
     bool Check_HOST_And_AUTH();
     bool ConnectToFirebase();
     void ReceiveIR(String);
     void SendIR(String);
     void DoIrCommands(String);
     ~ MyFirebase();
};
MyFirebase::MyFirebase()
{
  FIREBASE_HOST = "";
  FIREBASE_AUTH = "";
}
MyFirebase:: ~MyFirebase(){ }

void MyFirebase::Set_HOST_And_AUTH(String FIREBASE_HOST, String FIREBASE_AUTH)
{
  this->FIREBASE_HOST = FIREBASE_HOST;
  this->FIREBASE_AUTH = FIREBASE_AUTH;
}

bool MyFirebase::Check_HOST_And_AUTH()
{
  return (this->FIREBASE_HOST != "" && this->FIREBASE_AUTH!= "");
}

bool MyFirebase::ConnectToFirebase()
{
  if(this->Check_HOST_And_AUTH()){
    Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
    Firebase.reconnectWiFi(true);
    this->fbData.setBSSLBufferSize(1024, 1024);
    this->fbData.setResponseSize(1024);
    return true;
  }
  return false;
}
void MyFirebase::ReceiveIR(String path)
{
  const uint16_t kRecvPin = 14;
  IRrecv irrecv(kRecvPin);
  decode_results results;
  irrecv.enableIRIn();

  String isReceived = "";
  Firebase.getString(fbData, path + "/isReceived", isReceived);
  //mot lan co the nhan nhieu ma ne dung while
  Serial.println("Receiving...");
  while(isReceived != "FALSE")
  {
   if (irrecv.decode(&results))
   {
     //tim ma raw
      char rawlen[8];
      itoa(results.rawlen, rawlen, 10);
      Serial.println("rawlen: ");
      Serial.println(rawlen);
      String raw = "";
      for (int i = 1; i < results.rawlen; i++) {
        raw += results.rawbuf[i];
        if (i!= results.rawlen - 1)
          raw += " ";
      }
      Serial.println("Raw: [" + raw + "]");

    //tim ma, so bit, loai ma hoa
      char code[15];
      char bitnumStr[5];
      String typeStr = "";
    //ep kieu long ve char* de gui len database
      ltoa((long)results.value,code, 16);
      itoa(results.bits, bitnumStr,10);
    //tim loai ma hoa
      if (results.decode_type == NEC) {
        typeStr = "NEC";
      } else if (results.decode_type == SONY) {
        typeStr = "SONY";
      } else if (results.decode_type == RC5) {
        typeStr = "RC5";
      } else if (results.decode_type == RC6) {
        typeStr = "RC6";
      } else if (results.decode_type == UNKNOWN) {
        typeStr = "UNKNOWN";
      }
      Serial.print("Ma: ");
      Serial.println(code);
      Serial.print("So bit: ");
      Serial.println(bitnumStr);
      Serial.println("Loai: " + typeStr);
    
    //cap nhat len database
      if(Firebase.setString(fbData,path + "/Get/code",code) 
        && Firebase.setString(fbData, path + "/Get/bitnum",bitnumStr)
        && Firebase.setString(fbData, path + "/Get/type", typeStr) 
        && Firebase.setString(fbData, path + "/Get/rawbuf", raw)
        && Firebase.setString(fbData, path + "/Get/rawlen", rawlen) )
        Serial.println("Succeed");
      else{
        Serial.println("Failed");
        Serial.println(fbData.errorReason());
      }
      irrecv.resume();  //Receive the next value
      Firebase.setString(fbData, path + "/isReceived", "FALSE");
    }
    Firebase.getString(fbData, path + "/isReceived", isReceived);
  }
  irrecv.disableIRIn();
}

void MyFirebase::SendIR(String path)
{
  const uint16_t kIrLed = 4;
  IRsend irsend(kIrLed); 
  irsend.begin();
  String require = "";
  if(!Firebase.getString(fbData, path + "/Send/code", require))
    Serial.println(fbData.errorReason());
  else{
    Serial.println("Nhan duoc: " + require);
  //doi string ve long
    long int code;
    char codeArr[15];
    require.toCharArray(codeArr,15);
    code = strtol(codeArr,NULL,16);
    Serial.println("Ma gui di: ");
    Serial.println(code);
  //lay ve so bit
    String bitnumStr;
    int bitnum = 20;
    if (Firebase.getString(fbData, path + "/Send/bitnum", bitnumStr))
       bitnum=bitnumStr.toInt();      
    //lay ve loai decode
    String typestr="";
    if(!Firebase.getString(fbData, path + "/Send/type", typestr))
    {
       Serial.println(fbData.errorReason());
       return;
    }
   //gui tin hieu theo loai
    Serial.println("Loai: " + typestr);
    if (typestr == "NEC")
      irsend.sendNEC(code, bitnum);
    else if (typestr == "SONY") 
      irsend.sendSony(code, bitnum);
    else if (typestr == "RC5")
      irsend.sendRC5(code, bitnum);
    else if (typestr == "RC6")
      irsend.sendRC6(code, bitnum);
    else if (typestr == "SAMSUNG")
      irsend.sendSAMSUNG(code, bitnum);
    else if (typestr == "UNKNOWN"){
      //gui raw
      String rawbufStr, rawlenStr;
      if(!Firebase.getString(fbData, path + "/Send/rawbuf", rawbufStr) 
        || !Firebase.getString(fbData, path + "/Send/rawlen", rawlenStr))
          Serial.println(fbData.errorReason());
      else{
        //cat chuoi raw thanh mang uint16
          int rawlen = rawlenStr.toInt();
          uint16_t* rawbuf = new uint16_t [rawlen];
          for(int i = 0; i<rawlen && rawbufStr.length() != 0; i++){
            size_t pos = rawbufStr.indexOf(' ');
            String cut = "";
            if(pos != -1){
              cut = rawbufStr.substring(0,pos);
              rawbufStr = rawbufStr.substring(pos+1,rawbufStr.length());
            }
            else{
              cut = rawbufStr;
            }
            char temp[8];
            cut.toCharArray(temp,8);
            Serial.println(temp);
            rawbuf[i] = atol(temp);
          }
          irsend.sendRaw(rawbuf,rawlen,38);
      }
    }
  }
  //thong bao da thuc hien cho database
  Firebase.setString(fbData, path + "/isSend", "FALSE"); 
}
void MyFirebase::DoIrCommands(String path)
{
  String command;
  Firebase.getString(fbData, path + "/CommandAvailable", command);
  if(command == "TRUE")
  {
    //kiem tra ir send
    String isSend = "";
    Firebase.getString(fbData, path + "/isSend", isSend);
    if(isSend != "FALSE")
      SendIR(path);   
       
    //kiem tra ir recv
    String isReceived = "";
    Firebase.getString(fbData, path + "/isReceived", isReceived);
    if(isReceived != "FALSE")
      ReceiveIR(path);    
      
    //cap nhat
    Firebase.setString(fbData, path + "/CommandAvailable", "FALSE");
  }
  Serial.println("None requirement now");
}
#endif
