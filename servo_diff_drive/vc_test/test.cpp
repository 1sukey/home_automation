#include <stdio.h>
#include <conio.h>

struct servoPos{
	int left;
	int right;
};

struct pt{
	int x;
	int y;
	char* name;
};

int deadZone = 40;

int constrain(int val, int min, int max){
	if(val > max) return max;
	if(val < min) return min;
	return val;
}

long map(long x, long in_min, long in_max, long out_min, long out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


int get_stickDir(int rcVal, const char* name){
  int rv = 0;
  //const char* d[] = {"centered\n","right/up\n","left/down\n"};
  if(rcVal > deadZone) rv = 1; //up/right stick  
  if(rcVal < -deadZone) rv = -1; //down/left stick   
  //if(debug) Serial.print(name); Serial.print("="); Serial.print(rcVal); Serial.print("\t"); Serial.print(d[rv]);     
  return rv; 
}

/*
servoPos calcDiffDrive(int x, int y, bool debug = false){
	
	//input RC signal range 1000-2000 center neutral 1500 
	//for simplicity we receive normalized values here from -500 to 500, center stick = 0
	//x represents turn speed from right left stick (RC channel 1)
	//y represents forward/back speed from RC channel 2

	servoPos sp;

	//x = x - 1500; //now based at -500 to 500
	//y = y - 1500;
    
    stickDir dx = get_stickDir(x, "x");
	stickDir dy = get_stickDir(y, "y");

	int speedFwd = 0; 
	int speedTurn = 0; 

	if(dx = 0 && dy = 0){ //centered no movement
		sp.left = 0;
		sp.right = 0;
	}
	else if(dx = 0){ //pure forward back
		sp.left = y; 
		sp.right = y;
	}
	else if(dy = 0){ //pure left right
		sp.left = x; 
		sp.right = -x;
	}
	else if(dx = -1 && dy = 1){ //quadrant 1 forward left turn -250,250 output: 
		sp.left = y - x; 
		sp.right = y + x;
	}
	else if(dx = 1 && dy = 1){ //quadrant 2 forward right turn 250,250 output: 250,-250
		sp.left = y + x;
		sp.right = y - x;
	}
	else if(dx = -1 && dy = -1){ //quadrant 3 back left turn -250,-250
		sp.left = y - x;
		sp.right = y + x;
	}
	else if(dx = 1 && dy = -1){ //quadrant 4 back right turn 250,-250
		sp.left = y + x;
		sp.right = y - x;
	}


	
	
    
    

    
	if(debug){
		printf("%6d %6d %6d %6d\n", speedFwd, speedTurn, speedLeft, speedRight);
	}

	return sp;
}
*/


servoPos calcDiffDrive(int x, int y, bool debug = false){
	
	//input RC signal range 1000-2000 center neutral 1500 
	//for simplicity we receive normalized values here from -500 to 500, center stick = 0
	//x represents turn speed from right left stick (RC channel 1)
	//y represents forward/back speed from RC channel 2

	servoPos sp;

	//x = x - 1500; //now based at -500 to 500
	//y = y - 1500;
    
    stickDir dirX = get_stickDir(x, "x");
	stickDir dirY = get_stickDir(y, "y");

	int speedFwd = 0; 
	int speedTurn = 0; 

	if(dirY == 1)//forward
    {
        speedFwd = map(y, 0, 500, 0, 500);
    }
    else if(dirY == -1) //backward
    {
        speedFwd = map(y, 0, -500, -0, -500);
    }
    
    
    if(dirX == 1) //right
    {
        speedTurn = map(x, 0, 500, 0, 500);
    }
    else if(dirX == -1) //left
    {
        speedTurn = map(x, 0, -500, -0, -500);
    }

    int speedLeft = speedFwd + speedTurn;
    int speedRight = speedFwd - speedTurn;

	sp.left = constrain(speedLeft, -500, 500);
    sp.right = constrain(speedRight, -500, 500);
	
	if(debug){
		printf("%6d %6d %6d %6d\n", speedFwd, speedTurn, speedLeft, speedRight);
	}

	return sp;
}


void p(pt A, servoPos sA){
	printf("%s xy(%d,%d) = lr(%d,%d)\n", A.name, A.x, A.y, sA.left, sA.right);
}

void main(void){

	/* 
differential drive joy stick positions to hydrostatic transmission valve control by RC servo
showing normalized inputs -500 to 500   for RC joystick readings in (1000-2000, 1500 center)
showing normalized outputs -500 to 500  for RC servo position control (1000-2000, 1500 centered)
Quadrant AD = 1, AB = 2, CD = 3, CB = 4

      Y Axis
1       A       2
  E	--------- F
    |   | +I|
  D	--- + --- B    X Axis
	|   |   |
  G	--------- H
3       C       4
	
	Y = channel 2 = speed fwd/back                                
	X = channel 1 = speed turn 

	pt | description                                       | RC signal input x/y   | motor output L/R servo
	------------------------------------------------------------------------------------------------------------
	A = full forward for LR motors                             0, 500                    500, 500
	C = full reverse for LR motors                             0, -500                  -500, -500
	B = full turn R, L full forward, R motor full reverse      500, 0                    500, -500
	D = full turn L, R full forward, L full reverse           -500, 0                   -500, 500
	E = full speed forward, full-R 0-L                        -500, 500                   0, 500
	F = full forward, full-L, 0-R                              500, 500                  500, 0
	I = half speed forward, half turn                           250, 250                 250, -250            
*/

	 
	pt A = {0,500,"A"};    servoPos sA = calcDiffDrive(A.x, A.y);  p(A,sA);
	pt C = {0,-500,"C"};   servoPos sC = calcDiffDrive(C.x, C.y);  p(C,sC);
	pt B = {500,0,"B"};    servoPos sB = calcDiffDrive(B.x, B.y);  p(B,sB);
	pt D = {-500,0,"D"};   servoPos sD = calcDiffDrive(D.x, D.y);  p(D,sD);
	pt E = {-500,500,"E"}; servoPos sE = calcDiffDrive(E.x, E.y);  p(E,sE);
	pt F = {500,500,"F"};  servoPos sF = calcDiffDrive(F.x, F.y);  p(F,sF);
	 

	pt I = {250,250,"I"};  servoPos sI = calcDiffDrive(I.x, I.y,true);  p(I,sI);

	
	
	
	
	
	
	

	
	
	
	
	
	
	

	printf("\npress any key to exit...\n");
	getch();

}