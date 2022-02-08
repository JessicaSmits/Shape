//The two potentiometers control the depth and height of the landscape
//The buttons control the: loop through colorschemes, on/off stroke and on/off flying

import processing.sound.*;
import cc.arduino.*;
import processing.serial.*;

Arduino arduino;
ArduinoRead input;
LandscapeGenerator terrain;
Quiz quiz;
SoundFile bgAudio;

//all these variables are global because they are used by different classes.
int darkSea, lightSea, grass, rock, snow;
int[] darkSeaCol = {#81B29A, #7FD8BE, #480CA8, #369FBA, #264653, #006D77, #851D54};
int[] lightSeaCol = {#F2CC8F, #A1FCDF, #4637CB, #D5CE6D, #2A9D8F, #83C5BE, #E3DE54}; 
int[] grassCol = {#E07A5F, #FCD29F, #4361EE, #638A28, #E9C46A, #FFDDD2, #0B8A46};
int[] rockCol = {#3D405B, #FCAB64, #4CC9F0, #071815, #F4A261, #E29578, #313628};
int[] snowCol = {#F4F1DE, #FCEFEF, #5CCEF1, #F1FAEE, #E76F51, #EDF6F9, #B0EBCB};
int click = 0;
float gradient = 0;
boolean maxGradient = false;
int scenes = 0;
float amp = 0.2;
String landscapeTitle;


void setup() {
  //P3D so you can make use of the z-axis which makes it 3D
  fullScreen(P3D, 1);
  background(0); 
  
  
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  input = new ArduinoRead();
  terrain = new LandscapeGenerator();
  quiz = new Quiz();
  bgAudio = new SoundFile(this, "audio3.mp3");
  bgAudio.loop();
  bgAudio.amp(amp);
}

void draw() {
  //making a quiz, we need different scenarios
  if (scenes == 0) {
    quiz.titleScreen();
  } else if (scenes == 1) {
    quiz.welcomeScreen();
  } else if (scenes == 2) {
    quiz.questions();
  } else {  

    //Pump up the volume 
    if (amp >= 0.995) {
      amp = 1;
      bgAudio.amp(amp);
    } else if (amp >= 0.1 && amp <= 0.995) {
      amp += 0.005;
      bgAudio.amp(amp);
    }

    input.arduinoRead();

    //slow gradient in the background from light to dark
    background(lerpColor(#0A001F, #C7FFFA, gradient));
    if (gradient <= 1 && maxGradient == false) {
      gradient += 0.001;
      if (gradient >= 1) {
        maxGradient = true;
      }
    } else if (gradient >= 0 && maxGradient == true) {
      gradient -= 0.001;
      if (gradient <= 0) {
        maxGradient = false;
      }
    }
    
    //I used push and pop for the noStroke and fill 
    push();
    noStroke();
    fill(0, 50);
    rect(width/2, height/9.5, 400, 56);
    pop();
    
    fill(255);
    textSize(28);
    text(landscapeTitle, width/2, height/9);
    textSize(18);
    text("Press 's' for a screenshot", 110, 25);

    //loop through all the color schemes
    for (int i=0; i <= click; i++) {
      darkSea = darkSeaCol[i];
      lightSea = lightSeaCol[i];
      grass = grassCol[i];
      rock = rockCol[i];
      snow = snowCol[i];
    }

    terrain.drawTerrain();
  }
}

void keyPressed() {
  //keeps track where in the quiz we are
  if (keyCode == 32) {
    scenes++;
  }
  //makes a screenshot in the sketch folder called: shots
  if (key == 's') {
    saveFrame("shots/screenshot-####.png");
  }
}
