#include <ros.h>
#include <std_msgs/Byte.h>
#include <std_msgs/UInt16.h>

#include "FastLED.h"            
#define NUM_LEDS 9             // LED燈珠數量
#define DATA_PIN 5              // 控制pin
#define LED_TYPE WS2812         // LED型號
#define COLOR_ORDER GRB         // RGB排列順序


uint8_t max_bright = 128;       // LED亮度控制，最暗0~255最亮
CRGB leds[NUM_LEDS];            // 建立LEDS
/*CRGB::Rad(紅)、Orange(黃)、Blue(藍)、Green(綠)、Purple(粉紅)、Gray(白)、Black(黑)*/
//fill_palette (led名稱, 燈珠數, 起始顏色號數, 顏色差值, 色盤, 亮度, TBlendType blendType) 漸變語法

//----------------------------------------------------Ros--Subscriber-----------------------------------------------------//
//ros
byte run_command=0;
ros::NodeHandle nh;
//SUB
void table_cb(const std_msgs::Byte& data)
{
  run_command=data.data;
}
ros::Subscriber<std_msgs::Byte> sub("table_command", table_cb); 

/*----------------------------------------------------------------------------------------*/

void setup() { 
  //Serial.begin(9600);           // 串列通訊
  //delay(1000);                  // 穩定性等待
  LEDS.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS);  // 初始化LED 
  FastLED.setBrightness(128);   // 設置LED亮度

  nh.initNode();
  nh.subscribe(sub); 
}

/*--------------------------------------main loop------------------------------------------*/

void loop() { 
 
  
  if(run_command==1){             //整條單色燈//          
    ONELight();
  }else if(run_command==2){       //流星燈//    
    STARTLight();
  }else if(run_command==3){       //整條彩虹//
    RAINBOW_straight();
  }else if(run_command==4){       //彩虹循環燈// 
    RAINBOW_bf();  
  }else if(run_command==5){       //呼吸燈//
    Breathe();  
  }           
   //debug();
   
   nh.spinOnce(); 
}

//----------------------------------------------------------------------------------------//
void ONELight(){                  //整條單色燈//
//  fill_solid(leds, NUM_LEDS, CRGB::Red);
  fill_solid(leds, NUM_LEDS, CRGB(255,0,0));
  FastLED.show();
  delay(25);
}

//----------------------------------------------------------------------------------------//

void STARTLight(){                //流星燈//
  for (int i=1; i<=NUM_LEDS; i++){
  leds[i] = CRGB::Purple;
  FastLED.show();                
  delay(20);                     
  leds[i-1]= CRGB::Black;
  FastLED.show();                
  delay(20);                     
  }
}



//----------------------------------------------------------------------------------------//

void RAINBOW_straight() {           //整條彩虹//
  uint8_t beginHue = 0;
  uint8_t deltaHue = 255/NUM_LEDS;   
  fill_rainbow(leds, NUM_LEDS, beginHue, deltaHue); 
  FastLED.show();
  delay(25); 
} 

//----------------------------------------------------------------------------------------//

#define BRIGHTNESS 255   //LED亮度
#define SATURATION 255   //LED飽和度

void RAINBOW_bf() {            //彩虹循環燈//
  for (int j = 0; j < 255; j++) {
    for (int i = 0; i < NUM_LEDS; i++) {
      leds[i] = CHSV(i - (j * 2), BRIGHTNESS, SATURATION); 
    FastLED.show();
    delay(1); 
    }
  }
}

//----------------------------------------------------------------------------------------//

void Breathe() {                        //呼吸燈//
  uint8_t Change_speed = 3;    
  for (int i = 0; i < 255 ; i = i + Change_speed){
    for (int j = 0; j<NUM_LEDS; j++){
      leds[j] = CHSV(125, i, i);
      FastLED.show();
      delay(1);
    }
  }
  for (int i = 255; i > 0 ; i = i - Change_speed){
    for (int j = 0; j<NUM_LEDS; j++){
      leds[j] = CHSV(125, i, i);
      FastLED.show();
      delay(1);
    }
  }
}
//----------------------------------------------------------------------------------------//

/*
void BFLight(){                  //來回燈//
  for(int i=0; i<NUM_LEDS; i++){
  leds[i] = CRGB::Gray;
  FastLED.show();                // 更新LED色彩
  delay(50);                     // 等待500毫秒
  }
  for(int i=NUM_LEDS; i>0; i--){
  leds[i] = CRGB::Black;
  FastLED.show();                // 更新LED色彩
  delay(50);                     // 等待500毫秒
  }
}



#define twinkleInterval 10     // 閃爍時間間格
#define twinkleChance 200        // 閃爍數量，最少次0~255最多次

void RAINBOW_rain() {              //雨滴彩虹//
  int pos = random8(NUM_LEDS);
  EVERY_N_MILLISECONDS( twinkleInterval ) { 
    if( random8() < twinkleChance) {
      leds[pos] = ColorFromPalette( PartyColors_p, random8(255), 128, LINEARBLEND);
    }   
  }
  EVERY_N_MILLISECONDS( 20 ) { 
    fadeToBlackBy( leds, NUM_LEDS, 10);
  }    
  FastLED.show(); 
  delay(50);       
}
*/
