#include <Adafruit_NeoPixel.h>            // 載入lib

#define PIN_ 5                            // 定義腳位，輸出腳

int num=30;                               // LED燈珠的數量

Adafruit_NeoPixel strip = Adafruit_NeoPixel(num, PIN_, NEO_GRB + NEO_KHZ800); 
//Adafruit_NeoPixel類別的函式，分別為(燈珠數, 硬體連接的腳為, LED型號顏色順序與發佈頻率)

int i,r,g,b,d,s_pos,e_pos;

String inputString = "";                  // 用於保存傳入數據的字串
boolean stringComplete = false;           // 字串是否完整

void setup() {
  // put your setup code here, to run once:
  Serial.begin (115200);                  // 需與上位一致
  Serial.print ("Arduino Ready...\n");
  strip.begin();
  for(int i=0;i<num;i++) {                // 點亮第i顆LED
    strip.setPixelColor(i, 255, 60, 0 );  // 定義初始顏色 GRB色碼
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
