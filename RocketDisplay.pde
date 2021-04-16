import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import java.util.Scanner;







class RocketDisplay{
  
  private PApplet parent;
    
  float angle;
  String PosAcc1;
  String PosAcc2;
  String PosAcc3;
  Float values1[] = new Float[6];//Acc 1
  String inventory1[] = new String[3];
  Float values2[] = new Float[6];//Acc 2
  String inventory2[] = new String[3];
  Float values3[] = new Float[6];//Acc 3
  String inventory3[] = new String[3];
  Float values4[] = new Float[6];//Etalon Acc 1 et 2
  Float time[] = new Float[2];
  public float finalX4 = 0.00, finalX3 = 0.00;
  public float finalY2 = 0.00, finalY1 = 0.00;
  public float finalZ4 = 0.00, finalZ3 = 0.00;
  public float finalVx4 = 0.00, finalVz4 = 0.00;
  public float finalVx3 = 0.00, finalVz3 = 0.00;
  public float finalVy2 = 0.00, finalVy1 = 0.00;
  float pos;
  boolean ini;
  
  int a = 0;
  


  
  PShape rocket;
 
  float scale;
  float rx, ry , rz;
  float tx, ty, tz;
  float OG_TX, OG_TY, OG_TZ;
 
  
  PeasyCam cam;

  public RocketDisplay(PApplet parent){
    this.parent = parent;
    
    ini = true;

    pos = 0;
   
     for (int i = 0; i < 6; i++){
       values1[i] = 0.00;
       values2[i] = 0.00;
       values3[i] = 0.00;
       values4[i] = 0.00;
     }
     time[0] = 0.00;
     time[1] = 0.00;
    
     scale = 1f;
    
     rx = 0f;
     ry = 0f;
     rz = 0f;
          
     tx = 200;
     ty = 600;
     tz = 0;
     
    /* OG_TX = -66 * scale;
     OG_TY = -155 * scale;
     OG_TZ = -66 * scale;  */
     
     OG_TX = -0 * scale;
     OG_TY = -0 * scale;
     OG_TZ = -0 * scale;
     
   
    
    rocket = loadShape("rocket1.obj");
    rocket.scale(scale);
    
    //cam = new PeasyCam(parent, 1000);
    //cam.lookAt(width/2,height/2,0,0);
  
    
}

void draw(){
    //changement des positions de string vers float dans des lites
    //pos = pos + 0.05;
    PosAcc1 = "0.00,0.00,0.00";
    PosAcc2 = "0.00,0.00,0.00";
    PosAcc3 = "0.00,0.00,0.00";
    String[] inventory1 = split(PosAcc1, ',');
    String[] inventory2 = split(PosAcc2, ',');
    String[] inventory3 = split(PosAcc3, ',');
    for (int i = 0; i < 3; i++){
      values1[i] = float(inventory1[i]);
      values2[i] = float(inventory2[i]);
      values3[i] = float(inventory3[i]);
    }

    //moyenne pour la valeur de référence
    for (int i = 0; i < 3; i++){
      values4[i] = (values1[i]+values2[i])/2;
    }
    //intégrale pour le déplacement
    
    time[1] = time[0];
    time[0] = millis()/1000.0;
    
    finalX4 = (values4[0]-values4[3])/6*(pow(time[0],2)-pow(time[1],2)) + values4[3]/2*(pow(time[0],2)-pow(time[1],2)) + finalX4 + (time[0]-time[1])*finalVx4;
    finalZ4 = (values4[2]-values4[5])/6*(pow(time[0],2)-pow(time[1],2)) + values4[5]/2*(pow(time[0],2)-pow(time[1],2)) + finalZ4 + (time[0]-time[1])*finalVz4;
    
    finalX3 = (values3[0]-values3[3])/6*(pow(time[0],2)-pow(time[1],2)) + values3[3]/2*(pow(time[0],2)-pow(time[1],2)) + finalX3 + (time[0]-time[1])*finalVx3;
    finalZ3 = (values3[2]-values3[5])/6*(pow(time[0],2)-pow(time[1],2)) + values3[5]/2*(pow(time[0],2)-pow(time[1],2)) + finalZ3 + (time[0]-time[1])*finalVz3;
    
    
    
    finalY2 = (values2[1]-values2[4])/6*(pow(time[0],2)-pow(time[1],2)) + values2[4]/2*(pow(time[0],2)-pow(time[1],2)) + finalY2 + (time[0]-time[1])*finalVy2;
    
    finalY1 = (values1[1]-values1[4])/6*(pow(time[0],2)-pow(time[1],2)) + values1[4]/2*(pow(time[0],2)-pow(time[1],2)) + finalY1 + (time[0]-time[1])*finalVy1;
   
    finalVx4 = (values4[0]-values4[3])/2*(time[0]-time[1]) + values4[3]*(time[0]-time[1]) + finalVx4;
    finalVz4 = (values4[2]-values4[5])/2*(time[0]-time[1]) + values4[5]*(time[0]-time[1]) + finalVz4;
    finalVx3 = (values3[0]-values3[3])/2*(time[0]-time[1]) + values3[3]*(time[0]-time[1]) + finalVx3;
    finalVz3 = (values3[2]-values3[5])/2*(time[0]-time[1]) + values3[5]*(time[0]-time[1]) + finalVz3;
    finalVy2 = (values2[1]-values2[4])/2*(time[0]-time[1]) + values2[4]*(time[0]-time[1]) + finalVy2;
    finalVy1 = (values1[1]-values1[4])/2*(time[0]-time[1]) + values1[4]*(time[0]-time[1]) + finalVy1;
    //roulie
    
    
   
    
    if(values1[1] <= 0 && values2[1] <= 0 || values1[1] >= 0 && values2[1] >= 0){
      rotateY((finalY1+finalY2)/2);
    }
    //mouvement latéral
    if(values4[0] <= 0 && values3[1] <= 0 || values4[1] >= 0 && values3[1] >= 0){
      rotateX((finalX4+finalX3)/2);
    }
    if(values4[2] <= 0 && values3[2] <= 0 || values4[2] >= 0 && values3[2] >= 0){
      rotateX((finalZ4+finalZ3)/2);
    }
  

    lights();
    ortho();  
    
    if (a == 0){
      rx += random(-1,1)/1000.0;
      ry += 0.0005*millis()/500.0;
      rz += random(-1,1.2)/100.0;
      float zLim = 0.75;
      if(rz > zLim) rz = zLim;
      if (millis() > 25000 && a != 1){
        a = 1;
        statesDisplay.parachuteState.switchState();
      }
    }
     if(a == 1){
        rz += random(-1.0,0.5)/10.0*rz + random(-0.02,0.03);
        ry = random(-0.15,0.15);
    }
   
 

    translate(tx,ty);
  
    rotateZ(PI + rz);  
    rotateY(ry);
    rotateX(rx);
    translate(OG_TX,OG_TY,OG_TZ);
    shape(rocket);
    translate(-OG_TX, -OG_TY, -OG_TZ);
    rotateX(-rx);
    rotateY(-ry);
    rotateZ(-(PI + rz));
   
    translate(-tx, -ty); 
   
   

    //add value précédente
    for (int i = 0; i < 3; i++){
      values1[3 + i] = values1[i];
      values2[3 + i] = values2[i];
      values3[3 + i] = values3[i];
      values4[3 + i] = values4[i];
    }

}






}
