#include <SoftwareSerial.h>

int sensorPin0 = A0;    // select the input pin for the potentiometer
int sensorPin1 = A1;    // select the input pin for the potentiometer
int sensorPin2 = A2;    // select the input pin for the potentiometer
int sensorPin3 = A3;    // select the input pin for the potentiometer
int sensorPin4 = A4;    // select the input pin for the potentiometer
int sensorPin5 = A5;    // select the input pin for the potentiometer
int sensorPin6 = A6;    // select the input pin for the potentiometer
int sensorPin7 = A7;    // select the input pin for the potentiometer
SoftwareSerial mySerial(0,1); // RX, TX
int sensorValue0 = 0;  // variable to store the value coming from the sensor
int sensorValue1 = 0;  // variable to store the value coming from the sensor
int sensorValue2 = 0;  // variable to store the value coming from the sensor
int sensorValue3 = 0;  // variable to store the value coming from the sensor
int sensorValue4 = 0;  // variable to store the value coming from the sensor
int sensorValue5 = 0;  // variable to store the value coming from the sensor
int sensorValue6 = 0;  // variable to store the value coming from the sensor
int sensorValue7 = 0;  // variable to store the value coming from the sensor
String toSend;
int outputPin = 0;
int readVal = 0;
void setup() {
  //initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  mySerial.begin(9600);
  mySerial.println("Hello, world?");
}

void loop() {
  // read the value from the sensor:
  sensorValue0 = analogRead(sensorPin0);
  sensorValue1 = analogRead(sensorPin1);
  sensorValue2 = analogRead(sensorPin2);
  sensorValue3 = analogRead(sensorPin3);
  sensorValue4 = analogRead(sensorPin4);
  sensorValue5 = analogRead(sensorPin5);
  sensorValue6 = analogRead(sensorPin6);
  sensorValue7 = analogRead(sensorPin7);
  delay(10);
  toSend+=sensorValue0;
  toSend+=" ";
  toSend+=sensorValue1;
  toSend+=" ";
  toSend+=sensorValue2;
  toSend+=" ";
  toSend+=sensorValue3;
  toSend+=" ";
  toSend+=sensorValue4;
  toSend+=" ";
  toSend+=sensorValue5;
  toSend+=" ";
  toSend+=sensorValue6;
  toSend+=" ";
  toSend+=sensorValue7;
  toSend+="\n";
  mySerial.println(toSend);
  delay(100);
  Serial.println(toSend);
  delay(100);
}
