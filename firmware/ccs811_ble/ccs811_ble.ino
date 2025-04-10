/*
XIAO ESP32C3 with CCS811 sensor

In case of errors on uploading follow these steps:

1. Plug off the USB-C
2. press BOOT on XIA0 (and hold it down)
3. Plug in the USB-C (continue to press BOOT)
4. release BOOT
5. Upload the firmware
6. press reset
*/

// CCS811 lib
#include <Adafruit_CCS811.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <cmath>


#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CO2_UUID "beb5483a-36e1-4688-b7f5-ea07361b26a8"
#define TVOC_UUID "beb5483b-36e1-4688-b7f5-ea07361b26a8"
#define BATTERY_UUID "beb5483c-36e1-4688-b7f5-ea07361b26a8"
#define QINDEX_UUID "beb5483d-36e1-4688-b7f5-ea07361b26a8"


Adafruit_CCS811 ccs;
BLECharacteristic *co2Characteristic;
BLECharacteristic *tvocCharacteristic;
BLECharacteristic *batteryCharacteristic;
BLECharacteristic *qindexCharacteristic;

const int LED_1 = D8;
const int LED_2 = D9;
const int LED_3 = D10;
const int LED_4 = D7;
const int BATTERY_PIN = A0; // I'm not sure is A0
const int BUTTON = A1;
const int CHARGE = A2;

const int delay_time = 250;
unsigned long previousMillis = 0;
long interval = 10000;      // Stores the last time the counter was updated 
bool displayLights = false;     // Interval at which to count (1000 ms = 1 second)
bool charging = false;
bool deviceConnected = false;

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
  };
  
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    BLEDevice::startAdvertising();
  }
};

void setup() {

  Serial.begin(9600);
  pinMode(BATTERY_PIN, INPUT);
  pinMode(BUTTON, INPUT);
  pinMode(LED_1, OUTPUT); 
  pinMode(LED_2, OUTPUT);
  pinMode(LED_3, OUTPUT);
  pinMode(LED_4, OUTPUT);
  pinMode(CHARGE, INPUT);

  Serial.println("START XIAO-ESP32C3");

  // CCS811 SETUP
  if(!ccs.begin()){
    Serial.println("Failed to start sensor! Please check your wiring. Exit.");
    while(1);
  }

  while(!ccs.available()) {
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, HIGH);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, HIGH);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, HIGH);
    delay(200);
  }
  
  Serial.println("CCS ready!");

  // BLE SETUP
  BLEDevice::init("Air Quality - XIAO");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  co2Characteristic = pService->createCharacteristic(
                                         CO2_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  tvocCharacteristic = pService->createCharacteristic(
                                         TVOC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  batteryCharacteristic = pService->createCharacteristic(
                                         BATTERY_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  qindexCharacteristic = pService->createCharacteristic(
                                         QINDEX_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  co2Characteristic->setValue("NULL");
  tvocCharacteristic->setValue("NULL");
  batteryCharacteristic->setValue("NULL");
  qindexCharacteristic->setValue("NULL");
  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  
  Serial.println("BLE setup done!");
}




void loop() {

  // CHARGING --------------------------------------------------------------
  float pinread = digitalRead(CHARGE);
  if (pinread && !displayLights) {
    charging = true;
  }
  else{
    charging = false;
  }
  // ------------------------------------------------------------------------

  if(!deviceConnected && !charging){
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, HIGH);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, HIGH);
    digitalWrite(LED_4, LOW);
    delay(200);
    digitalWrite(LED_1, LOW);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, HIGH);
    delay(200);
    previousMillis = millis();
    displayLights = true;
    return;
  }

  // BATTERY READING ---------------------------------------------------------
  uint32_t Vbatt = 0;
  for(int i = 0; i < 16; i++) {
    Vbatt = Vbatt + analogReadMilliVolts(BATTERY_PIN); // ADC with correction   
  }
  float Vbattf = 2 * Vbatt / 16 / 1000.0; 
  Vbattf = Vbattf - 2.7;
  int battPercent = floor((Vbattf/1.3)*100);
  // ------------------------------------------------------------------------

  // SENSOR READING AND QUALITY COMPUTATION ----------------------------------
  ccs.readData();
  int co2 = ccs.geteCO2();
  int tvoc = ccs.getTVOC();

  double co2Index = max((400.0-co2)/178.0+10.0, .0);
  double tvocIndex = max((1.1-tvoc)/0.11, .0);
  int qualityIndex = min(max(ceil(co2Index + tvocIndex / 2), .0), 10.0);
  // ------------------------------------------------------------------------

  // SERIAL DEBUG LOG -------------------------------------------------------
  Serial.print(co2);
  Serial.print(" ppm");
  Serial.print(" : ");
  Serial.print(tvoc);
  Serial.print(" ppb");
  Serial.print(" : ");
  Serial.print(qualityIndex);
  Serial.print(" air quality");
  Serial.print(pinread);
  Serial.print(" : ");
  Serial.print(battPercent);
  Serial.println(" battery");
  Serial.print(charging);
  Serial.println(" charging");
  Serial.print(displayLights);
  Serial.println(" lights");
  // ------------------------------------------------------------------------


  // LIGHTS SWITCH ON BUTTON PRESS ------------------------------------------
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    LightsOFF();
    displayLights = false;
    interval = 10000;
  }
  
  if(displayLights){
    LightsON(qualityIndex);
  }

  if(charging){
    ShowCharge(battPercent);
  }

  if(digitalRead(BUTTON)){
    previousMillis = currentMillis;
    displayLights = true;
  }
  // ------------------------------------------------------------------------


  // BLE VALUE SENDING ------------------------------------------------------
  if (deviceConnected) {
    batteryCharacteristic->setValue(battPercent);
    batteryCharacteristic->notify();

    co2Characteristic->setValue(co2);
    co2Characteristic->notify();

    tvocCharacteristic->setValue(tvoc);
    tvocCharacteristic->notify();

    qindexCharacteristic->setValue(qualityIndex);
    qindexCharacteristic->notify();
  }
  // ------------------------------------------------------------------------

  delay(delay_time);
}

void LightsOFF(){
  for(int i = 0; i<4; i++){
    int span = 8;
    if(i==3){
      span = 17;
    }
    digitalWrite(span+i, LOW);
  }
}

void LightsON(int index){
  if (index <= 2){
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, LOW);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
  } else if(index > 2 && index <= 5){
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, HIGH);
    digitalWrite(LED_3, LOW);
    digitalWrite(LED_4, LOW);
  } else if(index > 5 && index <= 7){
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, HIGH);
    digitalWrite(LED_3, HIGH);
    digitalWrite(LED_4, LOW);
  } else {
    digitalWrite(LED_1, HIGH);
    digitalWrite(LED_2, HIGH);
    digitalWrite(LED_3, HIGH);
    digitalWrite(LED_4, HIGH); 
  }
}

void ShowCharge(int percentage){

  for(int i = 0; i<4; i++){
    int span = 8;
    if(i==3){
      span = 17;
    }
    digitalWrite(span+i, LOW);
  }
  delay(750);

  if(percentage>99){
    
    if(digitalRead(BUTTON)){
      unsigned long currentMillis = millis();
      previousMillis = currentMillis;
      displayLights = true;
      return;
    }

    for(int i = 0; i<4; i++){
      int span = 8;
      if(i==3){
        span = 17;
      }
      digitalWrite(span+i, HIGH);
    }
    return;
  }
  
  int percent_int = floor((percentage)/25)+1;
  for(int i = 0; i<percent_int; i++){

    if(i==4){
      break;
    }

    if(digitalRead(BUTTON)){
      unsigned long currentMillis = millis();
      previousMillis = currentMillis;
      displayLights = true;
      return;
    }

    int span = 8;
    if(i==3){
      span = 17;
    }
    digitalWrite(span+i, HIGH);
    delay(250);
  }

}
