UTCA utca;
int t;
//int totalTime;

void setup() {
  size(1800,360);
  //totalTime = 15000;
  t = 0;
  utca = new UTCA(0.15, 5, 0, 0.3);

  /*int vMax = 5;
  float pBraking = 0.2;
  float pVehicle = 0;
  //for(vMax=1;vMax<=5;vMax+=2) {
  //for(int j=1;j<=5;j+=2) {
  for(int k=0;k<=6;k+=3) {
    for(float i=0;i<=1;i+=0.01) {
      //pBraking = j/10.0;
      pVehicle = k/10.0;
      utca = new UTCA(i, vMax, pVehicle, pBraking);
      for(int t=0;t<totalTime;t++) {
        utca.generate();
      }
      utca.printOutput(totalTime);
    }
  }
  System.out.println("Done");*/
}

void draw() {
  background(255);
  
  utca.generate();
  utca.display();
  System.out.println(t++);
  delay(200);
}
