#include <SPI.h>
#include <Wire.h>
#include <Adafruit_RGBLCDShield.h>
#include <string.h>
#include <stdio.h>

//video overview: 
//    https://www.youtube.com/watch?v=1U5S5VrHy1M&list=UUhIoXVvn4ViA3AL4FJW8Yzw

Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

//water sensor = A0, pumppin = d6
#define sensorPin A0 
#define pumpPin  6 

//sleepFor in minutes, fillFor in half seconds
#define sleepFor 100
#define fillFor 20

int cycles = 0;
int waters = 0;

void setup() {

  Serial.begin(9600); //sets the baud rate for data transfer in bits/second
  pinMode(sensorPin, INPUT);//the liquid level sensor will be an input to the arduino
  pinMode(pumpPin, OUTPUT);

  lcd.begin(16, 2);     // set LCD columns and rows
  lcd.setBacklight(7);
    
}

void loop() {
	
	int i=0;

	if ( isWet() ){
		lcd_out("Sensor Wet");
		lcd_out("Skipping Water",1); 
	}
	else{

		waters++;
		lcd_out("Pump On!");
		digitalWrite(pumpPin, HIGH);

		for (i=0; i < fillFor; i++) { //flow rate takes 10 seconds to fill from empty
			lcd.setCursor(2,1);  //we delay in half seconds to test sensor on tighter loop
			lcd.print(i);
			delay(500);
			if ( isWet() ) break;
		}

		digitalWrite(pumpPin, LOW);

		if(i == fillFor){
			lcd_out("Full Cycle Ran");
		}else{
			lcd_out("Partial Cycle");
			lcd.setCursor(2,1); 
			lcd.print(i);
		}

	}

	cycles++;
	delay(2000); //time for user to read debug message
    
	//one fill should last for 100 minutes..we want to run it dry if we can 
	//(try not to hit sensor which is already showing hard water scale)
	delay_x_min(sleepFor); 
	
    
}


bool isWet()
{
    int liquid_level = analogRead(sensorPin); //arduino reads the value from the liquid level sensor
    delay(100);//delays 100ms
    if (liquid_level < 256) return false;
    return true ;
}

void delay_x_min(int minutes){

  char tmp[20];

  for(int i=0; i < minutes; i++){
      
      sprintf(tmp, " %d/%d %d min", waters, cycles, minutes - i); //fixed display bug lcd not overwriting tens digit once <= 9
      lcd.setCursor(16 - strlen(tmp),1); 
      lcd.print(tmp);
       
      for(int j=0; j < 240; j++){ //entire j loop = one minute, using small delay so buttons responsive.. 
	  delay(250);  
          uint8_t buttons = lcd.readButtons();
	  if (buttons && (buttons & BUTTON_UP) ) return; //break delay to do immediate upload test
      }
  }

}

void lcd_out(char* s){ lcd_out(s,0); }
  
void lcd_out(char* s, int row){
    if(row==0) lcd.clear();
    lcd.setCursor(0,row); 
    lcd.print(s);
}
