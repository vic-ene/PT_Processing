import org.gicentre.utils.spatial.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.network.traer.physics.*;
import org.gicentre.utils.geom.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.colour.*;
import org.gicentre.utils.text.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.traer.animation.*;
import org.gicentre.utils.io.*;
import peasy.*;



public class Display3D{
  
  Planet earth;
  PeasyCam cam;

  PImage earthTexture;
  PImage[] textures = new PImage[3];

  
  private PApplet parent;
  private int x, y ,dx, dy;
  private int tx, ty;
  private float rx;
  
  public Display3D(PApplet parent, int x, int y, int dx, int dy){
    this.parent = parent;
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.tx = x + dx / 2;
    this.ty = y + dy / 2 ;
    this.rx = -PI/70;
    
    frameRate(60);
    
    earthTexture = loadImage("earth.jpg");
    earth = new Planet(150, 0, 0, earthTexture);
    

     
   
   
  }
  
  
  
  
  public void draw(){
     rotateX(rx);
     translate(tx, ty); 
     
    
     earth.draw();
    
     translate(-tx, -ty);
     rotateX(-rx);
  }
    
}



class Planet {
  float radius;
  float distance;
  Planet[] planets;
  float angle;
  float orbitspeed;
  PVector v;

  PShape globe;

  Planet(float r, float d, float o, PImage img) {

    radius = r;
    distance = d;
        
    //noStroke();
    //noFill();
    globe = createShape(SPHERE, radius);
    globe.setTexture(img);
  }

 

 
  void draw() {
    pushMatrix();
    shape(globe);  
    popMatrix();
  }
}
