import processing.video.*;
import processing.serial.*;

Capture cam;
Serial arduino;
int cols = 34; // Number of NeoPixel matrix columns
int rows = 8; // Number of NeoPixel matrix rows
int totalLEDs = cols * rows;
int pixelSize = 25; // Adjust this based on your webcam's resolution
int i = 0;


int blue = 0;

void setup() {
  size(850, 200); // size(cols*pixelSize , rows*pixelSize);
  background(0);
  
  // Set up serial communication with Arduino
  printArray(Serial.list());
  arduino = new Serial(this, Serial.list()[1], 115200); // Change baud rate if needed
  // Ensure the correct port is selected (Serial.list()[0] might need adjustment)
}

void draw() {

//clear
  if (keyPressed == true) {
    background(0);
  }
  
  loadPixels();


    int x = i % cols;
    int y = i / cols;
    int loc = x + y * width/pixelSize;
    int cloc = (x*pixelSize + pixelSize/2) + y*pixelSize * width;
    color c = pixels[cloc];
    
    int r = (c >> 16) & 0xFF;
    int g = (c >> 8) & 0xFF;
    int b = c & 0xFF;
  //  println(i);
    
    arduino.write(x);
    arduino.write(y);
    arduino.write(r);
    arduino.write(g);
    arduino.write(b);
    

    //delay(10); // Small delay for stability
     i++;
      if (i >= totalLEDs){
    i = 0;
    }

  updatePixels();
}

void mouseDragged() {
  noStroke();
  fill(0,125,blue, 50);
  ellipse(mouseX,mouseY,pixelSize, pixelSize);
  blue ++;
  if (blue >= 255){
  blue = 0;
  }
  println(blue);
}
