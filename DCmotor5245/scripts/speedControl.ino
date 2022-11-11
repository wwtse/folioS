
#include <util/atomic.h>
#include <PID_v1.h>

#define potpin A0
#define pwmEnablepin 6
#define driverIn1pin 10
#define driverIn2pin 9
#define motorOutApin 3 // yellow 
#define motorOutBpin 2 // white

#define treading A5 //justreading

//motorPara
float J=0.018256, b=0.168599, kt=1.595349, kb=1.56749, R=1.746171,L =0;

unsigned long prevT = 0;
int posPrev = 0;
float rpmOPrev = 0;

volatile float posi = 0;
volatile float veli = 0;

float rpm = 0;


void setup() {
  Serial.begin(9600);
  pinMode(potpin, INPUT); // Potentiometer
  pinMode(motorOutApin,INPUT); // yellow
  pinMode(motorOutBpin,INPUT); // white
  
  pinMode(driverIn1pin, OUTPUT); //1Y
  pinMode(driverIn2pin, OUTPUT); //2Y
  pinMode(pwmEnablepin, OUTPUT); // pwmEnable

  //pinMode(treading, INPUT); //test
  
  attachInterrupt(digitalPinToInterrupt(motorOutApin),readEncoder,RISING);
}

void loop(){
 
  runMotorCW();
  //tread();

  int s = analogRead(potpin);
  //Serial.print("pot reding:");
  //Serial.print(s);
  // calc vel and pos
  int pos = 0;
  float vel = 0;
  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
    pos = posi;
    vel = veli;
  }
  volatile unsigned long currT = millis();
  float deltaT = ((float) (currT-prevT))/1.0e3;
  vel = (pos - posPrev)/deltaT;
  rpm = (float)(vel * 60 /12/171.79);
  float rpm_dot = (double)((rpm - rpmOPrev)/deltaT);

  
  //Serial.print("pos:");
  Serial.print(rpm_dot);
  Serial.print(",");
  //Serial.print("rpm:");
  Serial.println(rpm);
  Serial.println(deltaT);
  posPrev = pos;
  prevT = currT;
  double rpmOPrev = rpm;
}

void runMotorCW() {
  int s = analogRead(potpin);
  int motorOutA = digitalRead(motorOutApin);
  int motorOutB = digitalRead(motorOutBpin);
  
  // 1A only
  digitalWrite(driverIn1pin, HIGH); 
  digitalWrite(driverIn2pin, LOW);
  
  //int z = map(s,0,1023,0,255); //10bit -> duty cycle
  analogWrite(pwmEnablepin,z);

  Serial.print(z);
  Serial.print(",");
}



void readEncoder(){
  int motorOutB = digitalRead(motorOutBpin);
  //A lead B for CW
  if(motorOutB <1){
    posi++;
  }
  else{
    posi--;
  }
}


void tread(){
  int rread = analogRead(treading);
  Serial.println(rread);

}
