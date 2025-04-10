#include <Adafruit_CCS811.h>

int red = D0;
int green = D1;
int blue = D2;

Adafruit_CCS811 ccs;

void setup() {
  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);
  pinMode(blue, OUTPUT);
  digitalWrite(red, LOW);
  digitalWrite(green, LOW);
  digitalWrite(blue, LOW);

  for(int i=0; i < 10; i++) {
    digitalWrite(green, HIGH);
    delay(100);
    digitalWrite(green, LOW);
    delay(50);
  }

  Serial.begin(115200);
 
  if(!ccs.begin(0x5A)){
    digitalWrite(red, HIGH);
    while(1);
  }

  digitalWrite(red, LOW);

  while(!ccs.available()){
    digitalWrite(blue, HIGH);
    // Serial.print(".");
    delay(1000);
  }

  digitalWrite(blue, LOW);

  digitalWrite(green, HIGH);
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

