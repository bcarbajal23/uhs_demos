/*
* Draw circles randomly on the screen with different colors and stroke with
*/
void setup()
{
  size(500, 500);
}//END setup

void draw()
{
  //Pick random place to draw circle
  float randX = random(500);
  float randY = random(500);
  //Pick random R,G,B values to fill in circle and stroke color
  float c1 = random(255);
  float c2 = random(255);
  float c3 = random(255);
  
  stroke(c2,c3,c1);
  
  int num = (int)random(10); //Random number for between 0-9
  strokeWeight(num);
  fill(c1,c2, c3);
  ellipse(randX,  randY, 50,50);
}
/*size(500,500);
 
 for (int i = 0; i < 50; i++) {
 float randX = random(500); // can also use width
 float randY = random(500); // can also use height
 float c1 = random(255);
 float c2 = random(255);
 float c3 = random(255);
 
 stroke(c3,c1,c2);
 strokeWeight(i);
 
 fill(c1, c2, c3);
 ellipse(randX, randY, 50,50);
 }
 */