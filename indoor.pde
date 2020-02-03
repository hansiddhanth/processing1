import java.util.*;
import java.util.Collections;

int col=42;
int row = 8;
node[][] pos = new node[col][col];
float wid;
float ht;
List<park_space2> spot = new ArrayList<park_space2>();
PShape Node,Node_inner,/*Car,*/Lot;
IntDict spaces;
String[] lines;
String end_position;
//PShape carr;
node start,end;
PVector User;
boolean flag = false,reached=false;
float camX,camY,camZ,screenX,screenY;
float buff_x,buff_y,sbuff_x,sbuff_y;
int P=0, Q=0, X, Y;
float dir_angle=0;
int ctr;
float delta;


public void settings() {
  size(1120, 480, "processing.opengl.PGraphics3D");
}


void setup()
{
  //size(1120, 480, P3D); //Display resolution
  lines = loadStrings("start_end_position.txt"); //Load the Designated Slot
  end_position = join(lines,"");
  //end_position = new String(buffer);
  //carr = loadShape("11497_Car_v2.obj");  //Load the Car Shape
  //carr.scale(0.25);  //Fit the Car to scale
  //carr.disableStyle();  //Remove default Car Color
  //carr.setFill(0);
  frameRate(30);  //Set Frame Rate
  Lot = createShape(GROUP);  // Create Matrix of Nodes 
  wid = width / col;  // Width of Each Node 
  ht = height / row;  // Height of each Node
  Node = createShape(RECT, 0, 0, wid, ht);  //Creates Nodes
  Lot.addChild(Node);  // Add Nodes to Matrix 
  Node.setStroke(true);  // Brightens Top surface of Each Free Slot 
  for (int i =0; i < col; i+=1) 
  {
    for (int j =0; j < row; j+=1)
    {
      pos[i][j] = new node(i, j);  //Creating new nodes 
    }
  }
  spaces = new IntDict();
  parkLot2(0 , 0, 42, 1);  //Defining Parking Slots in the Matrix
  parkLot2(36, 3, 6 , 43);  //Defining Parking Slots in the Matrix
  parkLot2(9 , 3, 24, 47);  //Defining Parking Slots in the Matrix
  parkLot2(0 , 3, 6 , 71);  //Defining Parking Slots in the Matrix
  parkLot2(36, 4, 6 , 77);  //Defining Parking Slots in the Matrix
  parkLot2(9 , 4, 24, 83);  //Defining Parking Slots in the Matrix
  parkLot2(0 , 4, 6 , 127);  //Defining Parking Slots in the Matrix
  parkLot2(36, 7, 6 , 133);  //Defining Parking Slots in the Matrix
  parkLot2(9 , 7, 24, 139);  //Defining Parking Slots in the Matrix
  parkLot2(1 , 7, 5 , 162);  //Defining Parking Slots in the Matrix

  //img = loadImage("car_top_view.png");
  start = pos[7][7];  //Setting Start Position
  //end = TargetSpot(230);
  
  end = TargetSpot(Integer.parseInt(end_position));  
  User = new PVector(0,0);
  User.set(start.i,start.j);
  
  //The start and end positions can never be obstacles
  start.obs = 0;
  end.obs = 0;
  
  //Add neighbors
  for (int i=0; i< col-1; i++) 
  {
    if (pos[i][row - 1].IsNeighbor(pos[i + 1][row - 1])) 
    {
      pos[i][row - 1].AddNeighbor(pos[i + 1][row - 1]);
    }
  }
  
  for (int i=0; i<row-1; i++) 
  {
    if (pos[col - 1][i].IsNeighbor(pos[col - 1][i + 1])) 
    {
      pos[col - 1][i].AddNeighbor(pos[col - 1][i + 1]);
    }
  }
  
  for (int i = 0; i < col - 1; i += 1) 
  {
    //Adds neighbor if it is not an obstacle
    for (int j = 0; j < row - 1; j += 1) 
    {
      if (pos[i][j].IsNeighbor(pos[i + 1][j])) 
      {
        pos[i][j].AddNeighbor(pos[i + 1][j]);
      }
      if (pos[i][j].IsNeighbor(pos[i][j + 1])) 
      {
        pos[i][j].AddNeighbor(pos[i][j + 1]);
      }
    }
  }
  //ambientLight(0,50,200);
  println(frameRate);
}



void draw() {
  
  lights();
  background(225, 225, 255);
  //directionalLight(124, 124, 124, -1, -1, -1); 
  if(abs(User.x - end.i)<1 && abs(User.y - end.j)<1)  //Condition to recognize the reaching of designated slot
  {
    reached = true;
  }
  else
  {
    reached = false;
    println(User.x,end.i,User.y,end.j);
  }
  
  if(!reached)  //Camera control for following the car
  {
  camX = start.i*0.6+User.x*0.7+end.i*0.1;
  camY = start.j*0.6+User.y*0.7+end.j*0.1;
  camZ = height/2.0 / tan(PI/3)+20;
  screenX = User.x;
  screenY = User.y;
    camera(camX,camY,camZ,screenX, screenY,0, 0, 0, -1);
  buff_x = camX;
  sbuff_x = screenX;
  buff_y = camY;
  sbuff_y = screenY;
  }
  
  if(reached)  //Shifting Camera to Top View after reaching
  {
    if (frameCount%3==0){
    camX = (2*width/2+camX)/3;//camX + (camX - width/2)/10;
    camY = (2*height/2+camY)/3;//camY + (camY - height/2)/10;
    camZ = camY*2;
    screenX = (2*width/2+screenX)/3;//screenX + (screenX - width/2)/10;
    screenY = (2*height/2+screenY)/3;//screenY + (screenY - height/2)/10;
    camera(camX,camY,camZ,screenX,screenY,0,0, 1,0);
    //ortho();
    }
  }
  
  //camera(User.x+start.i*0.2+end.i*0.2,User.y+3*ht+start.j*0.2+end.j*0.2,300,User.x,User.y,0,0,0,1);
  //camera(User.x+100,User.y,0,User.x,User.y,0,0,0,-1);
  push();
  //translate(0, 0, -100);
  float angle = 25.0;
  angle = radians(angle);
  //rotateZ(-PI/2);
  //rotateX(angle);
  //translate(-350,200);
  //ortho();

  
    //rotateX();
    if (mousePressed)  //Panning 
    {
      P = mouseX - X;
      Q = mouseY - Y;
    } 
    else 
    {
      X = mouseX;
      Y = mouseY;
    }
  if (P!=0 || Q!=0) 
  {
    translate(P, Q, 0);  //Smoothens the camera view
  }
  
  //DRIVEWAY HORIZONTAL
  push();
  noStroke();
  fill(190);
  //rect(0,5.5*ht/4,width,5*ht/4);
  translate(width/2-wid/2,3*5.5*ht/8,1.5);
  box(width-wid,8*ht/4,3);
  translate(0,4*ht,0);
  box(width-wid,8*ht/4,3);
  pop();
  
  //DRIVEWAY VERTICAL
  push();
  noStroke();
  fill(190);
  //rect(0,5.5*ht/4,width,5*ht/4);
  translate(7.5*wid,4*ht,1.5);
  box(4*ht/4,4*ht,3);
  translate(27*wid,0,0);
  box(4*ht/4,4*ht,3);  
  pop();
  
  //OUTLINE
  push();
  stroke(0);
  fill(175,255);
  translate(width/2-wid/2,height/2,-15);
  box(1120,480,30);
  pop();



  for (int i = 0; i < col; i += 1) {
    for (int j = 0; j < row; j += 1) {
      //pos[i][j] = new node(i, j);
      //line(0, i, height, i);
      //line(j, 0, j, width);

      pos[i][j].display(170, 170, 170, 255);
      //shape(Node,pos[i][j].i,pos[i][j].j);
    }
  }
  //node start = pos[0][0];
  //node end = pos[20][20];
  //int fc = frameCount/10;
  //println(pos[20][0].neighbors);
  push();
  fill( 64, 128, 173 );
  nav(start.astar(end));  //Start A-Star algo
  nav(start.astar(TargetSpot(31)));
  //translate(0,0,3.5);
  //shape(Car,User.x+wid/2,User.y+ht/2);
  //Car.rotate(delta,0,0,1);
  imageMode(CENTER);
  push();
  translate(User.x+wid/2,User.y+ht/2,5);
        //pointLight(0,255,255,0,0,100);
  rotate(dir_angle);
  //shape(carr,0,0);
  rotate(-PI/2);
  //tint(255,255);
  //image(img,0,0,ht,wid*2);
  //box(ht,wid,wid);
  
  pop();
  pop();
  pop();

  //println(TargetSpot(340).x,TargetSpot(340).y);
  //if(!reached){
  //saveFrame("demo4_1/####.png");
  //}
}

void parkLot2(int x, int y, int num, int star_pos2) {
  //for(int j = rows-1; j >= 0; j--){
  for (int i = num-1; i >= 0; i--) {
    pos[x+i][y].obs = 1;//[y+j].obs = 1;
    park_space2 temp = new park_space2(star_pos2, pos[x+i][y]);
    spot.add(temp);
    spaces.set(str(temp.spot_number2),spot.indexOf(temp));
    star_pos2++;
  }
  
  
  //}
}

void nav(List <node> arr){
    List<node> temp = new ArrayList<node>();
    temp = arr;
    Collections.reverse(temp);
    if(ctr < temp.size()){
    navigate(User,temp.get(ctr).i,temp.get(ctr).j);
    if(flag){      
      ctr++;      
    }        
    }    
  }
  
void navigate(PVector user,float p,float q) {
  //push();
  //transX = transX + (p-x)*0.005;
  //transY = transY + (q-y)*0.005;
  PVector dir = new PVector((p-user.x)*0.005,(q-user.y)*0.005);
  dir.normalize();
  float speed =3;
  dir.mult(speed);
  //translate(transX,transY);
  //rect(User.x,User.y,100,100);
  if((abs(user.x - p) < speed)&&(abs(user.y - q) < speed)){
    dir.set(0,0);
    flag = true;    
    //println(user.x,user.y,flag);
  }
  
  else{
  user.add(dir);
  flag = false;
  delta = dir.heading()+PI/2 - dir_angle ;
  dir_angle = dir.heading()+PI/2 ;
  
  }
}
  
node TargetSpot (int number){
  
  return spot.get(spaces.get(str(number))).grid_box2;
}
