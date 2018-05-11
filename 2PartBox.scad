$fn = 100;

/* unused exact camera dimensions, excluding the lens
width : 35mm
length: 60mm
height: 18mm
*/
include <Box.scad>


wallThickness = 2;
innerX=37;
innerY=62;
innerZ=20;
outerX=innerX+2*wallThickness;
outerY=innerY+2*wallThickness;
outerZ=innerZ+2*wallThickness;

sliderZ = innerY+wallThickness;
topZ    = innerY;

hooksOffsetZ = (topZ-hookSpacingY-hookLength)/2.;

module bottom(){
  color("LightCoral",1){
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
module top(){
  color("aqua",1.0){
    difference(){
      linear_extrude(height=topZ,convexity=5)
        import("Box Grooved 01 inverted.dxf",layer="base",convexity=10);
      discC();
    }
    translate([0,0,hooksOffsetZ])
      rotate([-90,0,0])
        translate([0,-hookSupportY,0])
          twoMeasuredHooks();
  }
}
module discC(h=wallThickness*4.){
  discOffsetX = (innerX/2.-(1.5+4*wallThickness))/2.;
  translate([discOffsetX,h/2.,hooksOffsetZ+heatPortD/2.])
  rotate([90,0,0])
  linear_extrude(height=h)
      circle(d=heatPortD);
}
rotate([90,0,0]){
  bottom();
  top();
}
