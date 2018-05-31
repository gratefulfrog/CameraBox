/* 2PartBox.scad
 * 2018 05 12
 * gratefulfrog.org
 * generates a box for a video camera that mounts to the Freewing Stores pod
 * This version creates a 2 part box that slides together.
 * Usage:
 * at the very end of the file, this line generates the box parts
 *    doBox("x");
 * the arguments are explained just above that line. 
 * hit F5 to get a view, or F6 to build the object.
 * ATENTION: this file includes the file Box.scad, so if you get unepexected results, like long
 * delays in building, then check that there are no top level build commands uncommented in
 * Box.scad.
 */

/* unused exact camera dimensions, excluding the lens
width : 35mm
length: 60mm
height: 18mm
*/

include <Box.scad>

$fn = 100;

wallThickness = 2;
innerX=37;
innerY=62;
innerZ=20;
outerX=innerX+2*wallThickness;
outerY=innerY+2*wallThickness;
outerZ=innerZ+2*wallThickness;

sliderZ = innerY+wallThickness;
topZ    = innerY;
topColor = "aqua";
bottomColor = "LightCoral"; 

hooksOffsetZ = (topZ-hookSpacingY-hookLength)/2.;

module bottom(){
  color(bottomColor,1){
    hull()
      intersection(){
        translate([0,0,-wallThickness])
          linear_extrude(height=sliderZ,convexity=10)
            import("Box Grooved 01 inverted.dxf",layer="0");
        translate([-50,-50,-10])
          cube([100,100,10]);
      }
    
    translate([0,0,-wallThickness])
      linear_extrude(height=sliderZ,convexity=10)
        import("Box Grooved 01 inverted.dxf",layer="0");
    }
  }
/*
  module newBottom(){
  color(bottomColor,1){
    rotate([0,0,180])
      translate([0,outerZ,0]){
        difference(){
          translate([0,-outerZ,0])
            rotate([0,0,180])
              bottom();
          discC();
        }
        translate([0,0,hooksOffsetZ])
          rotate([-90,0,0])
            translate([0,-hookSupportY,0])
              twoMeasuredHooks(false);
      }
    }
}
*/
module newBottom(){
  color(bottomColor,1){
    rotate([0,0,180])
      translate([0,outerZ,0]){
          translate([0,-outerZ,0])
            rotate([0,0,180])
              bottom();
        translate([0,0,hooksOffsetZ])
          rotate([-90,0,0])
            translate([0,-hookSupportY,0])
              twoMeasuredHooks(false);
      }
    }
}
  
module topTrimmer(){
  trimDistY = 0.5;
  trimBoxX  = 50;
  trimBoxY  = 5;
  trimBoxZ  = 20;
  rotate([-90,0,0])
    translate([-trimBoxX/2.,-innerY-trimBoxY+trimDistY,-trimBoxZ/2.])
      cube([trimBoxX,trimBoxY,trimBoxZ],center=false);
}
module top(){
  color(topColor,1.0){
    difference(){
      linear_extrude(height=topZ,convexity=5)
        import("Box Grooved 01 inverted.dxf",layer="base",convexity=10);
      discC();
    }
    translate([0,0,hooksOffsetZ])
      rotate([-90,0,0])
        translate([0,-hookSupportY,0])
          twoMeasuredHooks(false);
  }
}
module newTop(){
  color(topColor,1.0){
    difference(){
      linear_extrude(height=topZ,convexity=5)
        import("Box Grooved 01 inverted.dxf",layer="base",convexity=10);
      discC();
    }
  }
}


module discC(h=wallThickness*4.){
  discOffsetX = (innerX/2.-(1.5+4*wallThickness))/2.;
  // this translation is x,z,-y in final result
  translate([discOffsetX,h/2.,lCorrection/2.+hookLength+hooksOffsetZ+heatPortD/2.])
    rotate([90,0,0])
      linear_extrude(height=h)
        circle(d=heatPortD+lCorrection);
}
module nibs2(positive){
   nibsY = 6-innerY;
   nibsX = 20.6;
   nibsZ = -2.5;
   nibsRMax= 1.5;
   nibsReduction = 0.2;
   nibsR = positive ? nibsRMax - nibsReduction : nibsRMax;
   translate([nibsX,nibsY,nibsZ])
    sphere(r=nibsR);
   translate([-nibsX,nibsY,nibsZ])
    sphere(r=nibsR);
 }
module nibs(positive){
   nibsDeltaY = 5;
   nibs2(positive);
   translate([0,nibsDeltaY,0])
    nibs2(positive);
 }

module doBox(part="x", new){
  if (part != "b") { // do the top
    rotate([90,0,0]){    
      difference(){
        if (new) 
          newTop();
        else
          top();
        color(topColor,1)
          topTrimmer();
      }
    }
    color(topColor,1.0){
      nibs(true);
    }
  }
  if (part != "t") {  // do the bottom
    difference(){
      rotate([90,0,0])    
        if (new)
          newBottom();
        else
          bottom();
        color(bottomColor,1)
          nibs(false);
    }
  }
}
 
/* The following line will generate the 2 part box parts depending on 
 * the arguments: (note top is the thin part, bottom is the other.
 * "t" : generate only the top
 * "b" : generate only the bottom
 * anything else : generate both top and bottom
 * second argument true makes the hooks on the bottom
 * false makes the hooks on the top.
 */
doBox("b",true);
