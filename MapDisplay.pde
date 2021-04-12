public class MapDisplay{

  
  public static final int MAX_HEIGHT = 1000;
  public static final int ARRIVAL_STEPS = 20;
  public static final int ROUND_UP_DISTANCE = 5;
  public static final int TARGET_DISTANCE = 50;
  public static final int MAX_RANDOMIZER = 30;
  
  public boolean drawTarget, showBox = true;
  
  public PVector origin, object, target, velocity, distance;

  public int ogx, ogy,x, y, dx, dy;
  public int diameter, smalldiameter = 20;
  public int boxOffsetY = 20, boxSizeX = 150, boxSizeY = 100;
  public int textBoxGap = 25, textBoxOffsetX = 10;
  public int randomCounter, randomizer;
  public int fontSize = 20;
  
  public color mapColor = color(200),
               originColor = color(20,200,200),
               objectColor = color(200,100,50),
               targetColor = color(20,200,50);
               
  private PImage  mapImage;

 
  
  public float finalX = 0.00;
  public float finalY = 0.00;
  public float finalZ = 0.00;
  public float finalVx = 0.00;
  public float finalVy = 0.00;
  public float finalVz = 0.00;
  
  public MapDisplay(int ogx, int ogy, int dx, int dy){
   
    
     this.ogx = ogx;
     this.ogy = ogy;
     this.dx = dx;
     this.dy = dy;
     this.x = ogx - dx / 2;
     this.y = ogy -dy / 2;
     this.diameter = (dx + dy) / 2 - 1;
     
     origin = new PVector(ogx, ogy, 0);
     object = new PVector(ogx, ogy, 0);
     target = new PVector(ogx, ogy, 0);
     velocity = new PVector(0, 0, 0);
     
     mapImage = loadImage("map.png");
     
       
  
    
   
  }
  
  public void draw(){
  
    update();
    
    int tz = 1;
    translate(0,0,tz);
   
    stroke(200);
    fill(230,242,255);
    image(mapImage, ogx - dx/2, ogy - dy/2, dx, dy );
    
    textSize(fontSize);
    
    if(drawTarget){
        translate(0,0,tz);
        fill(targetColor);
        circle(target.x, target.y, smalldiameter);
    }
   
    
    translate(0,0,tz);
    fill(originColor);
    circle(origin.x, origin.y, smalldiameter);
    
    translate(0,0,tz);
    fill(objectColor);
    circle(object.x, object.y, smalldiameter);
    
    
    
    if(showBox){
       fill(255);
       translate(0,0,tz);
       rect(object.x - boxSizeX / 2, object.y - (boxSizeY + boxOffsetY), boxSizeX, boxSizeY);
       PVector dist = getDistanceAsVector();
       fill(0);
       translate(0,0,tz);
       text("x: " + (int)dist.x + "m", object.x - boxSizeX / 2 + textBoxOffsetX, object.y - boxSizeY);
       text("y: " + (int)dist.y + "m", object.x - boxSizeX / 2 + textBoxOffsetX, object.y - boxSizeY + textBoxGap * 1 );
       text("z: " + (int)dist.z + "m", object.x - boxSizeX / 2 + textBoxOffsetX, object.y - boxSizeY + textBoxGap * 2 );
       text("total: " + (int)getDistance() + "m", object.x - boxSizeX / 2 + textBoxOffsetX, object.y - boxSizeY + textBoxGap * 3 );
    }
    
    translate(0,0,-6*tz);
   
       
     
  }
  
  
  public void update(){
      
     finalX = rocketDisplay.finalX4;
     finalY = rocketDisplay.finalY1;
     finalZ = rocketDisplay.finalZ4;
     finalVx = rocketDisplay.finalVx4;
     finalVy = rocketDisplay.finalVy1;
     finalVz = rocketDisplay.finalVz4;
        
    
     randomCounter++;
     if(randomCounter > randomizer){
       randomizer = (int)random(MAX_RANDOMIZER);
       randomCounter = 0;
       moveObject(true);
       
     }
     if(sameVector(target, object)){
         moveObject(true);
     }else{
       if(PVector.dist(object, target) < ROUND_UP_DISTANCE){
         object.set(target.x, target.y, target.z);
         moveObject(true);     
       }
     object.add(velocity);        
     }   
  }
  
  public void moveObject(boolean around){
     createNewTarget(around);
     createNewVelocity(); 
     if(around){
        while(PVector.dist(target, origin) > diameter / 2){
          createNewTarget(around);
          createNewVelocity();  
        }
     }
  }
  
  public void createNewTarget(boolean around){
     float angle = random(360);
     if(around){
        target.x = ((cos(radians(angle))) * TARGET_DISTANCE) * random(1) + object.x;
        target.y = ((sin(radians(angle))) * TARGET_DISTANCE) * random(1) + object.y;
        target.z = random(MAX_HEIGHT);
     }else{
       target.x = ((cos(radians(angle))) * diameter / 2) * random(1) + ogx;
       target.y = ((sin(radians(angle))) * diameter / 2) * random(1) + ogy;
       target.z = random(MAX_HEIGHT);
      
     }
    
  }
  
  public void createNewVelocity(){
    velocity = new PVector((target.x - object.x) / ARRIVAL_STEPS,
                              (target.y - object.y) / ARRIVAL_STEPS,
                              (target.z - object.z) / ARRIVAL_STEPS
               );
         
  }
  
  public boolean sameVector(PVector v1, PVector v2){
     if(v1.x == v2.x){
       if(v1.y == v2.y){
          if(v1.z == v2.z){
             return true;
          }
       }
     }
     return false;
  }
  
  public PVector generateRandomVector(int x, int xx, int y, int yy, int z, int zz){
    return new PVector(
       (int)(random(x, xx)),
       (int)(random(y ,yy)),
       (int)(random(z, zz))
    );
  }
  
  public PVector getDistanceAsVector(){
    return new PVector(
                       abs(origin.x - object.x),
                       abs(origin.y - object.y),
                       abs(origin.z - object.z)
                      
                );
                
  }
  
  public float getDistance(){
    return PVector.dist(origin, object);
  }
  
  void mousePressed(){
    if(mouseX > x && mouseX < x + dx){
      if(mouseY > y && mouseY < y + dy){
        showBox = !showBox;
      }
    }
  }
}
