/*
 * This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

      This software is a stub that uses USB and MIDI connector to make communicate
      arduino with mixer and live performance softwares like Ableton etc.

 * Creator: Alain Bindele <alain.bindele@gmail.com>
 * Site: greensound.pc-go.it
 * Instangram: greensoundproject
*/

#include <MIDI.h>
MIDI_CREATE_DEFAULT_INSTANCE();
#define LED 2
// Variables:
byte note = 0;  // The MIDI note value to be played
const int anaChSens = A0;     // Sensitivity control
const int anaChPitch = A1;    // Pitch control
const int anaChVelocity = A2; // Velocity control
const int anaChDelay = A3;    // Delay control
const int anaChSustain = A4;  // Sustain control
const int anaCh1IN = A5;      // Plant CH1
const int anaCh2IN = A6;      // Plant CH1

int samples_interval=2048;
int analogValue = 0;         // value read from the pot
int ch1sens=0,ch1p=0,ch1v=0,ch1s=0,ch1d=0;
int i=0,samples=50;
int computed=0,meanSum=0;

void setup() {
  // put your setup code here, to run once:
  //  Set MIDI baud rate:
    Serial.begin(115200); // use if using with ATmega328 (uno, mega, nano...)
    pinMode(LED, OUTPUT);
}

void loop() {
  meanSum=0;
  // put your main code here, to run repeatedly:
  for (i = 0; i < samples; i ++){
      analogValue = analogRead(anaCh1IN);
      meanSum += analogValue;
  }
  computed = meanSum/samples;
  ch1sens = analogRead(anaChSens);
  if(computed<ch1sens)return;
  
  ch1p = analogRead(anaChPitch);
  ch1v = analogRead(anaChVelocity);
  ch1d = analogRead(anaChDelay);
  ch1s = analogRead(anaChSustain);
  
  
  note = map(computed, 1, 1024, 30, 90);
  ch1p = map(ch1p,1,1024,0,128);
  ch1v = map(ch1v, 1, 1024, 50, 127);
  ch1v*=10;
  ch1s = map(ch1s, 1, 1024, 200, 2000);
  
  MIDI.sendNoteOn(note+ch1p, ch1v, 1); // note, velocity, channel
  digitalWrite(LED, HIGH);
  delay(ch1s);
  MIDI.sendNoteOff(note+ch1p, ch1v, 1); // note, velocity, channel
  digitalWrite(LED, LOW);
  delay(ch1d);
  
  
/*
  Serial.print("Computed:");
  Serial.print(computed);
  Serial.print(",Sensitivity:");
  Serial.print(ch1sens);
  Serial.print(",Pitch:");
  Serial.print(ch1p);
  Serial.print(",Velocity:");
  Serial.print(ch1v);
  Serial.print(",Delay:");
  Serial.print(ch1d);
  Serial.print(",Sustainn:");
  Serial.print(ch1s);
  Serial.println(""); 
*/
}
