const int anaCh1 = A1;  // Analog input pin that the potentiometer is attached to
int analogValue = 0;    // value read from the pot

  void setup() {
    //Set MIDI baud rate:
    Serial.begin(9600);
  }
 
  void loop() {
    analogValue = analogRead(anaCh1);
    Serial.println(analogValue);
    delay(100);
  }
 

