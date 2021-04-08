import processing.serial.*;


private GraphsDisplay graphsDisplay;
private Display3D display3D;  
private StatesDisplay statesDisplay;
private MapDisplay mapDisplay;

// we store the values coming from the arduino inside of this file
PrintWriter valuesFile;
String valuesFileName = "values.txt";

void setup() {
  
  
  size(1200, 800, P3D);
  
  
  // Arduino setup
  String portName = Serial.list()[0]; // might need to change the number depending on the computer
  new Serial(this, portName, 9600).bufferUntil(ENTER); // reads until a line change (ENTER)
 
  graphsDisplay = new  GraphsDisplay(this);
  display3D = new Display3D(this, 0,400,400, 400);
  statesDisplay = new StatesDisplay();
  mapDisplay = new MapDisplay(1000,600,400,400);
  
  // we create the file
  valuesFile = createWriter(valuesFileName);
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
     display3D.draw();
     statesDisplay.draw();  
     mapDisplay.draw();
  }
  
 

 

  

  
  
 
 }
 
 
 
 float currentTime, previousTime;
 public void update(){
   
   //TO add random values 
   currentTime = millis();
   if(currentTime - previousTime > 100){
       currentTime /= 1000.0;
      
       previousTime = millis();
       graphsDisplay.addValue(0, "0", new PVector(currentTime, random(10,30 + currentTime)));
   }  
  
   
 }
 
 
 // separator used with the arduino
 public static final String SEPARATOR = ",";


 // we use those string to know the component type
 public static final int TEMP_COMPONENT = 0,
                        STRAIN_COMPONENT = 1,
                        ACC_COMPONENT = 2;                                          
                       
 // This string is used to indentify messages with values from the arduino.
 // 0,0 corresponds to the first layer of the first plot (Temperature plot)
 String VALUES_MSG = "0,0";
 
 // This corresponds to the number of attributes sent with each value from the arduino
 int relevantValues = 4;
 
 
 
 
 
 // code that receives message from the arduino
 void serialEvent(final Serial s){
  
  // We recover a string that comes from the arduino
  String val = s.readString();
 
  // check the length the prevent error from the susbtring method
  if(val.length() > 3){
    if(val.substring(0,3).contentEquals(VALUES_MSG)){
      
      // We write the message in the values.txt file
      valuesFile.println(val);
      valuesFile.flush();
      
      // We split it into an array of floats (because many different values).
      float[] values = float(split(val,SEPARATOR));
      
    
        for (int i = 0; i < (values.length)/ relevantValues; i++){
          // we recover all the four values
          int plotIndex = int(values[i * relevantValues]);
          String layerIndex = str(int(values[i * relevantValues + 1]));
          float value = values[i * relevantValues + 2 ];
          float newTime = values[i * relevantValues +3 ] / 1000.0;
          
          // we calculate the temperature which is previously in analog if we are dealing with a temperature sensor
          if(plotIndex == TEMP_COMPONENT){
            value = calculateTemp(value);        
          
          // what actualy adds the code on a plot
          graphsDisplay.addValue(plotIndex, layerIndex, new PVector(newTime, value)); 
        }
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
