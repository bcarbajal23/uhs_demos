/*************************************************************************
 * Arthor: Brian Carlos Carbajal
 * In collaboration with Steven Eiselen
 * Date:   03/29/2017
 *
 * Description: This program is an implementation of Conway's Game of Life.
 *      The user can interact with the GUI. They can pause the game, add 
 *      live cells, and kill cells. They can clear the whole board and 
 *      and reset the board.
 *                              
 ************************************************************************/

/******* Globals for GUI setup ******/
int screenTall = 600;
int screenWide = 1200;
int cellSize  = 20;
int cellsWide = screenWide/cellSize;
int cellsTall = screenTall/cellSize;

//Utility stuff for frame rate and pausing game
boolean paused = true;
int minFR = 2;
int maxFR = 60;
int curFR = 60;

/***** WORLD MAP ******/
GOLWorld myWorld;

void settings() {
  size(screenWide, screenTall);
}

void setup() {
  ellipseMode(CORNER);
  frameRate(curFR);
  myWorld = new GOLWorld();
  displayMenu();
}

void draw() {
  // UI CALLS
  if (mousePressed) {
    mouseDraw(mouseButton);
  }
  // LOGIC CALLS
  if (paused) {
    myWorld.advanceWorld();
  }
  // RENDER CALLS
  background(180);
  myWorld.displayWorld();
}
/******************************************************************
 * Class: GOLWorld
 * 
 * Purpose:
 *         Map layout for Game of Life. Moves each agent and determines
 *         if they are dead or alive. Color of the map and the colore
 *         of alive agents are also determined. 
 * 
 * 
 ************************************************************/
class GOLWorld {
  int current[][];
  int nextMap[][];

  public GOLWorld() {
    current = new int[cellsTall][cellsWide];
    nextMap = new int[cellsTall][cellsWide];    
    randomPopulate();
  } // Ends Constructor

  /********************************************************
   *   Method: randomPopulate
   *    
   *   Purpose: Randomily generate the cells on the map.
   *            Either dead or live agents
   *   Return: Nothing
   *
   *********************************************************/
  void randomPopulate() {
    for (int r=0; r<cellsTall; r++) {
      for (int c=0; c<cellsWide; c++) {
        current[r][c] = int(random(2));
      }
    }
  } //END randomPopulate

  /********************************************************
   *   Method: resetWorld
   *    
   *   Purpose: Reset the map to nothing. Clears all live 
   *            agents from the map.
   *   Return: Nothing
   *
   *********************************************************/
  void resetWorld() {
    for (int r=0; r<cellsTall; r++) {
      for (int c=0; c<cellsWide; c++) {
        current[r][c] = 0;
        nextMap[r][c] = 0;
      }
    }
  } //END randomPopulate 


  /********************************************************
   *   Method: randomPopulate
   *    
   *   Purpose: Randomily generate the cells on the map.
   *            Either dead or live agents
   *   Return: Nothing
   *
   *********************************************************/
  void displayWorld() {
    for (int r=0; r<cellsTall; r++) {
      for (int c=0; c<cellsWide; c++) {
        if (current[r][c]==0) {
          fill(255, 60, 0);
        } else if (current[r][c]==1) {
          fill(0, 60, 255);
        } else {
          fill(252, 0, 0);
        }      
        ellipse(c*cellSize, r*cellSize, cellSize, cellSize);
      }
    }
  } //END displayWorld


  /********************************************************
   *   Method: advanceWorld
   *    
   *   Purpose: Moves agents along the map. The 4 laws of
   *            Conway's Game of Life are implemented. Agents
   *            are either kept alive, killed, or spawned 
   *            off rulles
   *   Return: Nothing
   * https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules
   *********************************************************/
  void advanceWorld() {
    int NC;
    for (int r=0; r<cellsTall; r++) {
      for (int c=0; c<cellsWide; c++) {
        NC = getAdjTotal(r, c);
        // Conditions for if this cell is alive
        if (current[r][c] == 1) {
          if (NC==2 || NC==3) {
            nextMap[r][c]=1;
          } else {
            nextMap[r][c]=0;
          }
        } else {// Conditions for if this cell is dead (Because is XOR to root condition in co-conditional
          if (NC==3) {
            nextMap[r][c]=1;
          } else {
            nextMap[r][c]=0;
          }
        }
      }//End off inner loop
    }//End off outer loop

    //Loop advances the agents fromt eh current map to the next map.
    for (int r=0; r<cellsTall; r++) {
      for (int c=0; c<cellsWide; c++) {
        current[r][c] = nextMap[r][c];
      }
    }
  }//END advanceWorld

  /********************************************************
   *   Method: getAdjTotal
   *    
   *   Purpose: Determines the number of adjacent live neighbors
   *            for the corresponding live cell.
   *   Return: tot - The total number of live neighbors
   *
   *********************************************************/
  int getAdjTotal(int cRow, int cCol) {
    int tot = 0;
    for (int adjR = cRow-1; adjR <= cRow+1; adjR++) {
      for (int adjC = cCol-1; adjC <= cCol+1; adjC++) {
        if (checkInBounds(adjR, adjC)) {
          if (!(adjC==cCol && adjR==cRow)) {
            tot += current[adjR][adjC];
          }
        }
      }
    }
    return tot;
  } // Ends Function getAdjTotal
}//END GOLWorld Class


/********************************************************
 *   Method: keyPressed
 *    
 *   Purpose: Function handles the interaction with the
 *            user. 
 *   Return: Nothing
 *
 *********************************************************/
void keyPressed() {
  if (key == 'p') {
    paused=!paused;
  }
  if (key == 'g') {
    myWorld.randomPopulate();
  }
  if (key == 'r') {
    myWorld.resetWorld();
  }
  if(key == 'h'){
    displayMenu();
  }
  if (keyCode == UP   && curFR < maxFR) {
    curFR++; 
    frameRate(curFR); 
    println("Current Frame Rate: " + curFR);
  }
  if (keyCode == DOWN && curFR > minFR) {
    curFR--; 
    frameRate(curFR); 
    println("Current Frame Rate: " +curFR);
  }
}//END keyPressed

/********************************************************
 *   Method: mouseDraw
 *    
 *   Purpose: Spawn agent alive if left mouse button is pressed.
 *            Kill agent if right mouse button is pressed.
 *            Can hold down either button without release
 *            to kill or spawn.
 *   Return: Nothing
 *
 *********************************************************/
void mouseDraw(int button) {
  int mRow = int(mouseY/cellSize);
  int mCol = int(mouseX/cellSize);
  if (button == RIGHT) {
    myWorld.current[mRow][mCol]=0;
  }
  if (button == LEFT ) {
    myWorld.current[mRow][mCol]=1;
  }
}//END mouseDraw

/********************************************************
 *   Method: checkInBounds
 *    
 *   Purpose: CHecks to see if an agent is within the bounds
 *            of the grid.
 *   Return: Boolean
 *
 *********************************************************/
boolean checkInBounds(int r, int c) {
  return (r>=0 && r<cellsTall && c>=0 && c<cellsWide);
} // END checkValidCell

/********************************************************
 *   Method: displayMenu
 *    
 *   Purpose: Displays the keyboard and mouse options for
 *            the user.
 *   Return: Nothing
 *
 *********************************************************/
void displayMenu() {
  println("Press these keys to interact with window.");
  println("p: Pauses the game/window.");
  println("r: Resets the map to empty.");
  println("g: New game.");
  println("h: Display help menu.");
  println("Up Arrow: Increase frame rate");
  println("Down Arrow: Decrease from rate");
  println("Left Mouse: generate new agents when game is paused.");
  println("Right Mouse: kill agents when game is paused.");
  println('\n');
}//END displayMenud
