#include <Servo.h>

Servo myServo;
int lastPos = 1250;
int straightLeftEdge = 1200, straightRightEdge = 1800;
int incomingByte = 100; // ascii for d
//char state;

void setup() {
  myServo.attach(2);
  Serial.begin(9600);
}

void loop() {
  //x for stop, s for straight
  //l for left, r for right
  while (Serial.available() > 0) {
    incomingByte = Serial.read();
  }

  if (incomingByte == 'x') {
    myServo.writeMicroseconds(1500);
  }
  if (incomingByte == 's') {
    straight();
  }
  if (incomingByte == 'l') {
    left();
  }
  if (incomingByte == 'r') {
    right();
  }
  if (incomingByte == 'd') {
    demonstration();
  }
}



void demonstration() {
  int i = 0;
  while (i < 20) {
    straight();
    i++;
  }
  delay(1000);
  i = 0;
  while (i < 20) {
    right();
    i++;
  }
  delay(1000);
  i = 0;
  while (i < 20) {
    left();
    i++;
  }
  delay(2000);
}

void straight() {
  if (lastPos == straightLeftEdge) {
    myServo.writeMicroseconds(straightRightEdge);
    lastPos = straightRightEdge;
  } else {
    myServo.writeMicroseconds(straightLeftEdge);
    lastPos = straightLeftEdge;
  }
  delay(200);
}

void left() {
  if (lastPos == straightLeftEdge || lastPos == straightRightEdge || lastPos == 1000) {
    myServo.writeMicroseconds(1500);
    lastPos = 1500;
  } else {
    myServo.writeMicroseconds(1000);
    lastPos = 1000;
  }
  delay(200);
}

void right() {
  if (lastPos == straightLeftEdge || lastPos == straightRightEdge || lastPos == 2000) {
    myServo.writeMicroseconds(1500);
    lastPos = 1500;
  } else {
    myServo.writeMicroseconds(2000);
    lastPos = 2000;
  }
  delay(200);
}
