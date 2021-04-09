import processing.serial.*;



private GraphsDisplay graphsDisplay;
private BarCharts barCharts;  
private StatesDisplay statesDisplay;
private MapDisplay mapDisplay;



String val;
public float[][] newValues;
public boolean addNewValues = false;


PrintWriter file;
String filename = "values.txt";

public static final String SEPARATOR = ",";


// we use those string to know from which value it comes. 
public static final int TEMP_COMPONENT = 0,
                        STRAIN_COMPONENT = 1,
                        ACC_COMPONENT = 2;

void setup() {
  size(1200, 800);
 
  // Arduino setup
  String portName = Serial.list()[1];
  new Serial(this, portName, 9600).bufferUntil(ENTER);
  
  graphsDisplay = new  GraphsDisplay(this);
  barCharts = new BarCharts(this);
  statesDisplay = new StatesDisplay();
  mapDisplay = new MapDisplay(1000,600,400,400);
  
  val = "";
  file = createWriter(filename);
  
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
 
 
 
 float currentTime, previousTime;
 
 public void update(){
   
  /* we add the values onto the graphs
   we do this in the update look to avoid asynchronous problems inside of the serialEvent method
   DO NOT do this inside of the serialEvent method --> (drawing problems) !!!  */
   if(addNewValues){
     for(int i = 0; i < newValues.length; i ++){
       graphsDisplay.addValue((int)newValues[i][0], str((int)newValues[i][1]), new PVector(newValues[i][3], newValues[i][2])); 
     }  
     addNewValues = false;
   }
   
   // Save values inside a txt file (will be used on excel afterwards)
   if(!val.contentEquals("")){ 
      file.println(val);
      file.flush();
   }
   val = "";
  
   
   /*
   //TO add random values 
   currentTime = millis();
   if(currentTime - previousTime > 500){
       currentTime /= 1000.0;
       
       graphsDisplay.addValue(0, "0", new PVector(currentTime, random(10,30) + currentTime));
       
       previousTime = millis();
   }  
   
   */
   
   
  
 }
 
 
// SHARED OR USED WITH THE ARDUINO TO RECOVER DATA
int relevantValues = 4;
String VAL = "VAL";

 
 void serialEvent(final Serial s){
   
  // We recover the String which contains all values
  val = s.readString();
  
  // we check the first 3 letters to know the command
  if(val.length() >= 3){
    // we recover the command which is stored in the first 3 letters
    String cmd = val.substring(0,3);
    
    // If it contains values from the arduino
    if(cmd.contentEquals(VAL)){
      val = val.substring(3);
      // We split it into an array of floats (because many different values).
      float[] values = float(split(val,SEPARATOR));
      
      // to avoid problems with the drawing (because asynchronous)
      if(!addNewValues){
        int numberOfValues = values.length / relevantValues;
        newValues = new float[numberOfValues][relevantValues];
        
        for (int i = 0; i < numberOfValues; i++){
          float plotIndex = int(values[i * relevantValues]);
          float layerIndex = int(values[i * relevantValues + 1]);
          float value = values[i * relevantValues + 2 ];
          float newTime = values[i * relevantValues + 3 ] / 1000.0;
          
          if(plotIndex == TEMP_COMPONENT){
            value = calculateTemp(value);
          }
          
          newValues[i][0] = plotIndex;
          newValues[i][1] = layerIndex;
          newValues[i][2] = value;
          newValues[i][3] = newTime;         
        }
         addNewValues = true;
      }    
      
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
