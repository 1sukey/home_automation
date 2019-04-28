bool debug = true;

void setup() {
  Serial.begin(115200);
}

void loop() {
  SerialControlMode();
}

void SerialControlMode(){

	String n;
	//Servo* s = 0;

	int i=1;
	int pos[7] = {0, 0, 0, 0, 0, 0, 0};
       char tmp[100];
       char *t = &tmp[0];

	//expected input 6 csv numbers for servo positions \n
	//0,0,0,0,0,0\n
        while(!Serial.available()) delay(1);
        
	n = Serial.readStringUntil('\n');
	
	if(n.length() >= 100){
		Serial.println("Invalid to long!");
		return;
	}

	strcpy(tmp,n.c_str());

	while(i < 7){
	    pos[i] = atoi(t);
	    i++;
		if(i!=7){
			while(*t != ','){
				if(*t == 0){i=7; break;}
				t++;
			}
		}
		t++;
	}

	if(i!=7){
		Serial.print("Invalid command string i=");
		Serial.println(i);
		Serial.println();
		return;
	}

	if(debug){
		Serial.print("Parsed input: ");
		for(i=1; i<=6; i++){
			Serial.print(pos[i]);
			Serial.print( (i==6 ? '\n' : ',' ) );
		}
	}

        Serial.println("OK");

}
