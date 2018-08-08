class Cell {
  float x,y;
  float w;
  boolean change;
  int m;

  float p = 0.1;
  int vMax;
  int v;
  color colour;
  
  int state;
  int previous;
  
  Cell(float x, float y, float w, int vMax, color colour, float pFlow, int state) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.vMax = vMax;
    this.colour = colour;
    this. p = pFlow;
    change = false;
    m = 0;
    
    /*if(random(1)<p) {
      state = 1;
      v = int(random(vMax+1));
    }
    else {
      state = 0;
      v = 0;
    }*/
    this.state = state;
    if(state==1)
      v = int(random(vMax+1));
    else
      v = 0;
    previous = state;
  }
  
  void savePrevious() {
    previous = state;
  }
  
  void setState(int s) {
    state = s;
  }
  
  void display() {
    smooth();
    if(state==1) {
      //fill(0);
      //text(Boolean.toString(change),x,y);
      if(v<=vMax/3)
        fill(255,0,0);
      else if(v<=2*(vMax/3))
        fill(255,204,0);
      else
        fill(0,255,0);
      //fill(colour);
    }
    else if(state==-1)
      fill(0);
    else
      fill(120);
    //stroke(0);
    rect(x,y,w,w);
  }
  
}
