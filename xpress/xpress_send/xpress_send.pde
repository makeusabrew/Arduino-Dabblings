
const int buttons[] = {-1, 2, 3, 4, 5};

int buttonStates[] = {0, 0, 0, 0, 0};

const int ledPin[] = {9, 10, 11};

int currentColour = 0;
int points = 0;

const int OFF = 0;
const int RED = 1;
const int GREEN = 2;
const int BLUE = 3;
const int WHITE = 4;

int ledValues[][3] = {
  {HIGH, HIGH, HIGH},
  {LOW, HIGH, HIGH},
  {HIGH, LOW, HIGH},
  {HIGH, HIGH, LOW},
  {LOW, LOW, LOW}
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
  
  currentColour = 0;
  
  ledColour(ledValues[currentColour]);
  
  Serial.begin(9600);
  
  nextColourTime = millis() + 3000;
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
    points --;
  } else if (correctPress == true) {
    Serial.print('P');
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
