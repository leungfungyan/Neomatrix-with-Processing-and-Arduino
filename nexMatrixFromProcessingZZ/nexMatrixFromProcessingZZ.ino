#include <Adafruit_NeoPixel.h>


int w = 34; //width of matrix
int h = 8; //height of matrix
#define PIN            6 // Pin connected to the NeoPixels
#define NUMPIXELS      w*h // Number of NeoPixels (16x16 matrix)


Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  strip.setBrightness(30);
  Serial.begin(115200); // Set the baud rate to match Processing
}

void loop() {
  if (Serial.available() >= 5) { // Ensure complete RGB data received

    int x = Serial.read();
    int y = Serial.read();
    int r = Serial.read();
    int g = Serial.read();
    int b = Serial.read();

    // Calculate pixel index based on zigzag layout (adjust the logic as needed)
    int loc;
    if (y % 2 == 0) {
      loc = y * w + x; // If even row, use regular indexing
    } else {
      loc = (y * w) + (w-1 - x); // If odd row, reverse indexing
    }

    
    // Control NeoPixels using received RGB values
    
    strip.setPixelColor(loc, strip.Color(r, g, b));
    strip.show(); // Display the updated NeoPixel colors
  }
  
}
