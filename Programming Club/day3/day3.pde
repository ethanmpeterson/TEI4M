int x = 5;
int y = 400;

float dx = 1;
float dy = 1;

float ballWidth = 10;
float ballHeight = 10;

void setup() {
 size(1000, 1000);
 background(255);
 fill(0);
 textSize(100);
}

void draw() {
 background(255);
 float r = random(0, 255);
 float g = random(0, 255);
 float b = random(0, 255);
 fill(r, g, b);
 ellipse(x, y, ballWidth, ballHeight);
 y += dy;
 x += dx;
 if (x >= width - ballWidth) { // right boundary
   dx *= -1;
 } else if (x <= 0) {
   dx *= -1;
 } else if (y >= height) {
   dy *= -1;
 } else if (y <= 0) {
   dy *= -1;
 }
 
}