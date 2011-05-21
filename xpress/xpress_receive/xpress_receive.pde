int greenPin = 9;
int redPin = 11;
int buzzerPin = 10;

int greenVal = 0;
int redVal = 0;

void setup() {
  pinMode(greenPin, OUTPUT);
  pinMode(redPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    int val = Serial.read();
    if (val == 'P') {
      greenVal = 255;
    } else if (val == 'L') {
      redVal = 255;
    }   
  }
  
  analogWrite(greenPin, greenVal);
  analogWrite(redPin, redVal);
  
  if (greenVal > 0) {
    greenVal --;
    delay(5);
  }
  
  if (redVal > 0) {
    redVal --;
    delay(5);
  }
}
