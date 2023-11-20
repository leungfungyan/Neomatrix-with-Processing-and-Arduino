import processing.video.*;
import processing.serial.*;

Capture cam;
Serial arduino;
int cols = 34; // Number of NeoPixel matrix columns
int rows = 8; // Number of NeoPixel matrix rows
int totalLEDs = cols * rows;
int pixelSize = 25; // Adjust this based on your webcam's resolution
int i = 0; //pixel indeox

//pixelate video
int videoScale = pixelSize;
int Vcols, Vrows; // Number of columns and rows in the system

void setup() {
  size(850, 200); // size(cols*pixelSize , rows*pixelSize);
  background(0);
  
  //camera
  String[] devices = Capture.list();
  if (devices.length == 0) {
    println("No capture devices found!");
    exit();
  } else {
    println("Available capture devices:");
    for (String device : devices) {
      printArray(device);
    }
    
    Vcols = width/videoScale;
    Vrows = height/videoScale;
    cam = new Capture(this, Vcols, Vrows);
    cam.start();
  }
  
  // Set up serial communication with Arduino
  printArray(Serial.list());
  arduino = new Serial(this, Serial.list()[1], 115200); // Change baud rate if needed
  // Ensure the correct port is selected (Serial.list()[0] might need adjustment)
}

void captureEvent(Capture cam) {
  cam.read();
}

void draw() {
  
  //making the video pixelated and displayed on screen
  background(0);
  cam.loadPixels();
  // Begin loop for columns
  for (int k = 0; k < Vcols; k++) {
    // Begin loop for rows
    for (int j = 0; j < Vrows; j++) {
      // Where are you, pixel-wise?
      int a = k*videoScale;
      int b = j*videoScale;

      // Reverse the column to mirro the image.
      int loc = (cam.width - k - 1) + j * cam.width;

      color c = cam.pixels[loc];
      // A rectangle's size is calculated as a function of the pixel’s brightness.
      // A bright pixel is a large rectangle, and a dark pixel is a small one.
      float sz = (brightness(c));
      if(sz > 125){
      fill(c);
      }else{
      fill(0);
      }
     // println(sz);
      rectMode(CENTER);
     // fill(sz);
      noStroke();
      rect(a + videoScale/2, b + videoScale/2,25, 25);
    }
  }

  
    //load pixel for neomatrix
    loadPixels(); 

    int x = i % cols;
    int y = i / cols;
    int loc = x + y * width/pixelSize; //pixel index, for not zz 
    int cloc = (x*pixelSize + pixelSize/2) + y*pixelSize * width;
    color c = pixels[cloc];
    
    int r = (c >> 16) & 0xFF;
    int g = (c >> 8) & 0xFF;
    int b = c & 0xFF;
    //println(i);
    
    //sending data to Arduino
    //println("index: [" +loc +"]  position: "+ x +","+ y +"  colour: "+ r +","+ g +","+ b);
    arduino.write(x);
    arduino.write(y);
    arduino.write(r);
    arduino.write(g);
    arduino.write(b);
    delay(10); // Small delay for stability
    
    //for looping all the pixel
     i++; 
      if (i >= totalLEDs){
          i = 0;
          }

  updatePixels();
}
