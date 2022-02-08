class LandscapeGenerator {
  int cols, rows;
  int scl = 20;
  int w = 4500;
  int h = 2500;
  float flying = 0;
  float[][] landscape;

  LandscapeGenerator() {
    cols = w/scl;
    rows = h/scl;
    landscape = new float [cols][rows];
  }

  void flying(int min, int max, boolean stroke, boolean fly) {
    // I have learned this Perlin noise code from https://www.youtube.com/watch?v=IKB1hWWedMk
    // I've copied all of the code, but also tweaked some settings:
    //   - You can stop 'flying'
    //   - You can turn the stroke on and off
    //   - I made sure the landscape has different colors

    float yoff = flying;

    //map noise op het grid
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        landscape[x][y] = map(noise(xoff, yoff), 0, 1, min, max);
        xoff += 0.1;
      }
      yoff += 0.1;
    }

    //The stop/restart flying button
    if (fly) {
      flying -= 0;
    } else {
      flying -= 0.1;
    }

    //turn on/off the stroke
    if (stroke) {
      strokeWeight(0.5);
      stroke(#0b090a);
    } else {
      noStroke();
    }
  }

  void drawTerrain() {
    //make the canvas 3D by translating and rotating it
    translate(width/2, height/2+50);
    rotateX(PI/3);
    translate(-w/2, -h/2);
    
   
    //this generates the triangle shapes
    for (int y = 0; y < rows-1; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        vertex(x*scl, y*scl, landscape[x][y]);
        vertex(x*scl, (y+1)*scl, landscape[x][y+1]);
        
        //The different colors per height, within the forloop so I could use the x and y positions
        if ((landscape[x][y]) < -150) {
          fill (darkSea);
        } else if (((landscape[x][y]) > -150) && ((landscape[x][y]) < - 50)) {
          fill(lightSea);
        } else if (((landscape[x][y]) > 50) && ((landscape[x][y]) < 150)) {
          fill(rock);
        } else if ((landscape[x][y]) > 150) {
          fill(snow);
        } else {
          fill(grass);
        }
      }
      endShape();
    }
  }
}
