#include <Adafruit_CCS811.h>

Adafruit_CCS811 ccs;

void setup() {

  Serial.begin(9600);
 
  if(!ccs.begin()){
    Serial.println("Failed to start sensor! Please check your wiring.");
    while(1);
  }

  while(!ccs.available()){
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nCCS ready!");
}

void loop() {

  ccs.readData();

  int co2 = ccs.geteCO2();
  int tvoc = ccs.getTVOC();

  Serial.print(co2);
  Serial.print(" : ");
  Serial.println(tvoc);

  delay(1000);
}

