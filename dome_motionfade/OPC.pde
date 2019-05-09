/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */

import java.net.*;
import java.util.Arrays;

public class OPC implements Runnable
{
  Thread thread;
  Socket socket;
  OutputStream output, pending;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;
  

  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    thread = new Thread(this);
    thread.start();
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);
    
    
    
  }

  // Set the location of a single LED
  void led(int index, int x, int y)  
  {
    
    x = int(x*scale);
    y = int(y*scale);
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  
  // Set the location of several LED strips arranged in an equilateral triangle
  // Angle is in degrees, from point to base.
  // x,y is the center of the triangle. 
  void ledEquilateral(int fadecandy, int triangle, float x, float y, float angle, int type){
  
    int index = (fadecandy-1)*512 + (triangle-1)*64;
    
    float side1angle = radians(angle - 90);
    float side2angle = radians(angle - 120 - 90);
    float side3angle = radians(angle - 240 - 90);
    
    float angle1 = radians(degrees(side1angle) - 270);
    float angle2 = radians(degrees(side2angle)- 270);
    float angle3 = radians(degrees(side3angle) - 270);    
    
    if (type == 0){
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][0], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, false);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, false);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][2], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, false); 
    }
    
    if (type == 1){
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][0], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, true);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, false);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][2], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, false); 
    }
    
    if (type == 2){
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][0], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, true);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, false);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][2], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, false); 
    }
    if (type == 3){
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][0], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, false);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][2], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, false);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][1], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, false); 
    }
    if (type == 4){
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, true);   
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][2], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, true);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][0], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, true); 
    }
    if (type == 5){
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][0], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, true);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, true);   
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][2], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, true); 
    }
    if (type == 6){
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][0], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, false);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][1], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, false);   
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][2], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, false); 
    }
    if (type == 7){
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][0], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, true);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][1], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, true);   
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][2], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, true); 
    }
    if (type == 8){
      opc.ledStrip(index+equiCounts[0][1], equiCounts[1][1], x+cos(angle3)*35, y+sin(angle3)*35, 5, side3angle, true);   
      opc.ledStrip(index+equiCounts[0][0], equiCounts[1][2], x+cos(angle1)*35, y+sin(angle1)*35, 5, side1angle, true);   
      opc.ledStrip(index+equiCounts[0][2], equiCounts[1][0], x+cos(angle2)*35, y+sin(angle2)*35, 5, side2angle, true); 
    }
  }
  
  
  
  // Set the location of several LED strips arranged in an isosceles
  // Angle is in radians, from point to base
  // x,y is the center of the triangle. 
  void ledIsosceles(int fadecandy, int triangle, float x, float y, float angle, int type)
  {
    
    int index = (fadecandy-1)*512 + (triangle-1)*64;
    
    float theAngle = radians(angle);
    
    float xplus = cos(theAngle) * isoSize;
    float yplus = sin(theAngle) * isoSize;
    
    float cx = x + xplus;
    float cy = y + yplus;
    
    theCX = cx;
    theCY = cy;
    theY = y;
    theX = x;
    
    float side1angle = radians(angle - 90);
    float side2angle = radians(angle - 90 - 57);
    float side3angle = radians(angle - 270 + 57);
    
    float angle1 = radians(degrees(side1angle) - 270);
    float angle2 = radians(degrees(side2angle) - 270);
    float angle3 = radians(degrees(side3angle) - 270);    
    
    if (type == 2){      // long short short
      opc.ledStrip(index, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true);   
      opc.ledStrip(index+22, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, true);   
      opc.ledStrip(index+41, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
    }
    if (type == 3){  // long short short     
      opc.ledStrip(index, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true);   
      opc.ledStrip(index+22, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, false);   
      opc.ledStrip(index+41, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
    }
    if (type == 4){  // long short short     
      opc.ledStrip(index, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true);   
      opc.ledStrip(index+22, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, false);   
      opc.ledStrip(index+41, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
    }
    if (type == 1){     // short long short
      opc.ledStrip(index, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
      opc.ledStrip(index+19, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true);   
      opc.ledStrip(index+41, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, false);  
    }
    if (type == 0){        // short short long
      opc.ledStrip(index,  19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, false);   
      opc.ledStrip(index+19, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
      opc.ledStrip(index+38, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true); 
    }
    if (type == 5){        // short short long
      opc.ledStrip(index,  19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, true);   
      opc.ledStrip(index+19, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
      opc.ledStrip(index+38, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true); 
    }
     if (type == 6){      // long short short
      opc.ledStrip(index, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, true);   
      opc.ledStrip(index+22, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, false);   
      opc.ledStrip(index+41, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, true); 
    }
    if (type == 7){        // short short long
      opc.ledStrip(index, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, false);   
      opc.ledStrip(index+19, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, true); 
      opc.ledStrip(index+38, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, false); 
    }
    if (type == 8){     // short long short
      opc.ledStrip(index, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, true); 
      opc.ledStrip(index+19, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, false);   
      opc.ledStrip(index+41, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, false);  
    }
    if (type == 9){      // long short short
      opc.ledStrip(index, 22, cx+cos(angle1)*30, cy+sin(angle1)*30, 5, side1angle, false);   
      opc.ledStrip(index+22, 19, cx+cos(angle3)*32, cy+sin(angle3)*32, 5, side3angle, false);   
      opc.ledStrip(index+41, 19, cx-cos(angle2)*32, cy-sin(angle2)*32, 5, side2angle, true); 
    }
  }  
  
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip
  void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0) * spacing * c + 0.5),
        (int)(y + (i - (count-1)/2.0) * spacing * s + 0.5));
    }
  }

 
  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }    

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  } 

  // Set the color correction parameters
  void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }
  
  // Set custom color correction parameters from a string
  void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  void sendFirmwareConfigPacket()
  {
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }
 
    byte[] packet = new byte[9];
    packet[0] = (byte)0x00; // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = (byte)0x00; // Length high byte
    packet[3] = (byte)0x05; // Length low byte
    packet[4] = (byte)0x00; // System ID high byte
    packet[5] = (byte)0x01; // System ID low byte
    packet[6] = (byte)0x00; // Command ID high byte
    packet[7] = (byte)0x02; // Command ID low byte
    packet[8] = (byte)firmwareConfig;

    try {
      pending.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = (byte)0x00;               // Channel (reserved)
    header[1] = (byte)0xFF;               // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);   // Length high byte
    header[3] = (byte)(packetLen & 0xFF); // Length low byte
    header[4] = (byte)0x00;               // System ID high byte
    header[5] = (byte)0x01;               // System ID low byte
    header[6] = (byte)0x00;               // Command ID high byte
    header[7] = (byte)0x01;               // Command ID low byte

    try {
      pending.write(header);
      pending.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
    if (output == null) {
      return;
    }

    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = (byte)0x00;              // Channel
      packetData[1] = (byte)0x00;              // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);   // Length high byte
      packetData[3] = (byte)(numBytes & 0xFF); // Length low byte
    }
  }
  
  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  void setPixel(int number, color c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }
  
  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  color getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    if (output == null) {
      return;
    }

    try {
      output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  void dispose()
  {
    // Destroy the socket. Called internally when we've disconnected.
    // (Thread continues to run)
    if (output != null) {
      println("Disconnected from OPC server");
    }
    socket = null;
    output = pending = null;
  }

  public void run()
  {
    // Thread tests server connection periodically, attempts reconnection.
    // Important for OPC arrays; faster startup, client continues
    // to run smoothly when mobile servers go in and out of range.
    for(;;) {

      if(output == null) { // No OPC connection?
        try {              // Make one!
          socket = new Socket(host, port);
          socket.setTcpNoDelay(true);
          pending = socket.getOutputStream(); // Avoid race condition...
          println("Connected to OPC server");
          sendColorCorrectionPacket();        // These write to 'pending'
          sendFirmwareConfigPacket();         // rather than 'output' before
          output = pending;                   // rest of code given access.
          // pending not set null, more config packets are OK!
        } catch (ConnectException e) {
          dispose();
        } catch (IOException e) {
          dispose();
        }
      }

      // Pause thread to avoid massive CPU load
      try {
        Thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}