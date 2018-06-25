float x = 400;
float y = 400;

float dx = 1;
float dy = 1;

int rows = 7; //Number of bricks per row
int columns = 7; //Number of columns
int total = rows * columns;
int score = 0;
int lives = 3;

Brick[] box = new Brick[total]; //Initialize the array that will hold all the bricks

Paddle paddle = new Paddle(); //initialize paddle (it is called paddle, b/c paddlle1 looks weird when it's typed)
Ball ball = new Ball(); //initialize ball (named ball for the same reason as above)


void setup() {
  size(600, 600);
  background(255);
  fill(0);
  textSize(32);
  
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j< columns; j++)
    {
      box[i * rows + j] = new Brick((i+1) * width/(rows + 2), (j+1) * 50); //places all the bricks into the array, properly labelled.
    }
  }
  
}

void draw() {
  background(0);
  //Draw bricks from the array of bricks
  fill(255);
  text("Score: " + Integer.toString(score), 10, 30);
  if (ball.y > height) {
    lives--;
    if (lives > 0) {
      ball.x = 300;
      ball.y = 400;
      ball.vx = 0;
      ball.vy = 4;
    } else {
      exit();
    }
  }
  for (int i = 0; i < total; i++)
  {
    box[i].update();
  }
  paddle.update();
  ball.update();
  //Ball hits left side of paddle
  if (ball.y == paddle.y && ball.x > paddle.x && ball.x <= paddle.x + (paddle.w / 2) )
  {
    ball.goLeft();
    ball.changeY();
  }

  //Ball hits right side of paddle
  if (ball.y == paddle.y && ball.x > paddle.x + (paddle.w / 2) && ball.x <= paddle.x + paddle.w )
  {
    ball.goRight();
    ball.changeY();
  }

  //If the ball hits the RIGHT wall, go in same y direction, but go left  
  if (ball.x + ball.D / 2 >= width)
  {
    ball.goLeft();
  }

  //If the ball hits the LEFT wall, go in same y direction, but go right
  if (ball.x - ball.D / 2 <= 0)
  {
    ball.goRight();
  }

  //If the ball hits the ceiling, go down in a different direction
  if (ball.y - ball.D / 2 <= 0)
  {
    ball.changeY();
  }
  
  for (int i = 0; i < total; i ++) {
    //If ball hits bottom of brick, ball moves down, increment score
    if (ball.y - ball.D / 2 <= box[i].y + box[i].h &&  ball.y - ball.D/2 >= box[i].y && ball.x >= box[i].x && ball.x <= box[i].x + box[i].w  && box[i].hit == false )
    {
      ball.changeY();
      box[i].gotHit();
      score++;
    }
    //If ball hits top of brick ball moves up, increment score
    if (ball.y + ball.D / 2 >= box[i].y && ball.y - ball.D /2 <= box[i].y + box[i].h/2 && ball.x >= box[i].x && ball.x <= box[i].x + box[i].w && box[i].hit == false ) 
    {
      ball.changeY();
      box[i].gotHit();
      score++;
    }
    if (ball.x + ball.D / 2 >= box[i].x && ball.x + ball.D / 2 <= box[i].x + box[i].w / 2 && ball.y >= box[i].y && ball.y <= box[i].y + box[i].h  && box[i].hit == false)
    {
      ball.goLeft();
      box[i].gotHit();
      score++;
    }
    
    //if ball hits the right of the brick, ball switches to the left, and moves in same direction, increment score
    if (ball.x - ball.D/2 <= box[i].x + box[i].w && ball.x +ball.D / 2 >= box[i].x + box[i].w / 2 && ball.y >= box[i].y && ball.y <= box[i].y + box[i].h  && box[i].hit == false)
    {
      ball.goRight();
      box[i].gotHit();
      score++;
    }
  }
}