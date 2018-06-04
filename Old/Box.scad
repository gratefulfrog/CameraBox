/* Box.scad
 * 2018 05 12
 * gratefulfrog.org
 * generates a box for a video camera that mounts to the Freewing Stores pod
 * Usage:
 * at the very end of the file, uncomment the line:
 * //boxWithGridAndHooks("d");
 * then hit F5 to get a view, or F6 to build the object.
 * It will take quite some time, during which OpenSCAD will bu unresponsive, that is normal
 * so just be patient.
 * ATENTION: this file is included in 2PartBox.scad so be sure to leave the last line
 * commented out if you intend to use 2PartBox.scad
 */

$fn=100;

wallThickness = 2;
innerX=37;
innerY=62;
innerZ=20;
outerX=innerX+2*wallThickness;
outerY=innerY+2*wallThickness;
outerZ=innerZ+2*wallThickness;

innerExtensionY = 20; // to cut off the end of the outer box

// hok measurements
hookSpacingY  = 50;
hookLength    = 4.76;
BottomWidth      = 1.58 ;
FirstVertical    = 2.39;
bottomWingWidth  = 1.58;
_2ndVertical     = 0.78;
_3rdVertical     = _2ndVertical+0.01;
TopWidth         = 3.18;

hookSupportX = BottomWidth  + 2*bottomWingWidth;
hookSupportY = hookSpacingY + hookLength;
hookSupportZ = wallThickness;

sphereD=wallThickness*2;

heatSinkRFactor =  0.75;
//heatPortD= innerX*heatSinkRFactor;

lCorrection = 3.5;
heatPortD= innerX*heatSinkRFactor - 2*hookLength;

module measuredHook(){
  epsilon= wallThickness;  // to ensure ancoring in the base!
  points = [[0,-epsilon],
            [BottomWidth,-epsilon],
            [BottomWidth,FirstVertical],
            [BottomWidth+bottomWingWidth,FirstVertical],
            [BottomWidth+bottomWingWidth,FirstVertical+_2ndVertical],
            [BottomWidth+bottomWingWidth-_3rdVertical,FirstVertical+_2ndVertical+_3rdVertical],
            [BottomWidth+bottomWingWidth-_3rdVertical-TopWidth,FirstVertical+_2ndVertical+_3rdVertical],
            [-BottomWidth,FirstVertical+_2ndVertical],
            [-BottomWidth,FirstVertical],
            [0,FirstVertical]];
  translate([-BottomWidth/2.0,hookLength,0])
  rotate([90,0,0])
    linear_extrude(height = hookLength)
      polygon(points,convexity = 1);
}
module twoMeasuredHooks(withSupport=true){
  measuredHook();
  translate([0,hookSpacingY,0])
    measuredHook();
  if (withSupport){
    translate([-hookSupportX/2.,0,-hookSupportZ])
      cube([hookSupportX,hookSupportY,hookSupportZ]);
  }
}
module sp2(){
  translate([sphereD/2.,0,sphereD/2.]){
    sphere(d=sphereD);
    translate([outerX-sphereD,0,0])
      sphere(d=sphereD);
  }
}
module sp4(){
  sp2();
  translate([0,outerY,0])
    sp2();
}
module roundedBox(){
  boxTranslateY = -(outerY-(hookSpacingY+hookLength))/2.;
  translate([-outerX/2.,boxTranslateY,-outerZ]){
    difference(){
      hull(){
        sp4();
        translate([0,0,outerZ-sphereD])
          sp4();
      }
      translate([wallThickness,wallThickness-innerExtensionY,wallThickness])
        cube([innerX,innerY+innerExtensionY,innerZ]);
    }
  }
}
module grid(gWidth=heatPortD+5,lineSpacing=2,lineWidth=0.5){
  translate([-gWidth/2.,0,0])
  for (i=[0:lineSpacing+lineWidth:gWidth]){
    translate([i,0,0]){
     square([lineWidth,gWidth],center=true);
    }
  }
}
module crissCross(){
  rotate([0,0,90])
        grid();
  grid();
}
module gridCutter(h){
  linear_extrude(height=h)
    difference(){
      circle(d=heatPortD+lCorrection);
      crissCross();
    }
  }
module circCutter(h){
  littleD=4;
  linear_extrude(height=h)
    intersection(){   
      circle(d=heatPortD+lCorrection);
      translate([-heatPortD/2.,-heatPortD/2.,0])
        for (i=[0:littleD+1:heatPortD+littleD+1])
          translate([0,i,0])
            for (j=[0:littleD+1:heatPortD+littleD+1])
              translate([j,0,0])
                circle(d=littleD);
    }    
}
module discCutter(h){
  linear_extrude(height=h)
      circle(d=heatPortD+lCorrection);
}
module boxWithGridAndHooks(circs){
  extrudeH = 5;
  //lCorrection = 03.5;
  hooksOffsetZ = (innerY-hookSpacingY-hookLength)/2.;
  difference(){  
    roundedBox();
    translate([4.5,20+(lCorrection/2.+hookLength+hooksOffsetZ+heatPortD/2.),-extrudeH/2.])
      if (circs== "d")
        #discCutter(extrudeH);
      else if (circs== "c")
        #circCutter(extrudeH);
      else
        #gridCutter(extrudeH);
  }
  #twoMeasuredHooks(false );
}
// uncomment boxWithGridAndHooks("d");  to generate a one piece box with hooks as per
// arguments: 
// "c" -> get circular grid cut
// "d" -> get a big disc cut
// anything else -> get a rectangular grid cut
//boxWithGridAndHooks("d");

//measuredHook();