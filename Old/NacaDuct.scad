$fn=100;

module nacaduct_cutout(aspect){
  width  = 0.1 * aspect /2 ;
  translate([0,0,-.1215]){
    difference(){
      translate([0,0,-0.0]) linear_extrude(0.122) 
        polygon(points = [ 
          [0,width], 
          [0.1, width-width*0.004], 
          [0.2, width-width*0.034], 
          [0.3, width-width*0.234], 
          [0.4, width-width*0.386], 
          [0.5, width-width*0.534], 
          [0.6, width-width*0.612], 
          [0.7, width-width*0.688], 
          [0.8, width-width*0.764], 
          [0.9, width-width*0.842], 
          [1.0, width-width*0.917],
          [1.0, -width+width*0.917], 
          [0.9,-width+width*0.842], 
          [0.8, -width+width*0.764], 
          [0.7,-width+width*0.688], 
          [0.6, -width+width*0.612], 
          [0.5,-width+width*0.534], 
          [0.4, -width+width*0.386], 
          [0.3, -width+width*0.234], 
          [0.2, -width+width*0.034],
          [0.1, -width+width*0.004], 
          [0,-width]]);
      translate([0.02,-width,-0.15])
        rotate([0,-7,0])
          cube([1.5,width*2,0.15]);
      }
    translate([-0.2,-width,0])cube([0.21,width*2,0.1]);
    }
}


difference(){
   translate([-3,-5,-2]) cube([20,10,2]);
   scale(15) nacaduct_cutout(5);
}