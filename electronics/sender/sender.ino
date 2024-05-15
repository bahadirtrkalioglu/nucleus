#include <Arduino.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <SPI.h>
#include <MFRC522.h>
#include <Deneyap_Servo.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

//Veritabanına düzgün bağlanmak için gerekli olan ilaveler
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Ağ bilgilerinizi girin
#define WIFI_SSID "S20"
#define WIFI_PASSWORD "12345678"

// Firebase proje API Key'i girin
#define API_KEY "AIzaSyByruEH2W5egUU_FqzPGyTFYrgvrrr4xU0"

// Veritabanı URL'sini girin */
#define DATABASE_URL "https://reactor-fba47-default-rtdb.europe-west1.firebasedatabase.app/"

//Bir Firebase veri objesi oluşturalım
FirebaseData fbdo;
//yetki ve ayar nesneleri oluşturalım
FirebaseAuth auth;
FirebaseConfig config;
//gerekli değişken tanımları
unsigned long sendDataPrevMillis = 0;
unsigned long getDataPrevMillis = 0;
bool signupOK = false;
int intValue = 0;
#define ledkirmizi 26
#define ledyesil 27
#define waterPin A0
#define gasPin A1
#define RST_PIN D4  // RST pin
#define SS_PIN D10  // SDA pin
#define rfid_led_pin D12
#define servo_pin D1

int gasVal;

DHT dht11(D0, DHT11);
float heat, damp;
MFRC522 mfrc522(SS_PIN, RST_PIN);
Servo door;
// İzin verilen UID'ler (hex formatında)
byte allowedUid1[] = { 0xF3, 0x0A, 0x4F, 0xFC };
byte allowedUid2[] = { 0xA3, 0x1F, 0x9F, 0xEC };
byte allowedUid3[] = { 0x53, 0x0E, 0x08, 0xF8 };

int isUid1Granted = 0;
int isUid2Granted = 0;
int isUid3Granted = 0;

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

  pinMode(rfid_led_pin, OUTPUT);  // LED pinini çıkış olarak ayarla
  SPI.begin();                    // SPI busunu başlat
  mfrc522.PCD_Init();
  door.attach(servo_pin);
  //pin durumları
  pinMode(ledkirmizi, OUTPUT);
  pinMode(ledyesil, OUTPUT);
  digitalWrite(ledkirmizi, LOW);
  digitalWrite(ledyesil, LOW);
}

void loop() {

  if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
    Serial.print("Card UID: ");
    printUid(mfrc522.uid);

    // İzin verilen UID'leri kontrol et
    if (Firebase.ready() && signupOK) {
      if (checkUid(mfrc522.uid, allowedUid1) || checkUid(mfrc522.uid, allowedUid2) || checkUid(mfrc522.uid, allowedUid3)) {
        if (checkUid(mfrc522.uid, allowedUid1)) {
          if (isUid1Granted == 1) {
            isUid1Granted = 0;
            if (Firebase.RTDB.setInt(&fbdo, "data/user1", isUid1Granted)) {
              Serial.println("USER1 Sent");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          } else {
            isUid1Granted = 1;
            if (Firebase.RTDB.setInt(&fbdo, "data/user1", isUid1Granted)) {
              Serial.println("USER1 HEY");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          }
       
        }
        if (checkUid(mfrc522.uid, allowedUid2)) {
          if (isUid2Granted == 1) {
            isUid2Granted = 0;
            if (Firebase.RTDB.setInt(&fbdo, "data/user2", isUid2Granted)) {
              Serial.println("USER2 Sent");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          } else {
            isUid2Granted = 1;
            if (Firebase.RTDB.setInt(&fbdo, "data/user2", isUid2Granted)) {
              Serial.println("USER2 Sent");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          }
          
        }
        if (checkUid(mfrc522.uid, allowedUid3)) {
          if (isUid3Granted == 1) {
            isUid3Granted = 0;
            if (Firebase.RTDB.setInt(&fbdo, "data/user3", isUid3Granted)) {
              Serial.println("USER3 Sent");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          } else {
            isUid3Granted = 1;
            if (Firebase.RTDB.setInt(&fbdo, "data/user3", isUid3Granted)) {
              Serial.println("USER3 Sent");
              Serial.println("DIR: " + fbdo.dataPath());
              Serial.println("DATA TYPE: " + fbdo.dataType());
            } else {
              Serial.println("ERROR CODE: " + fbdo.errorReason());
            }
          }
          
        }


        digitalWrite(rfid_led_pin, HIGH);  // LED'i yak
        door.write(180);  // Servo'yu 180 dereceye çevir (kapalı pozisyon)
        delay(3000);     // 1 saniye bekleyin
        digitalWrite(rfid_led_pin, LOW);   // LED'i kapat
        door.write(0);   // Servo'yu 0 dereceye çevir (açık pozisyon)
      } else {
        Serial.println("Access Denied");
      }
      delay(1000);  // Aynı kartı hızlı bir şekilde okumamak için 1 saniye bekleyin}
    }
  }

  // veritabanındaki  test/int  tablo/veri hücresine veri yazalım
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    heat = (float)dht11.readTemperature();
    damp = (float)dht11.readHumidity();
    Serial.print("Sicaklik: ");
    Serial.println(heat);
    Serial.print("Nem: ");
    Serial.println(damp);

    int waterVal = analogRead(waterPin);
    float waterPers = map(waterVal, 4095, 0, 0, 100);
    Serial.print("Water: ");
    Serial.println(waterPers);

    gasVal = analogRead(gasPin);
    float gasPers = map(gasVal, 0, 4065, 0, 100);
    Serial.print("GAS: ");
    Serial.println(gasPers);



    if (Firebase.RTDB.setFloat(&fbdo, "data/damp", damp)) {
      Serial.println("DAMP Sent");
      Serial.println("DIR: " + fbdo.dataPath());
      Serial.println("DATA TYPE: " + fbdo.dataType());
    } else {
      Serial.println("ERROR CODE: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.setFloat(&fbdo, "data/heat", heat)) {
      Serial.println("HEAT Sent");
      Serial.println("DIR: " + fbdo.dataPath());
      Serial.println("DATA TYPE: " + fbdo.dataType());
    } else {
      Serial.println("ERROR CODE: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.setFloat(&fbdo, "data/water", waterPers)) {
      Serial.println("Water Sent");
      Serial.println("DIR: " + fbdo.dataPath());
      Serial.println("DATA TYPE: " + fbdo.dataType());
    } else {
      Serial.println("ERROR CODE: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.setFloat(&fbdo, "data/gas", gasPers)) {
      Serial.println("Gas Sent");
      Serial.println("DIR: " + fbdo.dataPath());
      Serial.println("DATA TYPE: " + fbdo.dataType());
    } else {
      Serial.println("ERROR CODE: " + fbdo.errorReason());
    }
  }
}

void printUid(MFRC522::Uid uid) {
  for (byte i = 0; i < uid.size; i++) {
    Serial.print("0x");
    if (uid.uidByte[i] < 0x10) {
      Serial.print("0");
    }
    Serial.print(uid.uidByte[i], HEX);
    Serial.print(" ");
  }
  Serial.println();
}

bool checkUid(MFRC522::Uid uid, byte* allowedUid) {
  if (uid.size != sizeof(allowedUid)) {
    return false;  // UID boyutu uyuşmaz
  }

  for (byte i = 0; i < uid.size; i++) {
    if (uid.uidByte[i] != allowedUid[i]) {
      return false;  // Byte uyuşmaz
    }
  }

  return true;  // UID uyuşur
}
