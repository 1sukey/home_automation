
#include "HX711.h" // (c) 2018 Bogdan Necula - MIT License - https://github.com/bogde/HX711  
#include <Adafruit_RGBLCDShield.h>

HX711 scale;
Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

int mode=0;
const int LOADCELL_DOUT_PIN = 2;
const int LOADCELL_SCK_PIN = 3;
float calibration_factor = 56.62f; //obtained by calibrating the scale with known weights; see README

void setup() {
  Serial.begin(38400);
  Serial.println("Initializing the scale");
  
  lcd.begin(16, 2);                        // set LCD columns and rows
  lcd.setBacklight(7);
 
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.get_units(5);                  
  scale.set_scale(calibration_factor);      
  scale.tare();				                      // reset the scale to 0
}

float to_lbs(float g){ return g / 453.59237;}
float to_oz(float g){ return g / 28.349523125;}

void loop() {
  
  uint8_t buttons = lcd.readButtons();
  if (buttons && (buttons & BUTTON_UP) )  { scale.tare();               }
  if (buttons && (buttons & BUTTON_DOWN) ){ mode++; if(mode==3) mode=0; }
   
  float g = scale.get_units(10);
  float lbs = to_lbs(g);
  float oz = to_oz(g);
 
  Serial.print("\t g: ");   Serial.print(g, 1);
  Serial.print("\t oz: ");  Serial.print(oz);
  Serial.print("\t lbs: "); Serial.println(lbs);

  lcd.clear();
  lcd.setCursor(0,0); 
  
  switch(mode){
      case 0:  lcd.print(lbs); lcd.print(" lbs"); break;
      case 1:  lcd.print(oz); lcd.print(" oz"); break;
      case 2:  lcd.print(g); lcd.print(" g"); break;
  }
  
  //scale.power_down();			        // put the ADC in sleep mode
  delay(150);
  //scale.power_up();
}
