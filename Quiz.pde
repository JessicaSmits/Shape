//the quiz class took me longest to build and figure out
//it might also be the least structured class of them all
//probably because of all the fades and questions

class Quiz {
  String title, welcome, nextScene, q1, q2, q3, q4, finalAdj, finalNoun, adjective, noun, textThe;
  PFont georgia;
  int indexAdj, indexNoun;
  PImage imgTitle;
  
  //I already defined some things outside of the constructor so the constructor isn't full with 'double' code
  int oneTimeFade, fade, count, alpha = 0;
  int atQuestion = 1;
  int buttonW = 200;
  int buttonH = 100; 
  int duration = 8000;

  boolean pressed, theInTitle = false;
  boolean flipColor = true;

  //load my JSON file inside the class because I don't use it anywhere else
  JSONObject json = loadJSONObject("names.json");
  JSONArray adjectives = json.getJSONArray("adjectives");
  JSONArray nouns = json.getJSONArray ("nouns");
  JSONArray adjCat = json.getJSONArray("adjective categories");
  JSONArray nounCat = json.getJSONArray ("noun categories");

  Quiz() {
    georgia = createFont("georgia.ttf", 70);
    textFont(georgia);

    imgTitle = loadImage ("titleimg.png");
    title = "Shape";
    welcome = "Hello there!\nIn a minute you will be creating your own world.\nBut before we get started we'll give your\nlandscape a name thats fits you personally.";
    nextScene = "Press the spacebar to continue";
    q1 = "First off, do you want 'The' at the start of your name? like:\n'The Distand Lands' or do you want it to be 'Distand Lands'?\n\nPress 1 for 'with' press 2 for 'without'";
    q2 = "Second, what kind of adjective do you want?\n\n Press the number corresponding with category that you want";
    q3 = "Lastly, what kind of noun do you want?\n\n Press the number corresponding with category that you want";
  }

  void titleScreen() {
    //I like it centered ;)
    textAlign(CENTER);
    rectMode(CENTER);
    imageMode(CENTER);  
    image(imgTitle, width/2, height/2);

    if (millis() > duration + 6000 & millis() < duration+8000) {
      tint(0, alpha);
      if (alpha <= 100) {
        alpha += 1;
      }
      image(imgTitle, width/2, height/2);
    } else if (millis() > duration+8000 && millis()< duration+15000) {
      background(0);
      fill(fade);
      textSize(70);
      text(title, width/2, height/2);
      textSize(30);
      text("Push and turn to shape your own world", width/2, height/1.75);
      //two if-statement so the text doesn't flicker to black when checking if the first if is true
      if (fade < 255 && flipColor == true) {
        fade += 2.5;
      } 
      if (fade >= 255) {
        fade = 255;
        flipColor = false;
      }
    } else if (millis()>= duration+15000 && millis()<=duration+18000) {
      //if no button is pressed scene will move on to next one
      if ( fade > 0 && flipColor == false) {
        fade -= 2;
      } else if (fade <= 0) {
        fade = 0;
        flipColor = true;
        scenes++;
      }
    }
  }

  void welcomeScreen() {
    background(0);
    textSize(35);
    fill(255);
    text(welcome, width/2, height/2.5);

    //the famous SPACE KEY!!(i really wanted it)
    //push and pop for the fill
    if (millis() >= 25000) {
      push();
      textSize(20);
      fill(fade);
      text(nextScene, width/2, height/1.25);
      if (fade <= 255 && flipColor == true) {
        fade += 2;
        if (fade >= 255) {
          fade = 255;
          flipColor = false;
        }
      } else if ( fade >= 0 && flipColor == false) {
        fade -= 2;
        if (fade <= 0) {
          fade = 0;
          flipColor = true;
        }
      }
      pop();
    }
  }

  void questions() {
    //looks fancy
    textAlign(CENTER);
    background(oneTimeFade);
    if (oneTimeFade < 50) {
      oneTimeFade += 1;
    } 
    
    //checks at which question we are
    if (atQuestion == 1) {
      questionOne();
    } else if (atQuestion == 2) {
      questionTwo();
    } else if (atQuestion == 3) {
      questionThree();
    } else {
      nameGenerator(theInTitle, finalAdj, finalNoun, indexAdj, indexNoun);
    }
  }

  void questionOne() {
    //so you don't skip ahead in the quiz
    if (keyPressed == false && pressed == true) {
      pressed = false;
    }

    textSize(35);
    text(q1, width/2, height/3);

    //push and pop for the fill
    push();
    fill(0, 50);
    rect(width/4, height/1.5, buttonW, buttonH);
    rect(width/1.25, height/1.5, buttonW, buttonH);
    pop();

    textSize(30);
    text("(1) With", width/4, height/1.5, buttonW, buttonH/2);
    text("(2) Without", width/1.25, height/1.5, buttonW, buttonH/2);

    if (keyPressed == true && key == '1' && pressed == false) {
      pressed = true;
      theInTitle = true;
      atQuestion++;
    } else if (keyPressed == true && key == '2' && pressed == false) {
      pressed = true;
      atQuestion++;
    }
  }

  void questionTwo() {
    //so you don't skip ahead in the quiz
    if (keyPressed == false && pressed == true) {
      pressed = false;
    }

    textSize(35);
    text(q2, width/2, height/3);

    for (int i = 0; i < adjCat.size(); i++ ) {
      float buttonX = width/adjectives.size()+((buttonW+50)*i);

      //push and pop for the fill
      push();
      fill(0, 50);
      rect(buttonX, height/1.5, buttonW, buttonH);
      pop();

      textSize(30);
      text("("+(i+1)+") "+ adjCat.getString(i), buttonX, height/1.5, buttonW, buttonH/2);
    }

    //I tried to write this code shorter inside the for loop, but the code 'key == i + 1', didn't work. Also asked Luc for feedback
    //this code remembers which key you pressed and which answer you chose
    if (keyPressed == true && key == '1' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(0);
      indexAdj = 0;
      atQuestion++;
    } else if (keyPressed == true && key == '2' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(1);
      indexAdj = 1;
      atQuestion++;
    } else if (keyPressed == true && key == '3' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(2);
      indexAdj = 2;
      atQuestion++;
    } else if (keyPressed == true && key == '4' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(3);
      indexAdj = 3;
      atQuestion++;
    } else if (keyPressed == true && key == '5' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(4);
      indexAdj = 4;
      atQuestion++;
    } else if (keyPressed == true && key == '6' && pressed == false) {
      pressed = true;
      finalAdj = adjCat.getString(5);
      indexAdj = 5;
      atQuestion++;
    }
  }

  void questionThree() {
    //so you don't skip ahead in the quiz
    if (keyPressed == false && pressed == true) {
      pressed = false;
    }

    textSize(35);
    text(q3, width/2, height/3);

    for (int i = 0; i < nounCat.size(); i++ ) {
      float buttonX = width/nounCat.size()+((buttonW+100)*i);
      push();
      fill(0, 50);
      rect(buttonX, height/1.5, buttonW, buttonH);
      pop();
      textSize(30);
      text("("+(i+1)+") "+ nounCat.getString(i), buttonX, height/1.5, buttonW, buttonH/2);
    }
    
    //same code as with the second question
    if (keyPressed == true && key == '1' && pressed == false) {
      pressed = true;
      finalNoun = nounCat.getString(0);
      indexNoun = 0;
      atQuestion++;
    } else if (keyPressed == true && key == '2' && pressed == false) {
      pressed = true;
      finalNoun = nounCat.getString(1);
      indexNoun = 1;
      atQuestion++;
    } else if (keyPressed == true && key == '3' && pressed == false) {
      pressed = true;
      finalNoun = nounCat.getString(2);
      indexNoun = 2;
      atQuestion++;
    }
  }

  void nameGenerator(boolean finalThe, String finalAdj, String finalNoun, int indexAdj, int indexNoun) {

    if (count == 0) {
      //Yes, my JSON file is not optimally structured. But for now it works
      adjective = adjectives.getJSONObject(indexAdj).getJSONArray(finalAdj).getString(int(random(adjectives.getJSONObject(indexAdj).getJSONArray(finalAdj).size())));
      noun = nouns.getJSONObject(indexNoun).getJSONArray(finalNoun).getString(int(random(nouns.getJSONObject(indexNoun).getJSONArray(finalNoun).size())));

      if (finalThe == true) {
        textThe = "The";
      } else {
        textThe = "";
      }
      count++;
    } 

    textSize(35);
    landscapeTitle = textThe + " " + adjective + " " + noun;
    showsTitle();
  }

  void showsTitle() {
    textSize(70);
    fill(255);
    text(landscapeTitle, width/2, height/2);

    textSize(20);
    fill(fade);
    text(nextScene, width/2, height/1.25);
    
    //An extra fade because why not
    if (fade <= 255 && flipColor == true) {
      fade += 2;
      if (fade >= 255) {
        fade = 255;
        flipColor = false;
      }
    } else if ( fade >= 50 && flipColor == false) {
      fade -= 2;
      if (fade <= 50) {
        fade = 50;
        flipColor = true;
      }
    }
  }
}
