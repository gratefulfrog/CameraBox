$fn=100;


module nacamSlope(slope,maxW,h,extL){
  currentWidth= 10;
  currentLength = 16.1;
  scaleFactor=maxW/currentWidth;
  rotate([0,-slope,0])
    resize([0,maxW,0],auto=[true,true,false]){
    linear_extrude(height=h,center=false,convexity=10){
      import("MyNacaDuct_7Dgree_slope_scaled_R12.dxf");
      translate([-extL,-currentWidth/2.,0])
      square([extL,currentWidth]);
    }
  }
}

module nacamCut(nacamWidth){
nacamY = nacamWidth; // 21.73;
epsilon = 1;
cubeY = nacamY + epsilon;
  difference(){
    translate([0,-cubeY/2,0])
      cube([35,cubeY,35*tan(7)]);
    nacamSlope(nacamY);
  }
}


//nacamCut(21.73);
/*
difference(){
  nacamSlope(7,11,2,150);
  nacamSlope(7,10,10,150);
}
*/
module nacamDuct(slope,maxW,depth,extL){
  difference(){
    nacamSlope(slope,maxW+2*depth,20,extL);
    translate([0,0,depth])
      nacamSlope(slope,maxW,20,extL*2);  
  }
}

//nacamDuct(3,10,1,50);
/*difference(){
  nacamSlope(7,14,4,50);
  translate([0,0,2])
      nacamSlope(7,10,4,100);  
}
*/