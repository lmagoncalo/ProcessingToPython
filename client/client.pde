import processing.net.*;
import java.nio.*;

int subArraySize = 50176;
Client myClient;

String data;
void setup() {
   myClient = new Client(this, "localhost", 9999); 

  // Create image to send
  PGraphics pg = createGraphics(224, 224);
  pg.beginDraw();
  pg.background(255, 0, 0);
  pg.noStroke();
  pg.fill(0, 255, 0);
  pg.circle(random(10,224), random(10,224),  random(10,60));
  pg.endDraw();
  pg.loadPixels(); 
  
  int [] data = pg.pixels;
  
   ByteBuffer byteBuffer = ByteBuffer.allocate(data.length * 4); //4 canais
  IntBuffer intBuffer = byteBuffer.asIntBuffer();
  intBuffer.put(data);
 
  byte[] array = byteBuffer.array();
  // Create the message for the size of the image
  String msg = String.valueOf(array.length);
  println(msg);
  
  try{
    // Send the size of the image first
    myClient.write(msg.getBytes("UTF-8"));
  
    // Create 4 subarrays
    byte[][] subArrays = new byte[4][subArraySize];
    for (int i = 0;i<4;i++){ // send the image split due to socket message limitation
       System.arraycopy(array, i * subArraySize, subArrays[i], 0, subArraySize);
       myClient.write(subArrays[i]);
    }
   
  } catch(Exception e){
    println("ERROR");
  }
}
