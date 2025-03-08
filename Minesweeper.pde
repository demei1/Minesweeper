import de.bezier.guido.*;
private int NUM_ROWS = 16;
private int NUM_COLS = 16;
private int NUM_MINES = NUM_ROWS*2;
private boolean isLost = false;
private MSButton[][] buttons = new MSButton [NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
     size(400, 400);
    textAlign(CENTER,CENTER);
    strokeWeight(2);
    stroke(50);
    
    // make the manager
    Interactive.make( this );
    //your code to initialize buttons goes here
    for ( int r = 0; r < NUM_ROWS; r++){
      for ( int c = 0 ; c < NUM_COLS; c ++){
        buttons [r][c] = new MSButton(r,c);
        
      }
    
    }
    
    for ( int i = 0 ; i < NUM_MINES ; i++){
    setMines();
    }
}
public void setMines()
{
    //your code
    int randomR = (int)(Math.random()*NUM_ROWS);
    int randomC = (int)(Math.random()*NUM_COLS);
    if (mines.contains(buttons[randomR ][randomC]) || buttons[randomR][randomC].clicked)
      setMines();
    else
      mines.add(buttons[randomR ][randomC]);
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r = 0; r < buttons.length; r++)
      for (int c = 0; c <buttons[r].length; c++)
        if (!mines.contains(buttons[r][c])&&buttons[r][c].clicked == false)
            return false;
    return true;
}
public void displayLosingMessage()
{
    //your code here
     String[] arr = {"Y", "o", "u", " ", "L", "o", "s", "t", "!"};

  for (int k = 0; k < arr.length; k++) {
    if (k < NUM_COLS) {
      buttons[0][k].setLabel(arr[k]);
      buttons[0][k].clicked = true; 
    }
  }
    
}
public void displayWinningMessage()
{
    //your code here
    String[] arr = {"Y", "o", "u", " ", "W", "o", "n", "!"};

    for (int k = 0; k < arr.length; k++) {
    if (k < NUM_COLS) {
      buttons[0][k].setLabel(arr[k]);
      buttons[0][k].clicked = true; 
    }
  }
}
public boolean isValid(int r, int c)
{
    //your code here
    if ( r>= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
    return true;
  }  else
    return false;
}



public int countMines(int row, int col) {
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && !(r == row && c == col) && mines.contains(buttons[r][c])) {
                numMines++;
            }
        }
    }
    return numMines;
}




public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

 public void mousePressed () 
{
    if (!isLost)
      {
      clicked = true;
        if (mouseButton == RIGHT)
        {
          clicked = !clicked;
          if (this.clicked == false)
            flagged = !flagged;   
          
        }
        else if (mines.contains(this))
          displayLosingMessage();
        else if (countMines(myRow, myCol) > 0)
          myLabel = countMines(myRow, myCol)+"";
        else  
        {
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    if (i == 0 && j == 0) {
                        continue;
                    }

                    if (isValid(myRow + i, myCol + j)) {
                        if (!buttons[myRow + i][myCol + j].flagged && !buttons[myRow + i][myCol + j].clicked) {
                            buttons[myRow + i][myCol + j].mousePressed();
                        }
                    }
                }
            }
        }
    }
}
   public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
        {
          if (!isWon())
            fill(255,0,0);
           else fill(#FFE5B4);
        }
              
        else if(clicked)
            fill (100);

        else 
            fill (#55A03F);

        rect(x, y, width, height);
        fill(#23395d);
        textSize(20);
        text(myLabel,x+width/2,y+height/2);

    }
    public void setLabel(String newLabel)
    {
       
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
