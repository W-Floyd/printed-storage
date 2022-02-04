// Higher definition curves
$fs = 0.01;
$fa = 5;

width = 2;
height = 1;
depth = 1;

radius = 0.1;
corner_offset = (radius*(1 + 1/sqrt(2)));

Points = [
  [ width/2, height/2, depth/2 ],  //0
  [ width/2 - corner_offset, height/2, depth/2 ],  //1
  [ width/2, height/2 - corner_offset, depth/2 ],  //2
  [  width/2, height/2, depth/2 - corner_offset ]  //3
];

module scale_about_pt(s, pt) {
    translate(pt)
        scale(s)
            translate(-pt)
                children();   
}


Faces = [
  [1,0,2],
  [0,1,3],
  [3,2,0],
  [1,2,3],
];

module corner(){
    scale_about_pt(2,[width/2-corner_offset/3, height/2-corner_offset/3, depth/2-corner_offset/3]){
                            polyhedron( Points, Faces);
                        }
}

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
    
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}

scale(25.4) {
    
    //translate([width/2,height/2,depth/2]) {

    
            roundedcube([width+0.08, height+0.08, depth+0.08], true, 0.1, "z");



        

    //}

}