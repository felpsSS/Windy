
int RED = A3;
int GREEN = A4;
int BLU = A5;

int BTTN = A0;
int PTN = A1;

unsigned long bttnDispStartTime = 0;
unsigned long BTTN_DISPLAY_MAX_MILLIS = 2000;

void setup() {

  Serial.begin(9600);

  pinMode(RED, OUTPUT);
  analogWrite(RED, 0);

  pinMode(GREEN, OUTPUT);
  analogWrite(GREEN, 0);

  pinMode(BLU, OUTPUT);
  analogWrite(BLU, 0);

  pinMode(BTTN, INPUT);
  pinMode(PTN, INPUT);

  for(int i = 0; i < 10; i++) {
    analogWrite(BLU, 1024);
    delay(100);
    analogWrite(BLU, 0);
    delay(50);
  }
}

void loop() {

  unsigned long currTime = millis();
  // put your main code here, to run repeatedly:
  int ptnVal = analogRead(PTN);
  int pressState = analogRead(BTTN);

  Serial.println(ptnVal);
  // delay(1000);

  if (pressState > 1000) {
    bttnDispStartTime = currTime;
  }

  if (bttnDispStartTime + BTTN_DISPLAY_MAX_MILLIS > currTime) {
    analogWrite(RED, 1023 - ptnVal);
    analogWrite(GREEN, ptnVal);
  } else {
    analogWrite(RED, 0);
    analogWrite(GREEN, 0);
  }
}
