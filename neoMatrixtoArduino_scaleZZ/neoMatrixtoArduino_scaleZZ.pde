import processing.video.*;
import processing.serial.*;

Capture cam;
Serial arduino;
int cols = 34; // Number of NeoPixel matrix columns
int rows = 8; // Number of NeoPixel matrix rows
int totalLEDs = cols * rows;
int pixelSize = 25; // Adjust this based on your webcam's resolution
int canvaW = cols*pixelSize;
int canvaH = rows*pixelSize;


void setup() {
  size(850, 200); // size(cols*pixelSize , rows*pixelSize);
  background(0);
  ////camera
  //String[] devices = Capture.list();
  //if (devices.length == 0) {
  //  println("No capture devices found!");
  //  exit();
  //} else {
  //  println("Available capture devices:");
  //  for (String device : devices) {
  //    printArray(device);
  //  }
  //  cam = new Capture(this, devices[0]);
  //  cam.start();
  //}
  
  // Set up serial communication with Arduino
  printArray(Serial.list());
  arduino = new Serial(this, Serial.list()[1], 115200); // Change baud rate if needed
  // Ensure the correct port is selected (Serial.list()[0] might need adjustment)
}

void draw() {
  
  loadPixels(); //start loading the pixel
  
  //if (cam.available()) {
  //  cam.read();
  //}

  noStroke();
  fill(255,0,0);
  rect(0,0,width, height);
   fill(0,255,0);
  rect(0,0,width/2, height/2);
  
  loadPixels();

  for (int i = 0; i < totalLEDs; i++) {

    int x = i % cols;
    int y = i / cols;
    int loc = x + y * width/pixelSize;
    int cloc = (x*pixelSize + pixelSize/2) + y*pixelSize * width;
    color c = pixels[cloc];
    
    int r = (c >> 16) & 0xFF;
    int g = (c >> 8) & 0xFF;
    int b = c & 0xFF;
    println(cloc);
    
    // Send RGB data to Arduino
    arduino.write(x);
    arduino.write(y);
    arduino.write(r);
    arduino.write(g);
    arduino.write(b);
    delay(10); // Small delay for stability
  }
  updatePixels();
}
