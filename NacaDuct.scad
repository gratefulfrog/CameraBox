$fn=100;


module nacamSlope(slope,maxW,h,extL){
  currentWidth= 100;
  currentLength = 161;
  scaleFactor=maxW/currentWidth;
  rotate([0,-slope,0])
    resize([0,maxW,0],auto=[true,true,false]){
    linear_extrude(height=h,center=false,convexity=10){
      import("MyNacaDuct_100x100x8_4_R12.dxf");
      translate([-extL,-currentWidth/2.,0])
        square([extL,currentWidth]);
    }
  }
}
/*
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
*/
module nacamDuct(slope,maxW,depth,extL,wallThickness){
  difference(){
    nacamSlope(slope,maxW,depth,extL);
    translate([0,0,wallThickness])
      nacamSlope(slope,maxW-2*wallThickness,depth,extL*2);  
  }
}
module closedDuct(slope,maxW,depth,extL,wallThickness){
  rotate([0,-slope,0]){
    translate([0,0,depth-wallThickness])
      nacamSlope(0,maxW,wallThickness,extL);
    nacamDuct(0,maxW,depth,extL,wallThickness);
  }
}
module nacamSlopeCut(slope,maxW,h,extL){
  currentWidth= 100;
  currentLength = 161;
  epsilon = 2;
  scaleFactor=maxW/currentWidth;
  cutterBlockY=currentWidth;
  cutterBlockX= extL+10*h;
  rotate([0,-slope,0])
    difference(){
     resize([0,maxW,0],auto=[true,true,false]){
      linear_extrude(height=h,center=false,convexity=10){
        import("MyNacaDuct_100x100x8_4_R12.dxf");
        translate([-extL,-currentWidth/2.,0])
          square([extL,currentWidth]);
      }
    }
    translate([0,0,h])
      rotate([0,-atan2(h,extL*scaleFactor),0])
        resize([0,maxW+epsilon,0],auto=[true,true,false]){
          linear_extrude(height=h,center=false,convexity=10){
            translate([-cutterBlockX/2.+5*h,0,0])
              square([cutterBlockX,cutterBlockY],center=true);
          }
        }
    }
}

/*
ductH = 2;
ductWalls = 0.5;
ductWidth = 10;
ductExt = 100;
ductAngle = 2;
//closedDuct(ductAngle,ductWidth,ductH,ductExt,ductWalls);
nacamSlopeCut(ductAngle,ductWidth,ductH,ductExt,ductWalls);
*/