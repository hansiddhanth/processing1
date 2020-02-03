class node
{
  int x ; // order of node/brick in the system
  int y; // ...
  float i; // current x coordinate of the user
  float j;// currrent y coordinate of the user
  //List<node> vertices = new Arraylist<node>();
  //node[] vertices = new node;
  List<node> neighbors = new ArrayList<node>();  //List of Neighbours
  // int[] neighborsf = new int[4];
  //node[] Final;
  int obs;
  int ps;
  node parent;
  String value = str(this.i) + str(this.j);
  float g;
  float h;
  float f;
  
  node(int I, int J){
  //side = width/col;
  x = I;
  y = J;
  i = I*wid;
  //side = height/row;
  j = J*ht;
  //append(vertices, this);
  g = 0;
  h = 0;
  f = g + h;
  }
  
  //Check if Nodes are neighbour to current Node
  boolean IsNeighbor(node b)
  {
    if(b.obs==1 || this.obs==1)
    {
      return false;
    }
    else if (this.i == b.i && this.j == b.j)
    {
      return false;
    }
    else if (abs(this.i - b.i) == abs(this.j - b.j))
    {
      return false;
    }
    else if (abs(this.i - b.i) <= wid && abs(this.j - b.j) <= ht)
    {
      return true;
    }
    else
    {
      return false;
     }
  }

//Add Neighbour Nodes to Neighbour List
  void AddNeighbor(node a)
  {
    
    //Make sure object is not an obstacle
    if(this.obs!=1)
    {      
    neighbors.add(a);  //add 'a' to 'neighbors' of object, and vice versa
    a.neighbors.add(this);
      
      //optional
    //append(neighborsf,a.f);
    //append(a.neighborsf, this.f);
    }
  }
  float md(node a)  //Returns Manhattan Distance
  {
   return abs(this.i - a.i) + abs(this.j - a.j);
  }
  
  void display(int a , int b , int c , int d )
  {
    color clr;
    //if(a||b||c||d){
    clr = color(a,b,c,d);
    //}
    
    if (this.obs==1)
    {
      push();
      //Node.setFill(color(102, 252, 241,125));
      //Node.setStroke(true);
      //strokeWeight();
      //int len = side/2;
      //translate(this.i+side/2,this.j+side/2,len/2);
      //box(side*0.8,side*0.8,len); 
      //rect(this.i,this.j,wid,ht);
      //stroke(120,120,120);
      noStroke();
      fill(255,255,255,200);
      translate(this.i+wid/2,this.j+ht/2,5);
      box(wid*0.8,ht*0.8,30);
      //shape(Node,this.i,this.j);
      pop();
    } 
    
    else
    {
      push();
      Node.setFill(clr);
      Node.setStroke(false);
      //rect(this.i,this.j,wid,ht);
      shape(Node,this.i,this.j);
      pop();
    }
  }
  
  void display()
  {  
      
      
      
      push();
      fill(255,0,100,200);
      rectMode(CENTER);
      stroke(255,0,0);
      //rect(this.i+wid/2,this.j+ht/2,wid/1.5,wid/1.5);
      ellipse(this.i+wid/2,this.j+ht/2,0.75*wid,0.75*wid);
      pop();
    }
    
  void display(int a)
  {
      push();
      fill(a,a,a);
      noStroke();
      circle(this.i,this.j,0.7*width/col );
      //rect(this.i,this.j,width/col,height/row);
      pop();
    }
    
   void display(int a, int b, int c)
   {
     push();
      fill(a,b,c);
      //rect(this.i,this.j,width/col,height/row);
      //noStroke();
      translate(this.i+wid/2,this.j+ht/2,10);
      box(0.7*wid );
      pop();
    }
    
 
  List<node> astar (node end)
  {
  node q ;
  List<node> open = new ArrayList<node>();
  List<node> closed = new ArrayList<node>();
  List<String> closedV = new ArrayList<String>();
  //int startx = this.i;
  //int starty = end.j;
  List<node> Final = new ArrayList<node>();
  open.add(this);
  while (open.size()>0)
  {
    float minOpen = open.get(0).f;
    q = open.get(0);
    for (int i = open.size() - 1; i >= 0; i -= 1)
    {
      if (open.get(i).f <= minOpen) {
        minOpen = open.get(i).f;
        q = open.get(i);
    }
  }
    open.remove(open.indexOf(q));
    List<node> children  = q.neighbors;
    for (int i = 0; i < children.size(); i += 1)
    {
      if (children.get(i) == end)
      {
        end.parent = q;
      }
      else if (open.lastIndexOf(children.get(i))!=-1)
      {
        if (children.get(i).f <= q.g + q.md(children.get(i)) + children.get(i).md(end))
        {
          continue;
        }
      } 
      else if (closed.lastIndexOf(children.get(i))!=-1) 
      {
        if (children.get(i).f <= q.g + q.md(children.get(i)) + children.get(i).md(end)) 
        {
          continue;
        }
      } 
      else 
      {
        children.get(i).parent = q;
        children.get(i).g = q.g + q.md(children.get(i));
        children.get(i).h = children.get(i).md(end);
        open.add(children.get(i));
      }
    }
    closed.add(q);
    closedV.add(q.value);
    push();
  //  fill(190,0,0);
  //  draw(q);
    pop();
  }
  push();
  //fill(0,0,0)
  node k = end;
  //this.final.push(k);
  Final.add(k);
      push();
          translate(0,0,3.2);
  k.display();
  translate(0,0,-0.2);
  while(k.parent!= null)
  {
    //this.final.push(k.parent);
    Final.add(k.parent);
    strokeWeight(6);
    stroke( 0, 142, 207 ,165);
    line(k.i+wid/2,k.j+ht/2,k.parent.i+wid/2,k.parent.j+ht/2);
    k = k.parent;
    //k.display();
    //translate(k.i+size/2,k.j+size/2,size)
    //sphere(size/4)
    
  }
  translate(0,0,0.2);
  k.display();
  pop();
  pop();
  //print(closedV)
  return Final;
  }  //A-STAR algo
  

}
