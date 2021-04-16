import controlP5.*;
  

class SetupDisplay{

  
    private PApplet parent;
    public boolean finished;
    
 
    ControlP5 cp5;
    Textfield textfield;
    
    
    int sizeX = 300;
    int sizeY = 100;
    int x, y, dx ,dy;
   
       
    PFont font = createFont("arial", 30);
    
    PrintWriter saveFile;
    String savefile = "save.txt";
    String[] lines;

    public SetupDisplay(PApplet parent){
      
       cp5 = new ControlP5(parent);

   
       textfield=cp5.addTextfield("");
       textfield.setSize(sizeX, sizeY)
           .setPosition(width/2 - sizeX / 2, height/2 - sizeY )
           .setFont(font)
           .setColor(color(255))
           .setColorCursor(color(255))
           .setAutoClear(false)
           .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
           
       x = width/2 - sizeX/2;
       y = height/2 + sizeY/2;
       dx = sizeX;
       dy = sizeY;
       
       lines = loadStrings(savefile);
       if(lines != null){
          if(lines.length > 0){
           // First line is Skip Step
            boolean skipStep = lines[0].contentEquals("1");
            if(skipStep){
              exitSetup(lines[1]);
            }
          }
      } 
    }
    
    public void draw(){
      
      textAlign(CENTER, CENTER);
      textFont(font);
      
      fill(0);
      text("Choose Port Number", width/2  , height / 2 -  2 * sizeY );
      
      fill(180,80,80);
      if(mouseOver(x, y , dx ,dy)) fill(250,100,100);
      rect(x, y, dx ,dy);
     
      fill(255);
      text("Confirm", x + dx / 2, y + dy / 2);
     
    }
    
  
    
      void mousePressed(){
        if(mouseOver(x, y ,dx ,dy)){
          String text = textfield.getText();
          if(text.contentEquals("")) {
               println("type a value");
              return;
          }else{
            if(isStringInteger(text)){
                exitSetup(text);
            }else{
              println("Is Not Integer");
            }
           
          }
           
        }
    }
    
    
     void exitSetup(String port){
          int newPort = Integer.parseInt(port);
          if(newPort >= Serial.list().length){
            return;
          }
         
         
      
          saveFile= createWriter(savefile);
          
          if(lines == null) saveFile.println("0");
          else saveFile.println(lines[0]);
          saveFile.println(port);
          saveFile.flush();
          saveFile.close();
       
       
      
         
         openPort(newPort);
         cp5.dispose();
         finished = true;
         textAlign(BASELINE, BASELINE);
     }
 
    
    
     boolean isStringInteger(String str) {
      return str.matches("-?[0-9]+");
    
     }
    
  
    
    

}
