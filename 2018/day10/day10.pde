String[] lines;
int[][] pointsAndVelocities = new int[342][4];

int minX = 0;
int minY = 0;
int maxX = 0;
int maxY = 0;
int min = 0;
int max = 0;

int t = 10581;
int speed = 1;

void calculateBoundaries(int m1, int m2) {
    if (m1 > maxX) {
      maxX = m1;
    }
    
    if (m2 > maxY) {
      maxY = m2;
    }
    
    if (m1 < minX) {
      minX = m1;
    }
    
    if (m2 < minY) {
      minY = m2;
    }
    
    min = min(minX, minY);
    max = max(maxX, maxY);
}

void setup() {
  frameRate(30);
  size(2000, 1000);
  background(0);
  stroke(255);
  frameRate(12);
  lines = loadStrings("input.txt");
  //lines = loadStrings("example.txt");
  
  for (int index = 0; index < lines.length; index = index+1) {
    String[] m = match(lines[index], "position=<(?<x>.+),(?<y>.+)> velocity=<(?<vx>.+),(?<vy>.+)>");
    //println(m[4]);
    pointsAndVelocities[index][0] = Integer.parseInt(trim(m[1]));
    pointsAndVelocities[index][1] = Integer.parseInt(trim(m[2]));
    pointsAndVelocities[index][2] = Integer.parseInt(trim(m[3]));
    pointsAndVelocities[index][3] = Integer.parseInt(trim(m[4]));
    
    calculateBoundaries(Integer.parseInt(trim(m[1])), Integer.parseInt(trim(m[2])));
    
  }
  println(minX +"_" + maxX + ":" + minY + "_" + maxY);
  println(min +"_" + max);
  println(pointsAndVelocities[0]);
}

void draw() {
  if (t == 10682) {
    return;
  }
  clear();

  for (int index = 0; index < lines.length; index = index+1) {
    
    int[] point = pointsAndVelocities[index]; 

    int x = int(map(float(int(point[0]) + int(point[2] * t)), min, max, 0, width));
    int y = int(map(float(int(point[1]) + int(point[3] * t)), min, max, 0, height));
    
    ellipse(x, y, 8, 8);
    
  }
  
    minX = 2147483647;
    minY = 2147483647;
    maxX = -2147483647;
    maxY = -2147483647;
    min = 2147483647;
    max = -2147483647;
  for (int index = 0; index < lines.length; index = index+1) {
    int[] point = pointsAndVelocities[index]; 
    int x = int(point[0]) + int(point[2] * t);
    int y = int(point[1]) + int(point[3] * t);
      

    calculateBoundaries(x, y);
  }
  
  speed = max(1, speed - 1);
  t += speed;
  
  println(t);
  //delay(1000);
}
