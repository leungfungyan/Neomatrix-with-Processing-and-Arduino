#include <Adafruit_NeoPixel.h>

#define PIN            6 // Pin connected to the NeoPixels
#define NUMPIXELS      272 // Number of NeoPixels (16x16 matrix)

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
 strip.setBrightness(5);
  Serial.begin(115200); // Set the baud rate to match Processing
}

void loop() {
  if (Serial.available() >= 4) { // Ensure complete RGB data received

    int loc = Serial.read();
    int r = Serial.read();
    int g = Serial.read();
    int b = Serial.read();

   
    // Control NeoPixels using received RGB values
    
    strip.setPixelColor(loc, strip.Color(r, g, b));
    
    strip.show(); // Display the updated NeoPixel colors
  }
  
}
