import java.util.Collections;
import java.util.HashSet;

class UTCA {
  
  int numLane = 1;
  int vMax = 5;
  int vMax2 = 2;
  float pVehicle = 0.3;
  int w = 20;
  int h = height/numLane;
  int columns, rows;
  float p = 0.2;
  float pFlow;
  int numVeh;
  int passedVeh;
  
  int gap = 2;
  int lineWidth = 5;
  int roadWidth = numLane*(w+2*gap) + (numLane-1)*lineWidth;
  
  Cell[][] board;
  
  UTCA(float p, int vMax, float pVehicle, float pBrake) {
    columns = width/w;
    rows = height/h;
    board = new Cell[columns][rows];
    this.pFlow = p;
    numVeh = 0;
    passedVeh = 0;
    this.vMax = vMax;
    this.pVehicle = pVehicle;
    this.p = pBrake;
    init();
  }
  
  void init() {
    int num = int(pFlow*(columns*numLane));
    ArrayList<Integer> list = new ArrayList<Integer>();
    for (int i=0; i<columns*numLane; i++) {
        list.add(new Integer(i));
    }
    Collections.shuffle(list);
    HashSet<Integer> hs = new HashSet<Integer>();
    HashSet<Integer> hs2 = new HashSet<Integer>();
    for (int i=0; i<num; i++) {
      if(i<num*pVehicle)
        hs2.add(list.get(i));
      else
        hs.add(list.get(i));
    }
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        int state = 0;
        if(hs.contains(i*rows+j))
          state = 1;
        if(state==1)
          board[i][j] = new Cell(i*w, height/2 + gap + j*(w+lineWidth+2*gap) , w, vMax, color(int(random(256)), int(random(256)), int(random(256))), pFlow, state);
        else {
          if(hs2.contains(i*rows+j))
            state = 1;
          board[i][j] = new Cell(i*w, height/2 + gap + j*(w+lineWidth+2*gap) , w, vMax2, color(int(random(256)), int(random(256)), int(random(256))), pFlow, state);
        }
        if(board[i][j].state==1)
          numVeh++;
      }
    }
    if(board[0][0].state==1)
      passedVeh++;
  }
  
  void generate() {
    
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        board[i][j].savePrevious();
      }
    }
    
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        int v = board[i][j].v;
        int x = -1;
        for(int k=1;k<columns;k++) {
          if(board[(i+k)%columns][j].previous==1) {
            x = k;
            break;
          }
        }
        if(x==-1 || x>v+1) {
          if(v<board[i][j].vMax)
            board[i][j].v++;
        }
        else {
          board[i][j].v = x-1;
        }
        if(random(1)<p && board[i][j].v>0) {
          board[i][j].v--;
        }
      }
    }
    
    for(int x=0;x<columns;x++) {
      for(int y=0;y<rows;y++) {
        //Open System
        
        /*if(x>columns-6) {
          board[x][y].setState(0);
        }
        else if(x==0 && board[x][y].previous==0 && random(1)<0.5) {
          board[x][y].setState(1);
          board[x][y].v = 0;
        }
        else if(board[x][y].previous==1) {
          board[x][y].setState(0);
          int v = board[x][y].v;
          if(x+v<columns) {
            board[x+v][y].setState(1);
            board[x+v][y].v = v;
          }
        }*/
        
        //Closed System
        
        if(board[x][y].previous==1) {
          board[x][y].setState(0);
          int v = board[x][y].v;
          int next = (x+v)%columns;
          if(next<x)
            passedVeh++;
          board[next][y].setState(1);
          board[next][y].v = v;
          board[next][y].vMax = board[x][y].vMax;
          board[next][y].colour = board[x][y].colour;
        }
      }
    }
    
  }
  
  void display() {
    
    fill(120);
    noStroke();
     
    //road
    rect(0, height/2, width, roadWidth);
    
    fill(240,240,0); //yellow line
    for(int i=0;i<numLane-1;i++)
      rect(0,height/2 + w+2*gap + i*(2*gap+w+lineWidth),width,lineWidth); //left
    
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        board[i][j].display();
      }
    }
    
  }
  
  void printOutput(int t) {
    float density = numVeh/(float)(numLane*columns);
    float flow = passedVeh/(float)(t);
    System.out.println(pFlow + " " + density + " " + flow);
  }
  
}
