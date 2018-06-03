// sleek box 00

/*
width : 35.052mm
length: 60.452mm
height: 17.78 mm
heat port diameter = 21.73
*/

include <Hooks.scad>
include <NacaDuct.scad>

$fn=100;

cameraX      = 35.052;
cameraY      = 60.452;
cameraZ      = 17.78;
cameraColor  = "DarkBlue";
cameraOffset = 1; //0.2;
cameraOffsetColor = "RoyalBlue";

enclosingSphereDiamter = sqrt(pow(cameraX+cameraOffset,2) + 
                              pow(cameraY+cameraOffset,2) +
                              pow(cameraZ+cameraOffset,2));
                              
heatSinkDiameter     = 21.73;
heatSinkCenterOffSetX = 4.5;
heatSinkEndOffsetY    = 19.25;

rackWidth = 8;

wallThickness = 5;

hookSupportZOffSet = 15.4;

module camera(){
  color(cameraColor,1){
    cube([cameraX,cameraY,cameraZ],center=true);
  }
  color("Black",1){
    translate([cameraX/4.,-cameraY/2.,0])
      rotate([90,0,0])
        cylinder(d=cameraX/2.,h=cameraOffset);
  }
  color("Silver",1){
    translate([heatSinkCenterOffSetX,cameraY/2.-heatSinkEndOffsetY,cameraZ/2.])
      cylinder(d=heatSinkDiameter,h=cameraOffset);
  }
}
module cameraOffset(){
  color(cameraOffsetColor,1){
    cube([cameraX+cameraOffset,cameraY+cameraOffset,cameraZ+cameraOffset],center=true);  
  }
}
module enclosingSaucer(inverted){
  resizeFactor = 1.16;
  difference(){
    hull(){
      resize(newsize=[resizeFactor*55.5+wallThickness,
                        resizeFactor*46.28*2+wallThickness,
                        resizeFactor*24.96+wallThickness])
          sphere(d=enclosingSphereDiamter);
      if (inverted){
        translate([0,
                   0,
                   -hookSupportZOffSet+wallThickness])
        hookSupport(wallThickness);    
      }
      else{
        translate([0,
                     0,
                     hookSupportZOffSet])
        hookSupport(wallThickness);    
      }
    }
    resize(newsize=[resizeFactor*55.5,
                    resizeFactor*46.28*2,
                    resizeFactor*24.96])
      sphere(d=enclosingSphereDiamter);
  }
}
module cutterSaucer(){
  resizeFactor = 1.16;
  difference(){
    resize(newsize=[resizeFactor*55.5+wallThickness+50,
                    resizeFactor*46.28*2+wallThickness+50,
                    resizeFactor*24.96+wallThickness+50])
        sphere(d=enclosingSphereDiamter);
    
    resize(newsize=[resizeFactor*55.5+(wallThickness/2.),
                    resizeFactor*46.28*2+(wallThickness/2.),
                    resizeFactor*24.96+(wallThickness/2.)])
        sphere(d=enclosingSphereDiamter);
  }
}
module sideRack(starboard){
  if (starboard){
    track(-1);
  }
  else{
    track(+1);
  }
}
module track(sign){
  translate([sign*(cameraX+2*cameraOffset)/2.,
              0,
              -(cameraZ+2*cameraOffset)/2.])
  cube([rackWidth,cameraY,rackWidth],center=true);
  translate([sign*(cameraX+2*cameraOffset)/2.,
              0,
              +(cameraZ+2*cameraOffset)/2.])
  cube([rackWidth,cameraY,rackWidth],center=true);
}
module backRack(){
  translate([0,
            (cameraY+2*cameraOffset)/2.,
            -(cameraZ+2*cameraOffset)/2.])
    cube([cameraX+rackWidth+2*cameraOffset,rackWidth,rackWidth],center=true);
}
module allRacks(){
  difference(){
    union(){
      sideRack(true);
      sideRack(false);
      backRack();
    }
    cutterSaucer();
  }
}
module shell(inverted){
  difference(){
    union(){
     allRacks();
     enclosingSaucer(inverted);
    }
  noseCutter();
  }
} 
module noseCutter(){
  cutX=10*cameraX;
  cutY=10*cameraY;
  cutZ=10*cameraZ;
  translate([0,-cutY/2. - cameraY/2.,0])
    cube([cutX,cutY,cutZ],center=true);
}
module endHoleCutter(){
  delta = 0;
  translate([0,
             cameraY,
             0])
    sphere(d=cameraX);
}
module pod(inverted){
  difference(){
    union(){
      shell(inverted);
      if (inverted){
        translate([0,
                   0,
                   -hookSupportZOffSet])
          rotate([0,180,0])
            twoMeasuredHooks(wallThickness,false);
      }
      else{
        translate([0,
                   0,
                   hookSupportZOffSet])
            twoMeasuredHooks(wallThickness,false);
      }
    }
    endHoleCutter();
    //translate([heatSinkCenterOffSetX,
      //     cameraY/2.-heatSinkEndOffsetY,
        //   cameraZ/2.])
      //cylinder(d=heatSinkDiameter,h=20);
  }
}
module box(inverted){
  difference(){
    pod(inverted);  
    cameraOffset();
  }
}

//camera();
//cameraOffset();
//difference(){
%  box(false);  // true means inverted!!
 // rotate([0,3,0])
  //translate([heatSinkCenterOffSetX,5+7,hookSupportZOffSet-4])
    //rotate([0,0,-90])
      //nacamSlope(5,heatSinkDiameter,20,10);
//}
difference(){
  rotate([0,1.5,0])
    translate([heatSinkCenterOffSetX-1,5+7,hookSupportZOffSet-3.65])
      rotate([0,0,-90])
        nacamDuct(5,heatSinkDiameter,1.3,0.5);
  //cutterSaucer();
}
camera();
cameraOffset();
/*translate([heatSinkCenterOffSetX,
           cameraY/2.-heatSinkEndOffsetY,
           cameraZ/2.])
      cylinder(d=heatSinkDiameter,h=20);
*/