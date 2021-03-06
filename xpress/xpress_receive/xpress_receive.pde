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
int speakerPin = 10;

// current values of our respective LEDs
int greenVal = 0;
int redVal = 0;

void setup() {
  pinMode(greenPin, OUTPUT);
  pinMode(redPin, OUTPUT);
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
  
  unsigned int startCounter = 0;
  while(true) {
    if (Serial.available() && Serial.read() == 'X') {
      delay(10);
      Serial.write('X');
      break;
    }
    
    if (startCounter++ % 100 < 50) {
      analogWrite(greenPin, 255);
      analogWrite(redPin, 0);
    } else {
      analogWrite(redPin, 255);
      analogWrite(greenPin, 0);
    }
    delay(10);
  }
}

void loop() {
  if (Serial.available() > 0) {
    int val = Serial.read();
    delay(10);
    
    switch (val) {
      case 'P':
        greenVal = 255;
        analogWrite(greenPin, greenVal);
        playNote('c', 50);
        playNote('d', 50);
        playNote('e', 50);
        playNote('g', 200);
        break;
      case 'L':
        redVal = 255;
        analogWrite(redPin, redVal);
        playNote('c', 75);
        delay(75);
        playNote('c', 200);
        break;
      case 'S':
        redVal = greenVal = 64;
        analogWrite(greenPin, greenVal);
        analogWrite(redPin, redVal);
        playNote('c', 100);
        
        break;
      case 'G':
        redVal = greenVal = 128;
        analogWrite(greenPin, greenVal);
        analogWrite(redPin, redVal);
        playNote('C', 200);
        
        break;
      default:
        // ignore
        break;
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
