// PID libary from http://playground.arduino.cc/Code/PIDLibrary
#include <PID_v1.h>

// The pins for hridge
uint8_t pin1 = 9;
uint8_t pin2 = 10;

// Prototypes 
int read_line(char*, int);

// PID variables
double input = 0;
double output = 0;
double setpoint = 0;

// The PID object. 
PID pid(&input, &output, &setpoint,1.0,0.0,0.0, DIRECT);  // Inital tunings: Kp = 1, Ki = 0, Kd = 0, DIRECT control.

unsigned long last = 0;        // Used for when to send measured angle
boolean measuring = 0;         // If true, send measured angle
boolean sendTunings = false;   // If true, pid tunings are sent to receiver one time
uint8_t sendIndex = 0;         // Helping variable for sending pid tunings.. 

// Upper and lower limit of potmeter range. 
const int lowerLimit = 320;
const int upperLimit = 630;


// Setup routine
void setup(){
  Serial.begin(38400);
  
  pinMode(pin1,OUTPUT);
  pinMode(pin2,OUTPUT);
  
  // Set PWM frequency at H bridge
  TCCR1B = TCCR1B & 0b11111000 | 0x01;
  
  pid.SetMode(AUTOMATIC);            // Set PID to active. 
  pid.SetOutputLimits(-95,95);       // Limits 
  pid.SetSampleTime(50);             // Sampletime of pid: 50ms
  setpoint = lowerLimit;             // Set init position of the machine. 
}

// Loop routine
void loop(){
  
  //If there is serial data to read. 
  if(Serial.available()){
    char buf[4];
    double p = pid.GetKp();
    double i = pid.GetKi();
    double d = pid.GetKd();
    
    if(read_line(buf,sizeof(buf)) != 0){
      switch(buf[0]){
       case 'p': p=parseDouble(buf[1],buf[2]); break;                              // Two byte PID parameters
       case 'i': i=parseDouble(buf[1],buf[2]); break;
       case 'd': d=parseDouble(buf[1],buf[2]); break;
       //case 's': setpoint = (double)parseUint16(buf[1],buf[2]); break;             // Two byte setpoint (uint16_t). Used for debug. 
       case 's': setpoint = (double)calc_setpoint_from_byte(buf[1]); break;
       case 'c': pid.SetMode(buf[1]==1); break;                                    // Turn on/off
       case 'r': sendTunings = true;             // Send all parameters to software
       case 'm': measuring = (buf[1] == 1);      // Send measured value from this device to computer
       case 'l': analogWrite(11,buf[1]);         // One byte PWM output on pin 11. For testing the ballfeeder. 
      }
    }
    pid.SetTunings(p,i,d);        // Update the pid tunings.
  }
  
  // If tunings is requested... Because of slow receiver... Send in three differnet loops. 
  if(sendTunings){
    switch(sendIndex++){
     case 0: sendData('p',pid.GetKp()); break;
     case 1: sendData('i',pid.GetKi()); break;
     case 2: sendData('d',pid.GetKd()); break; 
    }
   if(sendIndex==3){ 
     sendIndex = 0;
     sendTunings = false; 
   }
  }
  
  // Do pid stuff
  input = analogRead(A0);
  pid.Compute();
  
  // If the pid is active, calculate the correct output
  // Else, stop motor. 
  if(pid.GetMode() == AUTOMATIC) calc_output(output);
  else calc_output(0);
  
  // Send position every 80ms. Only if the user activate it (measuring)
   if(millis() - last > 80 && measuring){
      sendData('v',input);
      last = millis();
  }
}

// Scale the setpoint byte (0-255) to actual range of the tilt. 
// Warning: Not very robust.. 
int calc_setpoint_from_byte(uint8_t val){
  return lowerLimit + round(val*1.2156);
}

// Calculate pwm output for hbridge. 
// 160 is a meaured value :)
void calc_output(int val){  
  if(val > 0){
    analogWrite(pin1,0);
    analogWrite(pin2,160+val);
  }else if(val < 0){
    val*=-1;
    analogWrite(pin2,0);
    analogWrite(pin1,160+val);
  }else{
    analogWrite(pin1,0); 
    analogWrite(pin2,0);
  }
}

