$fn=100;

/* unused exact camera dimensions, excluding the lens
width : 35mm
length: 60mm
height: 18mm
*/

wallThickness = 2;
innerX=37;
innerY=62;
innerZ=20;
outerX=innerX+2*wallThickness;
outerY=innerY+2*wallThickness;
outerZ=innerZ+2*wallThickness;

innerExtensionY = 20; // to cut off the end of the outer box

hookSpacingY  = 50;
hookLength    = 4.76;

sphereD=wallThickness*2;

heatSinkRFactor =  0.75;
heatPortD= innerX*heatSinkRFactor;

module rawBox(){
boxTranslateY = -(outerY-(hookSpacingY+hookLength))/2.;
translate([-outerX/2.,boxTranslateY,-outerZ])
  difference(){
    cube([outerX,outerY,outerZ]);
    translate([wallThickness,wallThickness-innerExtensionY,wallThickness])
      cube([innerX,innerY+innerExtensionY,innerZ]);
  }
}
module importedHooks(){
  mountMaxY=54.8;
  mountMinY=2.6;
  mountMinZ=0;
  epsilon=0.002;
  cY=mountMaxY + 12;
  cX=10;
  cZ=10;
  difference(){
    import("Missile_Rail_Mount _repaired.stl", convexity=10);
    translate([-cX/2.,-mountMinY-epsilon,-cZ+epsilon])
      cube([cX,cY,cZ]);
  }
}  
module measuredHook(){
  BottomWidth      = 1.58 ;
  FirstVertical    = 2.39;
  bottomWingWidth  = 1.58;
  _2ndVertical     = 0.78;
  _3rdVertical     = _2ndVertical+0.01;
  TopWidth         = 3.18;
  epsilon= 2;  // to ensure ancoring in the base!
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
module twoMeasuredHooks(){
  measuredHook();
  translate([0,hookSpacingY,0])
    measuredHook();
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
module grid(gWidth=heatPortD+5,lineSpacing=2,lineWidth=1){
  translate([-gWidth/2.,0,0])
  for (i=[0:lineSpacing+lineWidth:gWidth]){
    translate([i,0,0]){
     square([lineWidth,gWidth],center=true);
    }
  }
}
module gridCutter(){
  linear_extrude(height=50)
    difference(){
      circle(d=heatPortD);
      rotate([0,0,90])
        grid();
      grid();
    }
  }
module boxWithGridAndHooks(){
  difference(){  
    roundedBox();
    translate([4.5,40,-20])
      gridCutter();
  }
  twoMeasuredHooks();
}

boxWithGridAndHooks();
  