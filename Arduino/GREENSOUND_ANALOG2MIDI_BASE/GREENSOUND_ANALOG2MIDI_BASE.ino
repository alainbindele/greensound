#include <SoftwareSerial.h>
 
// Variables:
byte note = 0;  // The MIDI note value to be played
const int anaCh1 = A1;  // Analog input pin that the potentiometer is attached to
const int anaCh2 = A2;  // Analog input pin that the potentiometer is attached to
const int anaCh1Pitch = A3;  // Analog input pin that the potentiometer is attached to
const int anaCh1Velocity = A4;  // Analog input pin that the potentiometer is attached to
const int anaCh2Pitch = A5;  // Analog input pin that the potentiometer is attached to
const int anaCh2Velocity = A6;  // Analog input pin that the potentiometer is attached to
const int midiOutRX = 2;
const int midiOutTX = 3;
int analogValue = 0;         // value read from the pot
int i=0,samples=10;
int computed=0,audio=0,mean=0;

//software serial instantiate midiSerial object
SoftwareSerial midiSerial(midiOutRX, midiOutTX); // digital pins that we'll use for soft serial RX & TX

  void setup() {
    //  Set MIDI baud rate:
    Serial.begin(9600);
    midiSerial.begin(31250);
  }
 
  void loop() {
    // play notes from F#-0 (30 - 46.24Hz) to F#-5 (90 - 1479Hz):
    for (i = 0; i < samples; i ++) {
      analogValue = analogRead(anaCh1);
      mean+=analogValue;
      //analogWrite(audioOut,analogValue*0.45);
      //Serial.print("\n analog: ");
      //Serial.print(analogValue-100);
      //Serial.print((String)", mean: "+computed);
      //play notes from F#-0 (30 - 46.24Hz) to F#-5 (90 - 1479Hz):
      //Serial.print(", note: ");
      //Serial.print(note);  
    }
    computed = mean/samples;
    note = map(computed, 1, 1024, 30, 90);
    audio = map (note, 30, 90, 300, 600);
    //analogWrite(audioOut,computed);
    //Note on channel 1 (0x90), some note value (note), middle velocity (0x45):
    noteOn(0x90, note, 0x45);
    //Note on channel 1 (0x90), some note value (note), silent velocity (0x00):
    noteOn(0x90, note, 0x00);
    mean=0;
  }
 
  //  plays a MIDI note.  Doesn't check to see that
  //  cmd is greater than 127, or that data values are  less than 127:
  void noteOn(byte cmd, byte data1, byte data2) {
    midiSerial.write(cmd);
    midiSerial.write(data1);
    midiSerial.write(data2);
 
    //prints the values in the serial monitor so we can see what note we're playing
    Serial.print("cmd:");
    Serial.print(cmd);
    Serial.print(",data1:");
    Serial.print(data1);
    Serial.print(",data2:");
    Serial.print(data2);
    Serial.println("");  
  }
