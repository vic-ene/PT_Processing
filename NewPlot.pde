import processing.serial.*;



private GraphsDisplay graphsDisplay;
private BarCharts barCharts;  
private StatesDisplay statesDisplay;
private MapDisplay mapDisplay;





public static final String SEPARATOR = ",";


// we use those string to know from which value it comes. 
public static final int TEMP_COMPONENT = 0,
                        STRAIN_COMPONENT = 1,
                        ACC_COMPONENT = 2;

void setup() {
  size(1200, 800);
 
  // Arduino setup
  String portName = Serial.list()[0];
  new Serial(this, portName, 9600).bufferUntil(ENTER);
  
  graphsDisplay = new  GraphsDisplay(this);
  barCharts = new BarCharts(this);
  statesDisplay = new StatesDisplay();
  mapDisplay = new MapDisplay(1000,600,400,400);
  
}


void draw(){
  
  update();
  
  // Draws the background and the lines
  if(!graphsDisplay.priority){
     background(255);
     fill(0);
     line(width/3,0,width/3,height);
     line(2 * width/3,0, 2 * width/3,height);
     line(0,height/2,width,height/2);
  }
 
 
  // if we made a plot fullscreen we will only draw it
  if(graphsDisplay.priority){
     graphsDisplay.draw();
  }
  else{
     graphsDisplay.draw();
     barCharts.draw();
     statesDisplay.draw();  
     mapDisplay.draw();
  }
  
 
 
  
  
 
 }
 
 
 
 long currentTime, previousTime;
 public void update(){
   
  
   //TO add random values 
   currentTime = millis();
   if(currentTime - previousTime > 1000){
     
       
       previousTime = millis();
   }  
 }
 
 
 void serialEvent(final Serial s){
   
  
  // We recover the String which contains all values
  String val = s.readString();
 
  // We split it into an array of floats (because many different values).
  float[] values = float(split(val,SEPARATOR));
  
  // This corresponds to the number of attributes sent with each value
  int relevantValues = 4;
  
  if(values[0] == 0 && values[1] == 0 ){
    for (int i = 0; i < (values.length)/ relevantValues; i++){
      int plotIndex = int(values[i * relevantValues]);
      String layerIndex = str(int(values[i * relevantValues + 1]));
      float value = values[i * relevantValues + 2 ];
      float newTime = values[i * relevantValues +3 ] / 1000.0;
      
     // println(str(plotIndex) + ", "  + layerIndex + " " + str(value) + " " + str(newTime));
      
      if(plotIndex == TEMP_COMPONENT){
        value = calculateTemp(value);
      }
      
      graphsDisplay.addValue(plotIndex, layerIndex, new PVector(newTime, value)); 
      }
  }
 
  
}



void mousePressed(){
  graphsDisplay.mousePressed();
  mapDisplay.mousePressed();
  statesDisplay.mousePressed();
}

void mouseReleased(){
  graphsDisplay.mouseReleased();
}

void keyPressed(){
  graphsDisplay.keyPressed();
}





float factor = 5.0/1024.0;
float HT = 150.0, LT = -50.0;

float calculateTemp(float portValue){
  return portValue * factor * (HT - LT)  + LT;
}


float calculateStrain(float portValue1, float portValue2){
  return portValue1 + portValue2; 
}


public float[] convertStringArrayToFloat(String[] stringArray){
  float[] floatArray = new float[stringArray.length];
  for(int i = 0; i < floatArray.length; i ++){
    floatArray[i] = float(stringArray[i]);
  }
  return floatArray; 
}

public int sign(int nbr){
  return nbr >= 0 ? 1: -1;
}

public boolean mouseOver(int x, int y, int dx, int dy){
  return mouseX > x && mouseX < x + dx && mouseY >y && mouseY < y + dy;
}

public GPoint generateRandomPoint(float lowerY, float upperY){
  return new GPoint(millis() / 1000.0, random(lowerY, upperY));
}
