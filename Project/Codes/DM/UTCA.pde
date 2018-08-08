import java.util.Collections;
import java.util.HashSet;

class UTCA {
  
  int numLane = 3;
  int numCells = 13333;
  int vMax = 5;
  int vMax2 = 2;
  float pVehicle = 0.1;
  int w = 20;
  int h = height/numLane;
  int columns, rows;
  float p;
  float pChange = 0.85;
  int t;
  float pFlow;
  int numVeh;
  int passedVeh;
  int flownVeh;
  int changeVeh;
  
  int blockStart = 0;
  int blockEnd = 5000;
  int blockX = 25;
  int blockY = 1;
  
  int gap = 2;
  int lineWidth = 5;
  int roadWidth = numLane*(w+2*gap) + (numLane-1)*lineWidth;
  
  Cell[][] board;
  
  UTCA(float p, int vMax, float pVehicle, float pBrake) {
    columns = numCells;
    rows = numLane;
    columns = width/w;
    board = new Cell[columns][rows];
    t = 0;
    this.pFlow = p;
    numVeh = 0;
    passedVeh = 0;
    flownVeh = 0;
    changeVeh = 0;
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
    
    for(int i=0;i<rows;i++) {
      if(board[0][i].state==1)
        passedVeh++;
    }
  }
  
  void generate() {
    
    if(t>=blockStart && t<=blockEnd)
      board[blockX][blockY].state = -1;
    else if(t==blockEnd+1)
      board[blockX][blockY].state = 0;
    
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        board[i][j].savePrevious();
      }
    }
    
    for(int i=0;i<columns;i++) {
      for(int j=0;j<rows;j++) {
        if(board[i][j].previous==1) {
          int v = board[i][j].v;
          int x = -1;
          for(int k=1;k<columns;k++) {
            if(board[(i+k)%columns][j].previous!=0) {
              x = k;
              break;
            }
          }
          boolean change = false;
          if(x==-1 || x>v+1) {
            if(v<board[i][j].vMax)
              board[i][j].v++;
          }
          else {
            if(j==1) {
              for(int m=-1;m<=1;m+=2) {
                if(board[i][(j+m)%rows].previous==0) {
                  int y = -1;
                  for(int k=1;k<columns;k++) {
                    if(board[(i+k)%columns][(j+m)%rows].previous!=0) {
                      y = k;
                      break;
                    }
                  }
                  if(y==-1 || y>x) {
                    int yBack = -1;
                    for(int k=1;k<columns;k++) {
                      if(board[(i-k+columns)%columns][(j+m)%2].previous!=0) {
                        yBack = k;
                        break;
                      }
                    }
                    if(yBack==-1 || yBack>board[i][j].vMax) {
                      if(random(1)<pChange) {
                        board[i][j].change = true;
                        change = true;
                        board[i][j].m = m;
                        break;
                      }
                    }
                  }
                }
              }
            }
            else {
              int m = 1-j;
              if(board[i][(j+m)%rows].previous==0) {
                int y = -1;
                for(int k=1;k<columns;k++) {
                  if(board[(i+k)%columns][(j+m)%rows].previous!=0) {
                    y = k;
                    break;
                  }
                }
                if(y==-1 || y>x) {
                  int yBack = -1;
                  for(int k=1;k<columns;k++) {
                    if(board[(i-k+columns)%columns][(j+m)%2].previous!=0) {
                      yBack = k;
                      break;
                    }
                  }
                  if(yBack==-1 || yBack>board[i][j].vMax) {
                    if(random(1)<pChange) {
                      board[i][j].change = true;
                      board[i][j].m = m;
                      change = true;
                    }
                  }
                }
              }
            }
            if(!change) {
              board[i][j].v = x-1;
              if(random(1)<p && board[i][j].v>0) {
                board[i][j].v--;
            }
          }
          
          }
        }
      }
    }
    
    for(int x=0;x<columns;x++) {
      for(int y=0;y<rows;y++) {  
        
        if(board[x][y].previous==1) {
          if(board[x][y].change) {
            changeVeh++;
            board[x][y].setState(0);
            int m = board[x][y].m;
            int next = (y+m)%rows;
            board[x][next].setState(1);
            board[x][next].v = board[x][y].v;
            board[x][next].vMax = board[x][y].vMax;
            board[x][next].colour = board[x][y].colour;
            board[x][y].change = false;
            board[x][y].m = 0;
            //System.out.println(y + " to " + (y+m));
          }
          else {
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
    
    if(t%5==0) {
      for(int x=0;x<columns;x++) {
        for(int y=0;y<rows;y++) {
          if(board[x][y].state==1)
            flownVeh += board[x][y].v;
        }
      }
    }
    t++;
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
    
    System.out.println(t);
    
  }
  
  void printOutput(int time) {
    float density = numVeh/(float)(numLane*columns);
    float flow = passedVeh/(float)(time);
    float systemFlow = flownVeh/(float)(time*numCells);
    float laneChange = changeVeh/(float)(time*numCells);
    System.out.println(pFlow + " " + density + " " + systemFlow + " " + laneChange);
  }
  
}
