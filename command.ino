#include "MyFirebase.h"  
#include "UploadOTA.h"  
#include "EEPROM.h"
#include <ESP8266WiFi.h>
#define FIREBASE_HOST "hass-ea1ca.firebaseio.com"
#define FIREBASE_AUTH "pMz9fr0qAZ2TlirsAvptuNMvg45IpGsVxmiZgUu1"
#define ssid  "V"
#define pass  "123Vy456"


MyFirebase myFirebase;
String admin = "pUJTYSD95LXSE434VSW7aYPbX402";
String irPath = "/" + admin + "/Ir";

void setup() {
  Serial.begin(115200);
  Serial.println("Connecting to wifi");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, pass);
  while(WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.println("Connecting...");
  }
  Serial.println("Connected");
  myFirebase.Set_HOST_And_AUTH(FIREBASE_HOST, FIREBASE_AUTH);
  myFirebase.ConnectToFirebase();
}
void loop() {
  w.handleClient();
  myFirebase.DoIrCommands(irPath);
  setup1();
}
