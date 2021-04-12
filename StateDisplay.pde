
public class StatesDisplay{
  public StateDisplay parachuteState, remoteConnectionState, damageState;
   
  ArrayList<StateDisplay> statesDisplay; 
   
    
  public StatesDisplay(){
    int yb = 375, xb = 460, offsetY1 = 75;
    int ys = 75, xs = 230;
    int size = 50;
    parachuteState = new StateDisplay(xb, yb  + offsetY1 + ys * 1,size,size);
    parachuteState.setStates("Parachute Deployed: NO", "Parachute Deployed: YES");
    remoteConnectionState = new StateDisplay(xb, yb + offsetY1 + ys * 2,size,size);
    remoteConnectionState.setStates("No Data Transmission", "Data Transimission: ON" );
    //remoteConnectionState.setColor(color(0,150,150), color(150,0,150));
    damageState = new StateDisplay(xb, yb + offsetY1 + ys * 3, size,size);
    damageState.setStates("Damage Detected","Structural Problems: NONE");
    //damageState.setColor(color(0,0,255),color(255,125,0));
    
    statesDisplay = new ArrayList<StateDisplay>();
    statesDisplay.add(parachuteState);
    statesDisplay.add(remoteConnectionState);
    statesDisplay.add(damageState);
    
    
    for(int i = 0; i < 5; i ++){
      StateDisplay newStateDisplay = new StateDisplay(xb + xs ,yb + ys * (i + 1), size ,size);
      newStateDisplay.setStates("CH" +  str(i) + " :OFF", "CH" + str(i) + " :ON");
      statesDisplay.add(newStateDisplay);
    }
    
    
  
  } 
  
  
  public void draw(){
    for(int i = 0; i < statesDisplay.size(); i ++){
       statesDisplay.get(i).draw();
    }
    

  }
  
  void mousePressed(){
   for(int i = 0; i < statesDisplay.size(); i ++){
       statesDisplay.get(i).mousePressed();
    }
  }
  
}


 class StateDisplay{
  

  public int x,y, dx, dy;
  public boolean activated;
  public String state1, state2;
  public color color1 = color(255,0,0), color2 = color(0,255,0);
  public int textSpace = 20, fontSize = 10;
  
  public StateDisplay(int x, int y, int dx, int dy){
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    activated = true;
  }
  
 
  
  public void draw(){
     stroke(0);
     if(activated){
       fill(color1);
     }else{
        fill(color2);
     }
     circle(x,y,(dx +dy)/2);
     
     fill(0);
     textSize(fontSize);
     if(activated){
       text(state1, x + dx / 2 + textSpace,y);
     }else{
       text(state2, x + dx / 2 + textSpace,y );
     }
     
     
   
  }
  
  
   public void setStates(String state1, String state2){
    this.state1 = state1;
    this.state2 = state2;
  }
  
  public void setColor(color color1, color color2){
    this.color1= color1;
    this.color2 = color2;
  }
  
  void mousePressed(){
    if(mouseButton == LEFT){
       if(mouseX > x - dx/2 && mouseX < x + dx/2){
         if(mouseY > y -dy/2 && mouseY < y +dy/2){
           switchState();  
         }
       }
    } 
  }
  
  public void switchState(){
    this.activated = !this.activated;
  }
  
}  
  
