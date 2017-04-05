float theta = radians(15); //Angle for splitting branch
//Set up canvas
void setup() {
  size(1200, 800);
  background(0);
}

void draw()
{
  stroke(255);
  //Start at the bottom of the window
  translate(width / 2, height);
  float start = 200;
  line(0, 0, 0, -start);
  translate(0, -start);
  
  frameRate(10);
  drawBranch(start);

  //drawBranch(150);
  //drawBranch(100);
}//END draw

void drawBranch(float len)
{
  if (len > 2) {
    len *= 0.75;
    pushMatrix();
    rotate(theta);
    line(0, 0, 0, -len);

    translate(0, -len);
    drawBranch(len);
    popMatrix();
    pushMatrix();
    rotate(-theta);

    line(0, 0, 0, -len);
    translate(0, -len);
    drawBranch(len);
    popMatrix();
  }
}//END drawBranch