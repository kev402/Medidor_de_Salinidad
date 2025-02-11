const int sensorPin = A1;  

void setup() {
  Serial.begin(9600);  
}

void loop() {
  int sensorValue = analogRead(sensorPin);  
  float voltage = sensorValue * (5.0 / 1024.0); 
  Serial.print("Voltaje: ");
  Serial.print(voltage);
  Serial.println(" V");
  if(voltage == 0.00){
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
  }else if(voltage >= 0.01 && voltage <= 2.00){
    digitalWrite(2, HIGH);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
  }else if(voltage >= 2.01 && voltage <= 4.00){
    digitalWrite(2, HIGH);
    digitalWrite(3, HIGH);
    digitalWrite(4, LOW);
  }else if(voltage >= 4.01){
    digitalWrite(2, HIGH);
    digitalWrite(3, HIGH);
    digitalWrite(4, HIGH);
  }
  delay(1000);  
  
}
