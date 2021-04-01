
import grafica.*;
import java.util.Random;


public class GraphsDisplay{
   private PApplet parent;
  
  public static final String  TIME_IN_SECONDS = "Time (seconds)";
  
  public static final int NUMBER_OF_GRAPHS = 3;
  public static final int INTERVAL = 50;     // numbers of points we can along x axis at once
  public static final int PLOT_DX = 400, PLOT_DY = 400;
  public static final int OG_Y_MIN = 25, OG_Y_MAX = 50,
                          ACC_Y_MIN = -80, ACC_Y_MAX = 80;
  
  public static final int PLOT_1 = 0,
                          PLOT_2 = 1,
                          PLOT_3 = 2; 
                          
  public static final String LAYER_1 = "0",
                             LAYER_2 = "1",
                             LAYER_3 = "2";
                             
             
                             
                             
                   
  // we use those variables / objects when we only want to draw a single graph 
  public boolean priority = false;
  private int priorityIndex = - 1; 
  private GPoint prevPriorityPos, prevPriorityDim;
  
  private int hbdx = 50, hbdy = 50, hbx = 0, hby = height - hbdy;
  private boolean showValues;
 

  
  public GPlot plot1, plot2, plot3; 
  
  ArrayList<GPlot> plots;
  int[][] plotPos = {{0, 0}, {400, 0}, {800, 0}};
  String[] plotUnits = {" °C", " N", " m/s^2" }; 
  
  float[][][] plotValues = new float[3][3][3];
  boolean[] moveAroundGraph = {false , false, false};
  
  private color[][] layerColors = {{color(240,77,77), color(150,77,77), color(220, 130, 160) }, 
                                   {color(100,200,100), color(50,200,50), color(50,250,200)}, 
                                   {color(40,200,200), color(70,177,250), color(150,100,150) }};

  private int invisibleColorInt = 16777215, originalLineColor = -1778384896;
  private color invisibleColor = color(255,255,255,0);
  

  public GraphsDisplay(PApplet parent){
     this.parent = parent;
     
     
  
    
    /*                                  FIRST PLOT  SETUP 
    ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
    
    plot1 = new GPlot(this.parent);
    plot1.setPos(plotPos[0][0], plotPos[0][1]);
    plot1.setOuterDim(400,400);
        
    plot1.setTitleText("Temperature");
    plot1.getXAxis().setAxisLabelText(TIME_IN_SECONDS);
    plot1.getYAxis().setAxisLabelText("T (Celsius)");
    plot1.setYLim(10, 30);
    plot1.setPointColor(layerColors[0][0]);

    
    plot1.activatePanning();
    plot1.activateZooming(1.2, CENTER, CENTER);
   
   
    
    plot1.addLayer(LAYER_2, new GPointsArray());
    plot1.getLayer(LAYER_2).setPointColor(layerColors[0][1]);
    plot1.addLayer(LAYER_3, new GPointsArray());
    plot1.getLayer(LAYER_3).setPointColor(layerColors[0][2]);
    
    /* ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
   
   
    
  
  
    
    /*                                  SECOND PLOT  SETUP 
    ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
   
    
    plot2 = new GPlot(this.parent);
    plot2.setPos(plotPos[1][0], plotPos[1][1]);
    plot2.setOuterDim(400 , 400 );

    
    plot2.getTitle().setText("Stress");
    plot2.getXAxis().getAxisLabel().setText(TIME_IN_SECONDS);
    plot2.getYAxis().getAxisLabel().setText("Force (N)");
    plot2.setYLim(0, 1024);
    plot2.setPointColor(layerColors[1][0]);
    
    plot2.activatePanning();
    plot2.activateZooming(1.2, CENTER, CENTER);
    
    plot2.addLayer(LAYER_2, new GPointsArray());
    plot2.getLayer(LAYER_2).setPointColor(layerColors[1][1]);
    plot2.addLayer(LAYER_3, new GPointsArray());
    plot2.getLayer(LAYER_3).setPointColor(layerColors[1][2]);
    
    /* ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
   
    /*                                  THIRD PLOT  SETUP 
    ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
   
    /* LAYER_1 = X    cyan
       LAYER_2 = Y    blue
       LAYER_3 = Z    purple    
     */
   
    plot3 = new GPlot(this.parent);
    plot3.setPos(plotPos[2][0], plotPos[2][1]);
    plot3.setOuterDim(400 , 400 );
    
    plot3.setTitleText("Acceleration");
    plot3.getXAxis().setAxisLabelText(TIME_IN_SECONDS);
    plot3.getYAxis().setAxisLabelText("Acceleration (m/s^2)");
    plot3.setYLim(ACC_Y_MIN, ACC_Y_MAX);
    plot3.setPointColor(layerColors[2][0]);
   
    plot3.activatePanning();
    plot3.activateZooming(1.2, CENTER, CENTER);
    
    
    plot3.addLayer(LAYER_2, new GPointsArray());
    plot3.getLayer(LAYER_2).setPointColor(layerColors[2][1]);
    plot3.addLayer(LAYER_3, new GPointsArray());
    plot3.getLayer(LAYER_3).setPointColor(layerColors[2][2]);
    
    /* ----------------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------------  */
   
    plots = new ArrayList<GPlot>();
    plots.add(plot1);
    plots.add(plot2);
    plots.add(plot3);
  
  }
  
  
  public void draw(){
   
 
    // when we only draw one plot in fullscreen
    if(priority){
      fill(255);
      rect(0, 0, width, height);
      update(priorityIndex);
      drawPlot(priorityIndex);
      
      fill(130,190,220);
      rect(hbx,hby,hbdx,hbdy);
      if(showValues){
        fill(255);
        rect(0,0, 300, height);
        fill(0);
        int xb = 20, yb = 100, yb1 = 30, yb2 = 250;
        for(int i = 0; i < plotValues[priorityIndex].length; i ++){
          String layerIndex = str(i);
          if(getLayer(priorityIndex, layerIndex ) != null){
            int numberOfPoints = getLayer(priorityIndex, layerIndex).getPoints().getNPoints();
            fill(layerColors[priorityIndex][i]);
            text("Average: " + str(plotValues[priorityIndex][i][0] / numberOfPoints), xb,yb  + 1 * yb1 + i * yb2);
            text("Max: " + str(plotValues[priorityIndex][i][1]), xb,yb  + 2 * yb1 + i * yb2);
            text("Min: " + str(plotValues[priorityIndex][i][2]), xb,yb  + 3 * yb1 + i * yb2);        
          }
        }
      }
      return;
    
    }
    
    // when we draw all the plots
    for(int i = 0; i < plots.size(); i ++){
      update(i);
      drawPlot(i);
    }
    
    
  }
  
  public void drawPlot(int i){
      GPlot tempPlot = plots.get(i);
     // if(!displays[i]){
         tempPlot.beginDraw();
         tempPlot.drawBox();
         tempPlot.drawXAxis();
         tempPlot.drawYAxis();
         tempPlot.drawTitle();
         tempPlot.drawPoints();
         tempPlot.drawLines();
         tempPlot.endDraw();
    //  } 

  }
 
  
  public void update(int i){
   
   
    // Recenter when not clicking on the graph
    GPlot tempPlot = plots.get(i);
    if(moveAroundGraph[i] == false){
      if(tempPlot.getPoints().getNPoints() > 0){
         GPoint lastPoint = tempPlot.getPoints().getLastPoint();
         int numberOfPoints = tempPlot.getPoints().getNPoints();
         if(numberOfPoints - INTERVAL <  0){
           tempPlot.setXLim(0, lastPoint.getX());
         }else{
           float lowerX = tempPlot.getPoints().get(numberOfPoints - INTERVAL).getX();
           tempPlot.setXLim(lowerX, lastPoint.getX());
         }     
      }
    }
    
 }
  
  
  public void mousePressed(){
    for(int i = 0; i < plots.size(); i ++){
      GPlot plot = plots.get(i);
      if(mouseOver((int)plot.getPos()[0] + (int)plot.getMar()[0], (int)plot.getPos()[1] + (int)plot.getMar()[1], (int)plot.getDim()[0], (int)plot.getDim()[1])){
         if(mouseButton == RIGHT){
            givePriority(i);
            return;
        }
        if(mouseButton == LEFT){
          moveAroundGraph[i] = true;
        }
      }
    }
    if(priority){
      if(mouseOver(hbx, hby, hbdx, hbdy)){
        showValues = true;
      }
      else showValues = false;     
    }
    
  }
  
  public void mouseReleased(){
    for(int i = 0; i < NUMBER_OF_GRAPHS; i ++){
      moveAroundGraph[i] = false;
    }
  }
  
  public void keyPressed(){
    if(priorityIndex >= 0){
      if(keyCode ==  '1'){
        hideLayer(priorityIndex, LAYER_1);
      }else if(keyCode == '2'){
        hideLayer(priorityIndex, LAYER_2);
      }else if(keyCode == '3'){
        hideLayer(priorityIndex, LAYER_3);
      }
    }
    
  }
  
  
  public void addValue(int PLOT_X, String LAYER_X, PVector newPoint){
 
     // We find the right plot and the right layer
    GLayer layer = getLayer(PLOT_X, LAYER_X);
    // on count the number of points
    int numberOfPoints = layer.getPoints().getNPoints();
    // we add the new point
    
     float x = newPoint.x;
     float y = newPoint.y;
     int layerIndex = int(LAYER_X);
     layer.addPoint(new GPoint(x , y));
    
    
    
    /* Si il n'y avais aucun point (numberOfPoints = 0) on initialise la liste 
     min = nouvelle valeur, max = nouvellere valuer, total = nouvelle valeur    */
    float[] tempPlotValues = plotValues[PLOT_X][layerIndex]; 
    if(numberOfPoints == 0){
      for(int j = 0; j < plotValues[PLOT_X][layerIndex].length; j ++){
        tempPlotValues[j] = y;
      }
    }
    // sinon on  rajoute dans le total et on fait les comparaisons qu'il faut.  
    else{
       tempPlotValues[0] += y;
       tempPlotValues[1] = y > tempPlotValues[1] ? y: tempPlotValues[1];
       tempPlotValues[2] = y < tempPlotValues[2] ? y: tempPlotValues[2];
    }
  }
 
  
  
  
  
    // used to give or remove priority to a plot
    public void givePriority(int i){
      priority = !priority;
       if(priority){
           priorityIndex = i;
           GPlot plot = plots.get(priorityIndex);
           prevPriorityPos = new GPoint(plot.getPos()[0], plot.getPos()[1]);
           prevPriorityDim = new GPoint(plot.getDim()[0], plot.getDim()[1]);       
           plot.setDim(width -  2* plot.getMar()[0], height - 2 * plot.getMar()[1]);
           plot.setPos(0,0);
       }  
       else{
           GPlot plot = plots.get(priorityIndex);
           plot.setPos(prevPriorityPos.getX(), prevPriorityPos.getY());
           plot.setDim(prevPriorityDim.getX(), prevPriorityDim.getY());
          
      }
    
  }
  
  
  
  // used to hide or show a layer
  public void hideLayer(int PLOT_X, String LAYER_X){
    GLayer layer = getLayer(PLOT_X, LAYER_X);
    if(layer.getLineColor() == invisibleColorInt){
       layer.setPointColor(layerColors[PLOT_X][int(LAYER_X)]);
       layer.setLineColor(originalLineColor);
    }else{
       layer.setPointColor(invisibleColor);
       layer.setLineColor(invisibleColor); 
    }
   
  }
  
  
  
  public GLayer getLayer(int PLOT_X, String LAYER_X){
    GPlot plot = plots.get(PLOT_X);
    if(LAYER_X.contentEquals(LAYER_1)){
      return plot.getMainLayer();
    }
    else{
      return plot.getLayer(LAYER_X);
    }
  }
  
  
  
  
  
   
}
