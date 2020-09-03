// Convert two bytes to a 16bit unsined number
uint16_t parseUint16(uint8_t hi, uint8_t lo){
  return (uint16_t)(hi*256 + lo);
}

// Convert two bytes to a 0-655.00 double. Unsigned double. 
// Have to be modified if it is too litle... 
double parseDouble(char hi,char lo){
 return (double) parseUint16(hi,lo)/100.0;
}

// Send a double with a specified type
void sendData(char type,double val){
  Serial.print(type); Serial.println(val);
}

// Send a int with a specified type
void sendData(char type,uint16_t val){
  Serial.print(type); Serial.println(val);
}

// Send a ascii string with a predefined type 'q'
void sendText(char *msg){
  Serial.print("q"); Serial.println(msg);
}

// Read a line from serial port and fill "buffer"... 
int read_line(char* buffer, int bufsize){
   for (int index = 0; index < bufsize; index++) {
    while(Serial.available() == 0){}  
    
    char ch = Serial.read(); // read next character
    //Serial.print(ch); // echo it back: useful with the serial monitor (optional)

    if (ch == '\n') {
      buffer[index] = 0; // end of line reached: null terminate string
      return index; // success: return length of string (zero if string is empty)
    }

    buffer[index] = ch; // Append character to buffer
  } 

  // Reached end of buffer, but have not seen the end-of-line yet.
  // Discard the rest of the line (safer than returning a partial line).

  char ch;
  do {
    // Wait until characters are available
    while (Serial.available() == 0) {
    }
    ch = Serial.read(); // read next character (and discard it)
    //Serial.print(ch); // echo it back
  } while (ch != '\n');

  buffer[0] = 0; // set buffer to empty string even though it should not be used
  return -1; // error: return negative one to indicate the input was too long
}
