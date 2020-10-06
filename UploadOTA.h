#include <ESP8266HTTPUpdateServer.h>
#include <ESP8266WebServer.h>
ESP8266WebServer w;
ESP8266HTTPUpdateServer u;
void uploadOTA(){
  Serial.begin(115200);
  Serial.println();
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  u.setup(&w);
  w.begin();
}
