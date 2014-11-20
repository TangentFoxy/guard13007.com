var canvas=document.getElementById("gravcanvas");
canvas.height+=canvas.height/5;
var context=canvas.getContext("2d");
var objects=new Array();

// RUNNING SPEED VARIABLES
var runSpeed=20; // how many milliseconds between each iteration
var hyperWarp=false; // simulation is run multiple times per iteration     WARNING: Messing with this can freeze or crash your browser.
var hyperSpeed=20; // how many times to run simulation per iteration       WARNING: High values lead to lag, freezing, crashing.
var timeStep=1; // multipled by velocity/movement to change accuracy/speed of the simulation (lower is more accurate, but slower)

// RENDER RELATED VARIABLES
var hyperRender=true; // True=normal render, False=rendering ONLY WORKS with hyperWarp on, and at runSpeed (aka slower)
var scaleFactor=canvas.width/800; //0.6; //multiplied by data in rendering to adjust zoom level
var renderRadius=1; // minimum render radius for an object
var renderId=0; // ID of Thing to put at center of frame
var parentId=0; // ID of Thing to use as parent body for rotating frame of reference
var parentRotation=false; // whether to rotate based on angle between parentId and renderId (true), or using the rotation of renderId (false)
var renderType="norm"; // "side" shows a sideview (yes, a line), "3D" shows a pseudo-3D view, anything else goes to default
var path=false;  // draw path? [Don't clear canvas between draws.]

// CONSTANTS
var version="0.1.0" //Yes, there is a version number now. Don't know why.
var G;              //Gravitational Constant

initialize();

function initialize()
{
	//document.getElementById("gravtitle").innerHTML+=" "+version;
	unstableSystem();
	if (hyperWarp)
	{
		setInterval(function()
		{
			for (var i = 0; i < hyperSpeed; i++) loop();
			if (!hyperRender)
				redraw();
		},runSpeed);
	} else {
		setInterval("loop()",runSpeed);
	}
}

function loop()
{
	for (var i = 0; i < objects.length-1; i++) for (var j = i+1; j < objects.length; j++) gravity(i,j);
	for (var i = 0; i < objects.length; i++) update(i);
	for (var i = objects.length-1; i > 0; i--) for (var j = i-1; j > -1; j--) collisionCheck(i,j);
	if (hyperRender)
		redraw();
}

function Thing(m,x,y,Vx,Vy,color,radius,name,rotation)
{
	!name ? this.name="unnamed" : this.name=name;
	this.m=m;                                                     //mass
	!radius ? this.rad=Math.pow(m,1/3) : this.rad=radius;
	this.x=x;                                                     //location
	this.y=y;
	this.Vx=Vx;                                                   //velocity
	this.Vy=Vy;
	this.rot=0;                                                   //current rotation
	!rotation ? this.rotspd=0 : this.rotspd=rotation*Math.PI/180; //rotation speed
	!color ? this.fill="#FFFFFF" : this.fill=color;               //fill color
	this.fixed=false;
	this.collides=true;
}

function gravity(i,j)
{
	var Nx=false;
	var Ny=false;
	var Dx=objects[i].x-objects[j].x; //get relative distances
	var Dy=objects[i].y-objects[j].y;
	var Ds=Dx*Dx+Dy*Dy;               //note Ds is not Distance, but Distance^2
	if (Dx < 0)
	{
		Nx=true;                      //fix negative distance (for calculations)
		Dx=-Dx;
	}
	if (Dy < 0)
	{
		Ny=true;
		Dy=-Dy;
	}
	if (!objects[i].fixed)
	{
		var g=G*objects[j].m/Ds;     //calculate gravitational acceleration
		var Ax=Dx*g/(Dx+Dy);         //solve for acceleration x
		var Ay=g-Ax;                 //      for              y
		if (Nx) Ax=-Ax;              //fix negative values
		if (Ny) Ay=-Ay;
		Ax=-Ax; //i<j always, so needs gravity reversed (for some reason)
		Ay=-Ay;
		objects[i].Vx+=Ax*timeStep;  //apply change of velocity
		objects[i].Vy+=Ay*timeStep;
	}
	if (!objects[j].fixed)
	{
		var g=G*objects[i].m/Ds;     //calculate gravitational acceleration
		var Ax=Dx*g/(Dx+Dy);         //solve for acceleration x
		var Ay=g-Ax;                 //      for              y
		if (Nx) Ax=-Ax;              //fix negative values
		if (Ny) Ay=-Ay;
		objects[j].Vx+=Ax*timeStep;  //apply change of velocity
		objects[j].Vy+=Ay*timeStep;
	}
}

function update(i)
{
	objects[i].rot+=objects[i].rotspd;        //apply rotation
	if (!objects[i].fixed)
	{
		objects[i].x+=objects[i].Vx*timeStep; //apply acceleration
		objects[i].y+=objects[i].Vy*timeStep;
	}
}

function collisionCheck(i,j)
{
	// The try and catch really shouldn't be needed, check through looping for errors (maybe should be deleting j instead of i??).
	try
	{
		var Dx=objects[i].x-objects[j].x; //find distances
	}
	catch(err)
	{
		console.log("Error caught: "+err);
		return;
	}
	var Dy=objects[i].y-objects[j].y;
	var d=Math.sqrt(Dx*Dx+Dy*Dy);
	if (d < objects[i].rad+objects[j].rad)
	{
		if (!objects[i].collides) 
		{
			console.log("Ignored collision between "+i+" and "+j+".");
			return;
		}
		if (!objects[j].collides)
		{
			console.log("Ignored collision between "+i+" and "+j+".");
			return;
		}
		console.log("Collision between "+i+" and "+j+".");
		if (objects[j].m > objects[i].m) objects[i].fill=objects[j].fill; // the color of the more massive object is kept
		if (renderId == j) renderId=i;                    // fix renderId if needed
		if (renderId > j) renderId-=1;
		if (objects[i].fixed)
		{
			objects[i].m+=objects[j].m;                   //add mass
			var rad=Math.pow(objects[i].m,1/3);           //recalc radius
			if (rad > objects[i].rad) objects[i].rad=rad;
			objects.splice(j,1);                          //delete [j]
			return;
		}
		if (objects[j].fixed)
		{
			objects[i].m+=objects[j].m;                   //add mass
			objects[i].x=objects[j].x;                    //move to correct position
			objects[i].y=objects[j].y;
			objects[i].Vx=0;                              //correct the velocity
			objects[i].Vy=0;
			var rad=Math.pow(objects[i].m,1/3);           //radius recalculated
			if (rad > objects[i].rad) objects[i].rad=rad;
			objects[i].fixed=true;                        //become fixed
			objects.splice(j,1);                          //delete [j]
			return;
		}
		var Lx=objects[i].x*objects[i].m+objects[j].x*objects[j].m;   //weighting the mass vs location to find the CoM
		var Ly=objects[i].y*objects[i].m+objects[j].y*objects[j].m;
		var Fx=objects[i].Vx*objects[i].m+objects[j].Vx*objects[j].m; //calculate force to apply to "new" object
		var Fy=objects[i].Vy*objects[i].m+objects[j].Vy*objects[j].m;
		objects[i].m+=objects[j].m;                       //add mass of [j]
		objects[i].Vx=Fx/objects[i].m;                    //apply combined force
		objects[i].Vy=Fy/objects[i].m;
		var rad=Math.pow(objects[i].m,1/3);               //recalculate radius based on new mass
		if (rad > objects[i].rad) objects[i].rad=rad;
		objects[i].x=Lx/objects[i].m;                     //find center of mass, place [i] there
		objects[i].y=Ly/objects[i].m;
		objects.splice(j,1);                              //delete [j]
	}
}

function redraw()
{
	if (!parentRotation)
	{
		var rot=objects[renderId].rot;
	} else {
		var a=objects[renderId].x-objects[parentId].x;
		var o=objects[renderId].y-objects[parentId].y;
		var rot=Math.atan2(a,o)-Math.PI/2;
	}
	if (!path) context.clearRect(0,0,canvas.width,canvas.height);
	for (var i = 0; i < objects.length; i++)
	{
		context.beginPath();
		if (renderType=="side")
		{
			var x=(objects[i].x-objects[renderId].x)*scaleFactor+canvas.width/2;
			var y=(objects[i].x-objects[renderId].x)*scaleFactor+canvas.height/2;
		} else if (renderType=="3D")
		{
			var x=((objects[i].x-objects[renderId].x)*Math.cos(30)-(objects[i].y-objects[renderId].y)*Math.sin(30))*scaleFactor+canvas.width/2;
			var y=((objects[i].y-objects[renderId].y)*Math.sin(30)+(objects[i].x-objects[renderId].x)*Math.cos(30))*scaleFactor+canvas.height/2;
		} else {
			var x=((objects[i].x-objects[renderId].x)*Math.cos(rot)-(objects[i].y-objects[renderId].y)*Math.sin(rot))*scaleFactor+canvas.width/2;
			var y=((objects[i].x-objects[renderId].x)*Math.sin(rot)+(objects[i].y-objects[renderId].y)*Math.cos(rot))*scaleFactor+canvas.height/2;
		}
		var radius=objects[i].rad*scaleFactor;
		if (radius < renderRadius) radius=renderRadius;
		context.arc(x,y,radius,0,2*Math.PI);
		context.fillStyle=objects[i].fill;
		context.fill();
	}
}

function unstableSystem()
{
	G=10;
	objects[0]=new Thing(100,0,0,0,0,"yellow");
	objects[0].fixed=true;
	objects[1]=new Thing(10,50,0,0,-4,"green");
	objects[2]=new Thing(0.005,180,0,0,2.32,"#6A6A87",1);
	objects[3]=new Thing(26,400,0,0,-1.5,"red");
	objects[4]=new Thing(0.01,420,0,0,-4,"blue",1);
	objects[5]=new Thing(0.005,200,0,0,2.3,"#6A6A87",1);
	objects[6]=new Thing(0.005,160,0,0,2.51,"#6A6A87",1);
	objects[7]=new Thing(0.005,-180,0,0,-2.32,"#6A6A87",1);
	objects[8]=new Thing(0.009,-170,10,0,-2,"#6A6A87",1);
	objects[9]=new Thing(0.001,-300,40,0.4,-1.5,"#6A6A87",1);
	objects[10]=new Thing(0.08,100,0,0,-2.7,"#6A6A87",1);
	objects[11]=new Thing(0.1,-400,10,0,1,"orange",2);
	objects[12]=new Thing(0.004,170,0,0,2.7,"#6A6A87",1);
	objects[13]=new Thing(0.006,140,16,0,2.51,"#6A6A87",1);
	objects[14]=new Thing(0.0032,-185,32,0,-2.32,"#6A6A87",1);
	objects[15]=new Thing(0.01,-100,10,0.4,-2.14,"#6A6A87",1);
	objects[16]=new Thing(0.0001,-325,42,0.32,-1.55,"#6A6A87",1);
	objects[17]=new Thing(0.082,105,-50,0.1,-2.7,"#6A6A87",1);
}