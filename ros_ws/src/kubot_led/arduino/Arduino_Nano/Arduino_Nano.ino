#include <Adafruit_NeoPixel.h>  // Install


#define PIN_ 5  // pin define, signal output


int num=30; // number of led units, the no.0 unit is the one closest to the wires
Adafruit_NeoPixel strip = Adafruit_NeoPixel(num, PIN_, NEO_GRB + NEO_KHZ800);
//declare the variable, strip 

int i,r,g,b,d,s_pos,e_pos;
String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete



void setup() {
  // put your setup code here, to run once:
  Serial.begin (115200);
  Serial.print ("Arduino Ready...\n");
  strip.begin();
  for(int i=0;i<num;i++)
  {
    strip.setPixelColor(i, 255, 60, 0 ); // default amber color
  }
  strip.show();
  i=0;
  r=0;
  g=0;
  b=0; 
}

void loop() {
    if (stringComplete) {
      if (inputString.startsWith("i")) 
      {
        s_pos = inputString.indexOf('i'); //start position
        e_pos = inputString.indexOf('r'); //end position
        i=inputString.substring(s_pos+1,e_pos).toInt();
    
        s_pos = inputString.indexOf('r');
        e_pos = inputString.indexOf('g');
        r=inputString.substring(s_pos+1,e_pos).toInt();

        s_pos = inputString.indexOf('g');
        e_pos = inputString.indexOf('b');
        g=inputString.substring(s_pos+1,e_pos).toInt();

        s_pos = inputString.indexOf('b');
        e_pos = inputString.indexOf('\n');
        b=inputString.substring(s_pos+1,e_pos).toInt();
          
        strip.setPixelColor(i, r, g, b );
      }

      else if (inputString.startsWith("show")) 
      {
        strip.show();}
        inputString = "";
        stringComplete = false;
      }

}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    inputString += inChar;

    if (inputString.endsWith("\n")) {
      stringComplete = true;
    }
  }
}
