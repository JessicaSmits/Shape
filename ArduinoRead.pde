//I made this class so all the arduino code is clearly 
//structured within the same class

class ArduinoRead {
  int buttonState2, buttonState3, buttonState4;
  int lastButtonState2, lastButtonState3, lastButtonState4;
  int lastDebounceTime;
  int debounceDelay;
  boolean stopFlying, strokeActive;


  ArduinoRead() {
    lastButtonState2 = arduino.LOW;
    lastButtonState3 = arduino.LOW;
    lastButtonState4 = arduino.LOW; 
    lastDebounceTime = 0;
    debounceDelay = 50;
    stopFlying = false;
    strokeActive = true;
  }

  void arduinoRead() {
    //change buttons from output to input
    arduino.pinMode(2, Arduino.INPUT);
    arduino.pinMode(3, Arduino.INPUT);
    arduino.pinMode(5, Arduino.INPUT);

    //Arduino analogread potentiometers
    int potReadLeft = arduino.analogRead(0);
    int potReadRight = arduino.analogRead(1);
    int lowNoise = int(map(potReadLeft, 0, 1023, -300, 300));
    int highNoise = int(map(potReadRight, 0, 1023, -300, 300));

    //Arduino digitalread buttons
    int colorBut = arduino.digitalRead(5);
    int stopFlyBut = arduino.digitalRead(3); 
    int strokeBut = arduino.digitalRead(2);

    //Button pressed code from: https://www.arduino.cc/en/Tutorial/BuiltInExamples/Debounce
    //I tried using the code from gitbook, but it didn't work as smooth for me as this one does 
    if (colorBut != lastButtonState2) {
      lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (colorBut != buttonState2) {
        buttonState2 = colorBut ;
        if (buttonState2 == arduino.HIGH) {
          click++;
          if (click >= darkSeaCol.length) {
            click = 0;
          }
        }
      }
    }

    if (stopFlyBut != lastButtonState3) {
      lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (stopFlyBut != buttonState3) {
        buttonState3 = stopFlyBut ;
        if (buttonState3 == arduino.HIGH) {
          stopFlying = !stopFlying;
        }
      }
    }

    if (strokeBut != lastButtonState4) {
      lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (strokeBut != buttonState4) {
        buttonState4 = strokeBut;
        if (buttonState4 == arduino.HIGH) {
          strokeActive= !strokeActive;
        }
      }
    }

    lastButtonState2 = colorBut;
    lastButtonState3 = stopFlyBut;
    lastButtonState4 = strokeBut;

    terrain.flying(lowNoise, highNoise, strokeActive, stopFlying);
  }
}
