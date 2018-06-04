// sleek box 02
/* This file will make the aerodynamic sleek box with either an air-hole
 * or a NACA Duct, depending on the boolean arguments to the box module:
 * box(invertved, duct)
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

wallThickness = 2;

hookSupportZOffSet = 15.4;

module camera(collor=true){
  if (collor){
    color(cameraColor,1){
      cube([cameraX,cameraY,cameraZ],center=true);
    }
    color("Black",1){
      translate([cameraX/4.,-cameraY/2.,0])
        rotate([90,0,0])
          cylinder(d=cameraX/2.,h=cameraOffset);
    }
    color("Silver",1){
      coolingDisc();
    }
  }
  else{
    coolingDisc();
  }
}
module coolingDisc(ht=cameraOffset){
  translate([heatSinkCenterOffSetX,cameraY/2.-heatSinkEndOffsetY,cameraZ/2.])
    cylinder(d=heatSinkDiameter,h=ht);
}
module cameraOffset(){
  reductionFactor = 1;//0.75;
  color(cameraOffsetColor,1){
    cube([cameraX+cameraOffset*reductionFactor,
          cameraY+cameraOffset*reductionFactor,
          cameraZ+cameraOffset*reductionFactor],
         center=true); 
   translate([0,-5,0])
    cube([cameraX+cameraOffset*reductionFactor,
          cameraY+cameraOffset*reductionFactor,
          cameraZ+cameraOffset*reductionFactor],
         center=true); 
  }
}
module enclosingSaucer_0(inverted){
  resizeFactor = 1.16;
  difference(){
    hull(){
      union(){
      airfoilLip(cameraY,1.16,wallThickness);
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
    }
    union(){
      resize(newsize=[resizeFactor*55.5,
                      resizeFactor*46.28*2,
                      resizeFactor*24.96])
        sphere(d=enclosingSphereDiamter);
        noseCutter();
    }
  }
  airfoilLip(cameraY,1.16,wallThickness);
}

module enclosingSaucer(inverted){
  resizeFactor = 1.16;
  difference(){
    hull(){
      enclosingSaucer_0(inverted)
      airfoilLip(cameraY,1.16,wallThickness);
    }
    resize(newsize=[resizeFactor*55.5,
                    resizeFactor*46.28*2,
                    resizeFactor*24.96])
      sphere(d=enclosingSphereDiamter);
  }
}
module enclosingSaucerCuttingSaucer(inverted){
  resizeFactor = 1.16;
  difference(){
    resize(newsize=[2*resizeFactor*55.5+wallThickness,
                    2*resizeFactor*46.28*2+wallThickness,
                    2*resizeFactor*24.96+wallThickness])
          sphere(d=enclosingSphereDiamter);
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
  }
  
  
}
module cutterSaucer(innerdiviser=2){
  resizeFactor = 1.16;
  difference(){
    resize(newsize=[resizeFactor*55.5+wallThickness+50,
                    resizeFactor*46.28*2+wallThickness+50,
                    resizeFactor*24.96+wallThickness+50])
        sphere(d=enclosingSphereDiamter);
    
    resize(newsize=[resizeFactor*55.5+(wallThickness/innerdiviser),
                    resizeFactor*46.28*2+(wallThickness/innerdiviser),
                    resizeFactor*24.96+(wallThickness/innerdiviser)])
        sphere(d=enclosingSphereDiamter);
  }
}
module sideRack(starboard){
  if (starboard){
    track2(-1);
  }
  else{
    track2(+1);
  }
}
module track2(sign){
  translate([sign*(cameraX+2*cameraOffset)/2.,
              0,
              -(cameraZ+2*cameraOffset)/2.])
    track1(true);
  //cube([rackWidth,cameraY,rackWidth],center=true);
  translate([sign*(cameraX+2*cameraOffset)/2.,
              0,
              +(cameraZ+2*cameraOffset)/2.])
    track1(false);
  //cube([rackWidth,cameraY,rackWidth],center=true);
}
module track1(up){
  if (up){
    track0();
  }
    else{
      rotate([0,180,0])
        track0();
    }
  }
module track0(){
  eps=2;
  translate([-rackWidth/2.,-cameraY/2.,-rackWidth/2.])
      difference(){
        cube([rackWidth,cameraY,rackWidth]);
      rotate([24,0,0])
        translate([-eps,0,0])
        cube([20,20,20]);
      }
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
module shell(inverted,duct){
  allRacks();
  if (duct){
    ductedEnclosingSaucer(inverted);
  }
  else{
    enclosingSaucer(inverted);
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
module pod(inverted,duct){
  difference(){
    union(){
      shell(inverted,duct);
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
  }
}
module box(inverted,duct){
  difference(){
    pod(inverted,duct);  
    union(){
      cameraOffset();
      if (!duct){
        coolingDisc(20);
      }
    }
  }
}


///////////////////////////////////////////////////
////////// NACA Duct

ductRotation = 3.92;
ductSlope = 7;
ductHeight = 7;

ductWidth = heatSinkDiameter;
ductWalls = 1;
ductExtension = 22;
slopeExtenstion = 220;
slopeWidth = ductWidth - 2*ductWalls;
slopeHeight = 5;
//  ductZTranslate = hookSupportZOffSet-3.65;// wall thickness 5 mm, angle 7
ductZTranslate = hookSupportZOffSet-4.5;  // wallThickness 2mm, angle 7

module ductedEnclosingSaucer(inverted){
  difference(){
    difference(){
      union(){
        difference(){
            enclosingSaucer(inverted);  // true means inverted!!
            difference(){
              rotate([0,ductRotation,0])
                translate([heatSinkCenterOffSetX-1,-slopeHeight,ductZTranslate])
                  rotate([0,0,-90])
                    nacamSlopeCut(ductSlope,
                               slopeWidth,
                               slopeHeight,
                               slopeExtenstion,
                               ductWalls);
            }
          }    
        rotate([0,ductRotation,0])
          translate([heatSinkCenterOffSetX-1,-slopeHeight,ductZTranslate])
            rotate([0,0,-90])
              closedDuct(ductSlope,ductWidth,ductHeight,ductExtension,ductWalls);
      }   
      enclosingSaucerCuttingSaucer(inverted);    
    }
  }
}

///////////////////////////  end NACA Duct
////////////////////////////////////////////////////////////


//////////////////////////////////
////// aero lip
circDia = 2;
ringInitRadias = 18;

ringYTranslationAddition = -0.1; //.17;
ringXResize = 55;
ringYResize = 1.6;
ringZResize = 25.8;

module ring(){
  rotate([90,0,0])
    rotate_extrude(convexity=10,$fn=100)
      translate([ringInitRadias,,0,0])
        circle(d=circDia);
}


module stretchedRing(resizeFactor,wallThickness){                              
  resize(newsize=[resizeFactor*55.5+wallThickness,
                  0,
                  resizeFactor*24.96+wallThickness])
    ring();
}

module airfoilLip(cameraY,resizeFactor,wallThickness){
  translate([0,-cameraY/2.+ringYTranslationAddition,0])
    resize([ringXResize,ringYResize,ringZResize])
      stretchedRing(resizeFactor,wallThickness);
}  
//// end of aero lip
//////////////////////

//%camera();
//cameraOffset();

// args are bools: inverted, duct
box(false, true);