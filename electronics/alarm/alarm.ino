#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Ağ bilgilerinizi girin
#define WIFI_SSID "S20"
#define WIFI_PASSWORD "12345678"

// Firebase proje API Key'i girin
#define API_KEY "AIzaSyByruEH2W5egUU_FqzPGyTFYrgvrrr4xU0"

// Veritabanı URL'sini girin */
#define DATABASE_URL "https://reactor-fba47-default-rtdb.europe-west1.firebasedatabase.app/"

#define buzzer_pin D0
#define red_pin D4
#define green_pin D5
#define blue_pin D6
#define motor_pin1 D7
#define motor_pin2 D8

//Bir Firebase veri objesi oluşturalım
FirebaseData fbdo;
//yetki ve ayar nesneleri oluşturalım
FirebaseAuth auth;
FirebaseConfig config;
//gerekli değişken tanımları
unsigned long sendDataPrevMillis = 0;
unsigned long getDataPrevMillis = 0;
bool signupOK = false;

String stateValue = "natural";
float heat = 25;
float theat = 29;
float water = 5;
float twater = 43;
float gas = 35;
float tgas = 45;
int motor = 0;


void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Ağa bağlanıyor");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Bağlandı. IP Adresi: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* yukarıdaki API keyi ayarlara atayalım */
  config.api_key = API_KEY;

  /* veritabanı URL'sini ayarlara atayalım */
  config.database_url = DATABASE_URL;

  /* giriş yapalım */
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* token'in geçerlilik durumu kontrolü için gerekli */
  config.token_status_callback = tokenStatusCallback;
  //bağlantıyı başlatalım
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  // put your setup code here, to run once:
  pinMode(buzzer_pin, OUTPUT);
  pinMode(red_pin, OUTPUT);
  pinMode(blue_pin, OUTPUT);
  pinMode(green_pin, OUTPUT);
  pinMode(motor_pin1, OUTPUT);
  pinMode(motor_pin2, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Firebase.ready() && signupOK && (millis() - getDataPrevMillis > 10000 || getDataPrevMillis == 0)) {
    getDataPrevMillis = millis();
    if (Firebase.RTDB.getString(&fbdo, "/data/state")) {
      if (fbdo.dataType() == "string") {  //gelen veri string mi kontrol ediyoruz
        stateValue = fbdo.stringData();
        Serial.print("State: ");
        Serial.println(stateValue);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/heat")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        heat = fbdo.floatData();
        Serial.print("Heat: ");
        Serial.println(heat);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/theat")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        theat = fbdo.floatData();
        Serial.print("THeat: ");
        Serial.println(theat);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/water")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        water = fbdo.floatData();
        Serial.print("Water: ");
        Serial.println(water);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/twater")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        twater = fbdo.floatData();
        Serial.print("TWater: ");
        Serial.println(twater);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/gas")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        gas = fbdo.floatData();
        Serial.print("Gas: ");
        Serial.println(gas);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getFloat(&fbdo, "/data/tgas")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        tgas = fbdo.floatData();
        Serial.print("TGas: ");
        Serial.println(tgas);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getInt(&fbdo, "/data/motor")) {
      if (fbdo.dataType() == "int") {  //gelen veri string mi kontrol ediyoruz
        motor = fbdo.intData();
        Serial.print("Motor: ");
        Serial.println(motor);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
  }
  if (stateValue == "quake") {
    quake();
  } else if (stateValue == "fire" || heat >= theat) {
    fire();
  } else if (stateValue == "leak" || gas >= tgas) {
    leak();
  } else if (stateValue == "flood" || water >= twater) {
    flood();
  } else if (stateValue == "emergency") {
    emergency();
  } else if (stateValue == "natural") {
    natural();
  }
  if (motor == 1) {
    digitalWrite(motor_pin1, HIGH);
    digitalWrite(motor_pin2, LOW);
  } else {
    digitalWrite(motor_pin1, LOW);
    digitalWrite(motor_pin2, LOW);
  }
  //okuduğumuz değer çift ise kırmızı, tek ise yeşil ledi yakalım
}

void motor_data(int boolen) {

  if (Firebase.ready() && signupOK) {
    sendDataPrevMillis = millis();
    motor = boolen;
    if (Firebase.RTDB.setInt(&fbdo, "data/motor", boolen)) {
      Serial.println("MOTOR Sent");
      Serial.println("DIR: " + fbdo.dataPath());
      Serial.println("DATA TYPE: " + fbdo.dataType());
    } else {
      Serial.println("ERROR CODE: " + fbdo.errorReason());
    }
  }
}





void quake() {
  if (motor != 0) {
    motor_data(0);
  }
  digitalWrite(red_pin, 0);
  digitalWrite(green_pin, 0);
  digitalWrite(blue_pin, 1);
  digitalWrite(buzzer_pin, 1);
  delay(300);
  digitalWrite(buzzer_pin, 0);
  delay(100);
}
void fire() {
  if (motor != 1) {
    motor_data(1);
  }
  digitalWrite(red_pin, 0);
  digitalWrite(green_pin, 1);
  digitalWrite(blue_pin, 1);
  digitalWrite(buzzer_pin, 1);
  delay(600);
  digitalWrite(buzzer_pin, 0);
  delay(300);
}
void flood() {
  if (motor != 0) {
    motor_data(0);
  }
  digitalWrite(red_pin, 1);
  digitalWrite(green_pin, 1);
  digitalWrite(blue_pin, 0);
  digitalWrite(buzzer_pin, 1);
  delay(800);
  digitalWrite(buzzer_pin, 0);
  delay(300);
}
void leak() {
  if (motor != 1) {
    motor_data(1);
  }
  digitalWrite(red_pin, 1);
  digitalWrite(green_pin, 0);
  digitalWrite(blue_pin, 1);
  digitalWrite(buzzer_pin, 1);
  delay(700);
  digitalWrite(buzzer_pin, 0);
  delay(400);
}
void emergency() {
  if (motor != 1) {
    motor_data(1);
  }
  digitalWrite(red_pin, 0);
  digitalWrite(green_pin, 1);
  digitalWrite(blue_pin, 0);
  digitalWrite(buzzer_pin, 1);
  delay(200);
  digitalWrite(buzzer_pin, 0);
  delay(100);
}
void natural() {
  if (motor != 0) {
    motor_data(0);
  }
  digitalWrite(red_pin, 1);
  digitalWrite(green_pin, 1);
  digitalWrite(blue_pin, 1);
}
