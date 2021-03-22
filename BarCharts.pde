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

public class BarCharts{

  
  private PApplet parent;
  
  private BarChart barChart;
  
  public static final int MAX_FORCE = 1000;
  
  float[][] barChartNewData;   // We use this variable to generate random Values on the bar chart
    
  public BarCharts(PApplet parent){
    this.parent = parent;
  
  barChart = new BarChart(this.parent);
  barChart.setData(new float[] {(int)random(MAX_FORCE),(int)random(MAX_FORCE),(int)random(MAX_FORCE),(int)random(MAX_FORCE), (int)random(MAX_FORCE)});
  barChart.setBarLabels(new String[] {"ARef1","ARef2","AMotor","ABody","AHead"});
  barChart.setBarColour(color(170,170,80));
  barChart.setValueFormat("# m/s^2");
  barChart.setBarGap(2); 
  barChart.showValueAxis(true); 
  barChart.showCategoryAxis(true); 
  barChart.setMinValue(0);
  barChart.setMaxValue(MAX_FORCE);
  
  barChartNewData = new float[2][5];
  for(int i = 0; i < barChartNewData[0].length; i ++){
      barChartNewData[0][i] = (int)random(MAX_FORCE);
      barChartNewData[1][i] = (int)random(5) + 1;
  }
  
  }
  
  public void draw(){
    

 
  textSize(13);
  
  int space = 30;
  barChart.draw(space,400 + space / 2,400 - space ,400 - space );
  
  // Generate Random values
  float[] barChartData = barChart.getData();
  for(int i = 0; i < barChartData.length; i ++){
     int sign = sign((int)(barChartNewData[0][i] - barChartData[i]));
     for(int j = 0; j < barChartNewData[1][i]; j ++){
         barChartData[i] += sign;      
     }
     if(sign((int)(barChartNewData[0][i] - barChartData[i])) != sign){
         barChartNewData[0][i] = random(MAX_FORCE);
         barChartNewData[1][i] = (int)random(10) + 1;
     }
  }
  barChart.setData(barChartData);
  

  
  }

}
