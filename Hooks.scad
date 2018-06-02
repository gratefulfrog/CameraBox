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
// hook measurements
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

module measuredHook(wallThickness){
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
module twoMeasuredHooks(wallThickness,withSupport){
  hookSupportZ = wallThickness;
  translate([0,
             -hookSupportY/2.,
             0]){
      measuredHook(wallThickness);
      translate([0,hookSpacingY,0])
        measuredHook(wallThickness);
             }
      if (withSupport){
        hookSupport(wallThickness);
        //translate([-hookSupportX/2.,0,-hookSupportZ])
          //cube([hookSupportX,hookSupportY,hookSupportZ]);
      
    }
  }
  

module hookSupport(wallThickness){
  hookSupportZ = wallThickness;
  translate([-hookSupportX/2.,-hookSupportY/2.,-hookSupportZ])
          cube([hookSupportX,hookSupportY,hookSupportZ]);
}

//measuredHook();
//twoMeasuredHooks(2, true);
//hookSupport(2);

