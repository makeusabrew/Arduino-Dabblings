/**
 * X-Press Receive Client
 *
 * Takes care of visualisation (both er, visually and audibly) of
 * any correct / incorrect button press data it receives via
 * an X-Bee radio
 *
 * (c) Nick Payne 2011
 *
 * License: MIT
 */
 
// basic setup stuff
int greenPin = 9;
int redPin = 11;
int buzzerPin = 10;

// current values of our respective LEDs
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
    delay(10);
    if (val == 'P') {
      greenVal = 255;
      analogWrite(greenPin, greenVal);
      playNote('c', 25);
      playNote('d', 25);
      playNote('e', 25);
      playNote('g', 100);
    } else if (val == 'L') {
      redVal = 255;
      analogWrite(redPin, redVal);
      playNote('c', 50);
      delay(50);
      playNote('c', 50);
    }   
  }
  
  analogWrite(greenPin, greenVal);
  analogWrite(redPin, redVal);
  
  if (greenVal > 0) {
    greenVal --;
    delay(3);
  }
  
  if (redVal > 0) {
    redVal --;
    delay(3);
  }
}

/**
 * Note / tone logic courtesy of: http://ardx.org/src/circ/CIRC06-code.txt
 */
void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}

void playNote(char note, int duration) {
  char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
  int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };
  
  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}
