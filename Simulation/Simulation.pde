

PImage backgroundImage;
PGraphics maskImage;
int frameWidth=1000; int frameHeight=650;  //dimensions of background picture

int vehicleSize = 10;        // Width of the vehicle
float xpos, ypos;

float vehicleSpeed=10;
float vehicleHeading = 0;

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom


float rangeToWayPoint=0;
float [][] wayPoints = new float[141][2] ;  // Sets 10 way point locations - expand the size of the array when needed
float thisWayPointX;
float thisWayPointY;
int wayPointIndex=0;

float [][] chemicals = new float[frameWidth][frameHeight];
int [] maxLoc = {0, 0};

  
void setup() 
{

  size(1000, 650);
  maskImage = createGraphics(frameWidth,frameHeight);
  maskImage.beginDraw();  maskImage.background(0);  maskImage.fill(0);  maskImage.rect(0,0,frameWidth,frameHeight);  maskImage.endDraw();
  
  backgroundImage = loadImage("oceanFloor.jpeg");
  background(backgroundImage);

  noStroke();
  frameRate(30);
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  xpos = 500;
  ypos = 325;
  
  vehicleHeading=radians(10);

  //set start
  wayPoints[0][0] = 500;
  wayPoints[0][1] = 325;
  
  // set waypoints
  int scale = 1;
  int ydistance = 13;
  int xdistance = 20;
  for (int i = 1; i < wayPoints.length; i++) {
    if (i % 4 == 1) { // southeast
      wayPoints[i][0] = wayPoints[0][0] + xdistance*scale*cos((float)Math.toRadians(45));
      wayPoints[i][1] = wayPoints[0][1] + ydistance*scale*cos((float)Math.toRadians(45));
    } else if (i % 4 == 2) { // northeast
      wayPoints[i][0] = wayPoints[0][0] + xdistance*scale*cos((float)Math.toRadians(45));
      wayPoints[i][1] = wayPoints[0][1] - ydistance*scale*cos((float)Math.toRadians(45));
    } else if (i % 4 == 3) { // northwest
      wayPoints[i][0] = wayPoints[0][0] - xdistance*scale*cos((float)Math.toRadians(45));
      wayPoints[i][1] = wayPoints[0][1] - ydistance*scale*cos((float)Math.toRadians(45));
    } else { // southwest
      wayPoints[i][0] = wayPoints[0][0] - xdistance*scale*cos((float)Math.toRadians(45));
      wayPoints[i][1] = wayPoints[0][1] + ydistance*scale*cos((float)Math.toRadians(45));
      scale++;
    }
    if (wayPoints[i][0] > frameWidth) wayPoints[i][0] = frameWidth;
    if (wayPoints[i][1] > frameHeight) wayPoints[i][1] = frameHeight;
  }
  
  
  //fill chemical array
  int sign = (int)(Math.random() * 2);
  float lastVal = 100;
  for (int i = 0; i < chemicals.length; i++) {
    for (int j = 0; j < chemicals[i].length; j++) {
      if (sign == 0) {
        chemicals[i][j] = lastVal + (float)(Math.random() * 10);
      } else {
        chemicals[i][j] = lastVal - (float)(Math.random() * 10);
      }
    }
  }
  
  
  
}

void draw() 
{
  
  if (wayPointIndex >= wayPoints.length) {
    thisWayPointX = maxLoc[0];
    thisWayPointY = maxLoc[1];
  } else {
    //read location for current waypoint 
    thisWayPointX=  wayPoints[wayPointIndex][0]; 
    thisWayPointY=  wayPoints[wayPointIndex][1];
  }
    
  // make vehicle point at current waypoint       
  vehicleHeading= atan2(-(thisWayPointY - ypos), (thisWayPointX - xpos));
  xpos = xpos + ( vehicleSpeed * cos(vehicleHeading) );
  ypos = ypos + ( vehicleSpeed * sin(vehicleHeading)*-1 );//-1 on the Y axis as the vertical coordinates get bigger towards the bottom of the screen 
  if (xpos >= frameWidth) xpos = frameWidth - 1;
  if (ypos >= frameHeight) ypos = frameHeight - 1;
   
  rangeToWayPoint = sqrt(sq(thisWayPointY - ypos) + sq(thisWayPointX - xpos));
  
  //Check if vehicle is at waypoint
  if (rangeToWayPoint <= 6 && wayPointIndex < wayPoints.length - 1) {  
    wayPointIndex++;
  } 
  
  
  // check chemicals
  int x = Math.round(xpos);
  int y = Math.round(ypos);
  float chemAmount = chemicals[x][y];
  if (chemAmount > chemicals[maxLoc[0]][maxLoc[1]]) {
    maxLoc[0] = x;
    maxLoc[1] = y;
  }
  
  
  ////resolve boundaries ( so if something goes wrong with Nav we still have the robot bouncing around
  //if (xpos >= frameWidth-vehicleSize || xpos <= 0+vehicleSize ){ vehicleHeading=vehicleHeading+radians(190);}
  //if (ypos >= frameHeight-vehicleSize || ypos <= 0+vehicleSize ){ vehicleHeading=vehicleHeading+radians(190);}
  //// 
  //if (xpos >= frameWidth-vehicleSize){xpos=frameWidth-vehicleSize;} if (xpos <= 0+vehicleSize){xpos=0+vehicleSize;}
  //if (ypos >= frameHeight-vehicleSize){ypos=frameHeight-vehicleSize;} if (ypos <= 0+vehicleSize){ypos=0+vehicleSize;}
    
  //this does the map-uncovering thing
  maskImage.beginDraw();  maskImage.fill(255,150);  maskImage.noStroke();
  maskImage.ellipse(xpos, ypos, vehicleSize*2, vehicleSize*2);
  maskImage.endDraw();  maskImage.mask(backgroundImage);

  background(backgroundImage);
  image(maskImage,0,0);
  
  ////draw all waypoints in grey
  //for (int waypointPlotCounter = 0; waypointPlotCounter < wayPoints.length; waypointPlotCounter = waypointPlotCounter+1) {
  //  fill(150,150,150);
  //  ellipse(wayPoints[waypointPlotCounter][0], wayPoints[waypointPlotCounter][1] , vehicleSize/2, vehicleSize/2);
  //}
  
  //draw current waypoint
  //fill(25,25,225);
  //ellipse(thisWayPointX, thisWayPointY , vehicleSize/2, vehicleSize/2);

  //draw robot
  fill(0,225,0,200);
  ellipse(xpos, ypos, vehicleSize, vehicleSize);

  
}
