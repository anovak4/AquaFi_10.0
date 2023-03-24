#include <Servo.h>

Servo myServo;
int lastPos = 1000;

void setup() {
  myServo.attach(8);
}

void loop() {
  if (lastPos == 1000) {
    myServo.writeMicroseconds(2000);
    lastPos = 2000;
  } else {
    myServo.writeMicroseconds(1000);
    lastPos = 1000;
  }
  delay(1000); // 1 seconds
}
