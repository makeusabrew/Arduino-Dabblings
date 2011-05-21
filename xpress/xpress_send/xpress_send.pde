/**
 * X-Press Send Client
 *
 * Takes care of the basic 'game' logic (if you could call it that)
 * and sends notifications of correct and incorrect button presses
 * over an X-Bee radio
 *
 * (c) Nick Payne 2011
 *
 * License: MIT
 */
const int buttons[] = {-1, 2, 3, 4, 5};

boolean buttonStates[] = {0, 0, 0, 0, 0};

const int ledPin[] = {9, 10, 11};

int currentColour = 0;
int points = 0;

const byte OFF = 0;
const byte RED = 1;
const byte GREEN = 2;
const byte BLUE = 3;
const byte WHITE = 4;
const byte YELLOW = 5;

const byte STATE_INTRO = 0;
const byte STATE_GAME = 1;
const byte STATE_FINISHED = 2;

byte state;

int ledValues[][3] = {
  {HIGH, HIGH, HIGH},
  {LOW, HIGH, HIGH},
  {HIGH, LOW, HIGH},
  {HIGH, HIGH, LOW},
  {LOW, LOW, LOW},
  {LOW, LOW, HIGH}
};

unsigned long time;
unsigned long nextColourTime;

void setup() {
  for (int i = 1; i < 5; i++) {
     pinMode(buttons[i], INPUT);
  }
  
  for (int i = 0; i < 3; i++) {
    pinMode(ledPin[i], OUTPUT);
  }
  
  randomSeed(analogRead(0));
  
  Serial.begin(9600);
  
  Serial.print('X');
  delay(100);
  Serial.print('X');
  delay(100);
  Serial.print('X');
  delay(100);
  
  //state = STATE_INTRO
  for (int i = 0; i < 3; i ++) {
    ledColour(ledValues[YELLOW]);
    delay(500);
    ledColour(ledValues[OFF]);
    delay(500);
    Serial.print('S');  // get some comms going
  }
  
  currentColour = random(1, 5);
}

void loop() {
  
  // check for a duff press first
  boolean correctPress = false;
  boolean badPress = false;
  
  if (currentColour != 0) {
    for (int i = 1; i < 5; i++) {
      if (buttonPressed(i)) {
        buttonStates[i] = 1;
        if (i == currentColour) {
          correctPress = true;
        } else {
          badPress = true;
        }
      }
    }
  }
  
  // let's store button states to prevent inadvertantly awarding points twice for the same
  // colour
  for (int i = 1; i < 5; i++) {
    if (digitalRead(buttons[i]) == HIGH) {
      buttonStates[i] = 0;
    }
  }
  
  if (currentColour == 0 && millis() >= nextColourTime) {
    currentColour = random(1, 5);
  }
  
  ledColour(ledValues[currentColour]);
  
  if (badPress == true) {
    Serial.print('L');
    delay(10);
    points --;
  } else if (correctPress == true) {
    Serial.print('P');
    delay(10);
    points ++;
    currentColour = 0;
    nextColourTime = millis() + 100;
  }
}

void ledColour(int* colour) {
  for (int i = 0; i < 3; i++) {
    digitalWrite(ledPin[i], colour[i]);
  }
}

boolean buttonPressed(int button) {
  if (digitalRead(buttons[button]) == LOW && buttonStates[button] == 0) {
    return true;
  }
  return false;
}
