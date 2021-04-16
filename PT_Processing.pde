import processing.serial.*;


private SetupDisplay setupDisplay;
public GraphsDisplay graphsDisplay;
public RocketDisplay rocketDisplay;  
public StatesDisplay statesDisplay;
public MapDisplay mapDisplay;


public static final String SEPARATOR = ",";

// we use those string to know from which value it comes. 
public static final int TEMP_COMPONENT = 0,
                        STRAIN_COMPONENT = 1,
                        ACC_COMPONENT = 2;

// used for data calculation and treatment
static float factor = 5.0/1024.0;
static float HT = 150.0, LT = -50.0;


// Used to connect to arduino and fix problems
public Serial port;
int relevantValues = 4;
int numberOfValues = 6;
long addedValues = 0;
int parasiteValues = numberOfValues * 7 + 1;


// Used to Save inside txt file on computer
PrintWriter file;
String filename = "values.txt";



color backgroundColor = color(230,242,255);




void setup() {
   size(1200, 800, P3D);
   
   setupDisplay = new SetupDisplay(this);
   graphsDisplay = new  GraphsDisplay(this);
   rocketDisplay = new RocketDisplay(this);
   statesDisplay = new StatesDisplay();
   mapDisplay = new MapDisplay(1000,600,400,400);
 
  
   file = createWriter(filename);
   
  
 

 
 
}


void draw(){
  
  
  
  
  // we draw the live dispay
  if(setupDisplay.finished){
    update();
  
    // Draws the background and the lines
    if(!graphsDisplay.priority){
       background(backgroundColor);
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
       rocketDisplay.draw();
       statesDisplay.draw();  
       mapDisplay.draw();
    }
  }
  // we draw the settings (for the app)
  else{
      setupDisplay.draw();
    
  }}public void update(){
   
   
   if(port.available() > 0){
     readDataFromArduino();
   }
   
   
  
  
 }
 
 void readDataFromArduino(){
   // We recover the String which contains all values
  String val = port.readStringUntil('\n');
  
  if(val == null) return;
  
  // We split it into an array of floats (because many different values).
  float[] values = float(split(val,SEPARATOR));
  // We check if values has the right length (problems can occur when code just launched)
  int goodNumberOfValues = relevantValues * numberOfValues;
  

  
  
  
  if(values.length == goodNumberOfValues){
    
    if(values[0] == 0 && values[1] == 0){
        for (int i = 0; i < numberOfValues; i++){
          float plotIndex = int(values[i * relevantValues]);
          float layerIndex = int(values[i * relevantValues + 1]);
          float value = values[i * relevantValues + 2 ];
          float newTime = values[i * relevantValues + 3 ] / 1000.0;
        
          if(plotIndex == TEMP_COMPONENT){
           value = calculateTemp(value);
          }
          
          // make sure no parasite values
          addedValues++;
          if(addedValues >= parasiteValues){
              if(addedValues == parasiteValues){
                statesDisplay.remoteConnectionState.switchState();
              }
              graphsDisplay.addValue((int)plotIndex, str((int)layerIndex), new PVector(newTime, value));
              file.println(val);
              file.flush();
          }
        }  
     }
   }  
 }
 
  public void openPort(int portNumber){
     println(portNumber);
     String portName = Serial.list()[portNumber];
     println(portName);
     port = new Serial(this, portName, 9600);
     port.bufferUntil('\n');
  }


void mousePressed(){
  setupDisplay.mousePressed();
  mapDisplay.mousePressed();
  statesDisplay.mousePressed();

}

void mouseReleased(){
  graphsDisplay.mouseReleased();
}

void keyPressed(){
  graphsDisplay.keyPressed();
}


float calculateTemp(float portValue){
  return portValue * factor * (HT - LT)  + LT;
}

public int sign(int nbr){
  return nbr >= 0 ? 1: -1;
}

public boolean mouseOver(int x, int y, int dx, int dy){
  return mouseX > x && mouseX < x + dx && mouseY >y && mouseY < y + dy;
}
