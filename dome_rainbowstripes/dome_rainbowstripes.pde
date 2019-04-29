//
// This code maps the LEDs for the Delta School LED Dome
// You can draw whatever you want inside the draw function
// and it will show up on the lights
// 
//

// Fadecandy server
OPC opc;

float scale = 0.7;

// Array to hold information about the number of LEDs in a triangle (used in the mapping)
int[][] equiCounts;

// Variables to hold information about triangle positions
float theCX;
float theCY;
float theX;
float theY;
float isoSize = 65;

float speed = 3;

Rectangle[] rectangles;

void setup() {
  // Canvas size
  size(1000, 660);
  
  colorMode(HSB, 100);

  // Initialising this array
  equiCounts = new int[2][12];  

  // Fadecandy index of first pixel on each side of an equilateral triangle
  equiCounts[0][0] = 0;
  equiCounts[0][1] = 20;
  equiCounts[0][2] = 40;

  // Number of LEDs on each side of the triangle
  equiCounts[1][0] = 20;
  equiCounts[1][1] = 20;
  equiCounts[1][2] = 20;


  // Connect to the fcserver. 
  opc = new OPC(this, "127.0.0.1", 7890);
  
  
  // IMPORTANT!
  // Change this to "false" if you use low opacity background for fading, 
  // or the LEDS will flash
  opc.showLocations(true);

  
  // This next whole bit is the LED mapping
  
  //void ledIsosceles(int fadecandy, int triangle, float x, float y, float angle)
  // index: start of the triangle on fadecandy
  // x: centre of pentagon
  // y: centre of pentagon
  // angle: angle of triangle from top to base, in degrees to avoid destroying my brain
  // type: there are different ways the led strip is arranged around a triangle, like,
  // does the long side come first or last? 

  // bottom left pentagon
  opc.ledIsosceles(1, 3, 385, 620, 90, 0);      // A3
  opc.ledIsosceles(1, 2, 385, 620, 162, 0);     // A2
  opc.ledIsosceles(1, 6, 385, 620, 234, 3);     // A6
  opc.ledIsosceles(1, 5, 385, 620, 306, 3);     // A5
  opc.ledIsosceles(1, 4, 385, 620, 18, 0);      // A4

  opc.ledIsosceles(1, 8, 185, 685, 342, 1);  // A8

  // top left pentagon
  opc.ledIsosceles(2, 4, 480, 305, 90, 0);      // B4
  opc.ledIsosceles(2, 3, 480, 305, 162, 0);     // B3 
  opc.ledIsosceles(2, 2, 480, 305, 234, 0);     // B2
  opc.ledIsosceles(2, 6, 480, 305, 306, 3);     // B6
  opc.ledIsosceles(2, 5, 480, 305, 18, 4);      // B5 

  opc.ledIsosceles(2, 1, 360, 135, 54, 1);     // B1


  // top right pentagon
  opc.ledIsosceles(3, 5, 802, 305, 90, 3);      // C5
  opc.ledIsosceles(3, 4, 802, 305, 162, 0);     // C4
  opc.ledIsosceles(3, 3, 802, 305, 234, 0);     // C3
  opc.ledIsosceles(3, 2, 802, 305, 306, 0);     // C2
  opc.ledIsosceles(3, 6, 802, 305, 18, 3);      // C6  

  opc.ledIsosceles(3, 1, 925, 135, 126, 8);     // C1

  // bottom right pentagon
  opc.ledIsosceles(4, 6, 902, 620, 90, 3);      // D6
  opc.ledIsosceles(4, 5, 902, 620, 162, 3);     // D5
  opc.ledIsosceles(4, 4, 902, 620, 234, 0);     // D4
  opc.ledIsosceles(4, 3, 902, 620, 306, 0);     // D3
  opc.ledIsosceles(4, 2, 902, 620, 18, 6);      // D2 
  
  opc.ledIsosceles(4, 1, 1105, 685, 198, 1);      // D1

  // centre lower pentagon
  opc.ledIsosceles(5, 2, 641, 808, 90, 9);   // E2
  opc.ledIsosceles(5, 6, 641, 808, 163, 7);  // E6
  opc.ledIsosceles(5, 5, 641, 808, 234, 8);  // E5
  opc.ledIsosceles(5, 4, 641, 808, 306, 1);  // E4
  opc.ledIsosceles(5, 3, 641, 808, 18, 3);   // E3  


  //void ledEquilateral(int index, float x, float y, float angle){
  // index: start of the triangle on fadecandy
  // x: centre of pentagon
  // y: centre of pentagon
  // angle: angle of triangle from centre to base, in degrees to avoid destroying my brain
  // side 1 is base, clockwise from there.
  // type: there are different ways the led strip is arranged around a triangle

  // top trio
  opc.ledEquilateral(2, 7, 641, 183, 270, 8); // B7
  opc.ledEquilateral(6, 2, 641, 347, 90, 5);  // F2  
  opc.ledEquilateral(2, 8, 641, 87, 90, 3);  // B8

  // top right trio
  opc.ledEquilateral(3, 7, 956, 420, 342, 4); // C7 
  opc.ledEquilateral(6, 3, 813, 470, 162, 5);  // F3  
  opc.ledEquilateral(3, 8, 1050, 385, 162, 5);  // C8 

  // top left trio
  opc.ledEquilateral(1, 7, 330, 420, 198, 4); // A7
  opc.ledEquilateral(6, 1, 470, 470, 18, 4);  // F1
  opc.ledEquilateral(1, 1, 233, 385, 18, 5);  // A1  

  // bottom left trio 
  opc.ledEquilateral(5, 1, 543, 681, 185, 6); // E1
  opc.ledEquilateral(5, 7, 460, 800, 5, 0);   // E7
  opc.ledEquilateral(5, 8, 400, 880, 185, 4); // E8  

  // bottom right trio
  opc.ledEquilateral(6, 4, 740, 681, 355, 4);  // F4
  opc.ledEquilateral(4, 7, 823, 800, 175, 5);  // D7
  opc.ledEquilateral(4, 8, 883, 880, 355, 7);  // D8
  
  rectangles = new Rectangle[12];
  for (int i=0; i<12; i++){
    rectangles[i] = new Rectangle(i*100, 100/12*i);
  }
}

void draw() {
  
  // This gives a full opacity black background.
  // If you want to change it for a low opacity background, 
  // you must also scroll up to where it says "important" and change the
  // location display of the pixels to false, or they will flash
  background(0);
  
  for (int i=0; i<12; i++){
    rectangles[i].update();
    rectangles[i].display();
  }
  
}
