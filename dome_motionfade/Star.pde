class Star{

  float x;
  float y;
  float hue;
  float opacity;
  boolean huefadingin;

  Star(float x_, float y_, float hue_, float opacity_){
    x = x_;
    y = y_;
    hue = hue_;
    opacity = opacity_;
  }
  
  
  void display(){
    float theHue = hue+clusterhuechanger;
    fill(theHue%360,180,360,opacity);
    ellipse(x, y, 120,120);
  } 
  
  void move(float x_, float y_, float hue_){
    x = x_;
    y = y_;
    hue = hue_;  
    opacity = 0;
    
  }
  
  void update(float opacity_){
   
    opacity = opacity_;

    
  }
}