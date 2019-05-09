class Cluster{

  float x;
  float y;
  float hue;
  float opacity;
  boolean fadingin;
  Star[] stars;

  Cluster(){
    x = random(0,width);
    y = random(0,height);
    //hue = random(huechanger-20,huechanger-10);
   hue=huechanger+30;
    opacity = random(0,100);
    float random = random(0,1);
    if (random > 0.5){
      fadingin = true;
    }
    else{
      fadingin = false;
    }
    
    stars = new Star[8];
    for (int i=0; i<stars.length; i++){
      stars[i] = new Star(x+random(minStarDistance,maxStarDistance), y+random(minStarDistance,maxStarDistance), random(minStarHue,maxStarHue), opacity);
      
    }
    
  }
  
  
  void move(){
    x = random(0,1235);
    y = random(0,960);   
    
    for (int i=0; i<stars.length; i++){
      stars[i].move(x+random(minStarDistance,maxStarDistance), y+random(minStarDistance,maxStarDistance), hue+random(minStarDistance,maxStarDistance));
      
    }
  }
  
  void display(){
    for (int i=0; i<stars.length; i++){
      stars[i].update(opacity);
      stars[i].display();
    }
  } 
  
  void update(){
    if (fadingin){
      opacity+=fadeInSpeed;
    }
    else{
      opacity-=fadeOutSpeed;
    }
    
    if (opacity > 100){
      fadingin = false;
    }
    if (opacity < 0){
      fadingin = true;
      this.move();
    }
    hue = hue++;
    
    
  }
}