/*
Simplest Kernel: print an 'X' on the top left corner of the screen
*/

void dummy_function(){

}

void main(){

  char* video_memory = (char*) 0xb8000;

  *video_memory = 'X';
}
