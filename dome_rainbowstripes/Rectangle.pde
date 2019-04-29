
class Rectangle{
  
  int x;
  int hue;
    
  Rectangle(int x_, int hue_){
    x = x_;
    hue = hue_;
    
  }
  
  void update(){
    x+=speed;
    
    if (x>width+100){
      x=-100;
    }
    if (x<-100){
      x = width+100;
    }
    
  }
  
  void display(){
    fill(hue,70,100);
    noStroke();
    rect(x, 0, 105,height);
    
  }
  
  
 
  
}
