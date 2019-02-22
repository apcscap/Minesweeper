import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
static public int NUM_ROWS = 20;
static public int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of mineqeeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  
  // make the manager
  Interactive.make( this );
    
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int rr=0;rr<NUM_ROWS;rr++) {
    for(int cc=0;cc<NUM_COLS;cc++) {
      buttons[rr][cc] = new MSButton(rr, cc);
    }
  }
  setBombs();
}
public void setBombs()
{
    bombs = new ArrayList<MSButton>();
    for(int i=0;i<50;i++) {
      int randRR = int(random(0, 20));
      int randCC = int(random(0, 20));
      if(!bombs.contains(buttons[randRR][randCC])) {
        bombs.add(buttons[randRR][randCC]);
      }
      println(randRR + " " + randCC);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int clicked = 0;
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        if(!bombs.contains(buttons[r][c]) && buttons[r][c].clicked == true) {
          clicked += 1;
        }
      }
    }
    if(clicked == NUM_ROWS*NUM_COLS-bombs.size()) {
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i=0;i<bombs.size();i++) {
      bombs.get(i).clicked = true;
    }
    String[] word = new String[] {"Y", "o", "u", " ", "L", "o", "s", "e"};
    int r = (int) random(0, 20);
    int c = (int) random(0, 20 - word.length);
    for(int i=0;i<word.length;i++) {
      buttons[r][c+i].setLabel(word[i]);
    }
}
public void displayWinningMessage()
{
    String[] word = new String[] {"Y", "o", "u", " ", "W", "i", "n"};
    int r = (int) random(0, 20);
    int c = (int) random(0, 20 - word.length);
    for(int i=0;i<word.length;i++) {
      buttons[r][c+i].setLabel(word[i]);
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          marked = !marked;
          if(marked == false)
            clicked = false;
        } else if(bombs.contains(this)) {
          displayLosingMessage();
        } else if(countBombs(r, c) > 0) {
          setLabel(""+countBombs(r,c));
        } else {
          for(int row=0;row<3;row++) {
            //Checking top buttons
            if(isValid(r-1+row, c+1) && buttons[r-1+row][c+1].clicked == false) {
              buttons[r-1+row][c+1].mousePressed();
            }
            //Checking bottom buttons
            if(isValid(r-1+row, c-1) && buttons[r-1+row][c-1].clicked == false) {
              buttons[r-1+row][c-1].mousePressed();
            }
          }
          //Checking buttons to the left and right
          if(isValid(r-1, c) && buttons[r-1][c].clicked == false) {
            buttons[r-1][c].mousePressed();
          }
          if(isValid(r+1, c) && buttons[r+1][c].clicked == false) {
            buttons[r+1][c].mousePressed();
          }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < NUM_ROWS && c < NUM_ROWS && r >= 0 && c >= 0) {
          return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i=-1;i<2;i++)
          for(int j=-1;j<2;j++)
            if(i==0 && j==0) continue;
            else if(isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
              numBombs += 1;
        return numBombs;
    }
}