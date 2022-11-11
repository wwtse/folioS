
#include <util/atomic.h>
#include <PID_v1.h>

#define potpin A0
#define pwmEnablepin 6
#define driverIn1pin 10
#define driverIn2pin 9
#define motorOutApin 3 // yellow 
#define motorOutBpin 2 // white


//motorPar
double J = 0.018256, b = 0.168599, kt = 1.595349, kb = 1.56749, R = 1.746171, L = 0;

unsigned long prevT = 0;
int posPrev = 0;
double uOPrev = 0;

double rpmOPrev = 0;
volatile int posi = 0;
volatile double veli = 0;

double rpm = 10;
double u = 0;
double e = 0;

//PID parameter
double rpmD = 10;
double kp = .2, ki = 3, kd = 0;
long eintegral = 0;


PID myPID(&rpm, &u, &rpmD, kp, ki, kd, DIRECT);

void setup() {
  Serial.begin(9600);
  pinMode(potpin, INPUT); // Potentiometer
  pinMode(motorOutApin, INPUT); // yellow
  pinMode(motorOutBpin, INPUT); // white
  pinMode(driverIn1pin, OUTPUT); //1Y
  pinMode(driverIn2pin, OUTPUT); //2Y
  pinMode(pwmEnablepin, OUTPUT); // pwmEnable
  //pinMode(treading, INPUT); //test
  
  myPID.SetMode(AUTOMATIC);
  myPID.SetSampleTime(0.05);
  myPID.SetOutputLimits(-50,50);
  attachInterrupt(digitalPinToInterrupt(motorOutApin), readEncoder, RISING);
  
}

void loop() {
  // calc vel and pos
  int pos = 0;
  double vel = 0;

  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
    pos = posi;
    vel = veli;
  }

  volatile unsigned long currT = millis();
  double deltaT = ((double) (currT - prevT)) / 1.0e3;
  if (isnan(deltaT) || deltaT<0.0001){
    deltaT = 10;
  }
  vel = (pos - posPrev) / deltaT;
  rpm = (double)(vel * 60 / 12 / 171.79);

  rpmD = 33*((sin(currT/1e3)>-0.5))-13 ;
  e = rpmD - rpm; //rpm desired
  if (isnan(e)){
    //Serial.println(isnan(e));
    //Serial.println("ok");
    e = 0;
  }
  myPID.Compute();
  double u_dot = (double)((u - uOPrev) / deltaT);
  
  double currV =3* 2*PI*(u * (R * b + kb * kt) + u_dot * R * J)/(kt * 60);
  //double currV =(u*3.77 + u_dot*1)/(18.64);
  int dir = 1;
  if (u < 0) {
    dir = -1;
  }
  if (currV > 6) {
    currV = 6;
  }
  int z = abs(map(currV, 0, 6, 0, 255));
  if (z > 255) {
    z = 255;
  }

//  Serial.print("rpmD:");
//  Serial.print(rpmD);
//  Serial.print(",");
  Serial.print("rpm:");
  Serial.print(rpm);
  Serial.print(",");
  Serial.print("e:");
  Serial.print(e);
  Serial.print(",");
//  Serial.print("u:");
//  Serial.print(u);
//  Serial.print(",");
  Serial.print("rpmD:");
  Serial.println(rpmD);
//  Serial.print(",");
//  Serial.print("eintegral:");
//  Serial.print(eintegral);
//  Serial.print(",");

//  Serial.print("currV:");
//  Serial.print(currV);
//  Serial.print(",");
//  Serial.print("deltaT:");
//  Serial.print(deltaT);
//  Serial.print(",");
//  Serial.print("u_dot:");
//  Serial.print(u_dot);
//  Serial.print(",");
//  Serial.print("z:");
//  Serial.println(z);

  //Serial.print(u_dot);
  //Serial.print("\t");


  posPrev = pos;
  prevT = currT;
  uOPrev = u;
  //delay(20);
  runMotorAll(dir, z);
}


void runMotorAll(int dir, int z) {
  analogWrite(pwmEnablepin, z);
  if (dir == 1) {
    digitalWrite(driverIn1pin, HIGH);
    digitalWrite(driverIn2pin, LOW);
  }
  else if (dir == -1) {
    digitalWrite(driverIn1pin, LOW);
    digitalWrite(driverIn2pin, HIGH);
  }
  else {
    digitalWrite(driverIn1pin, LOW);
    digitalWrite(driverIn2pin, LOW);
  }
}


void readEncoder() {
  int motorOutB = digitalRead(motorOutBpin);
  //A lead B for CW
  if (motorOutB < 1) {
    posi++;
  }
  else {
    posi--;
  }
}
