#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  ((byte) & 0x10 ? '1' : '0'), \
  ((byte) & 0x08 ? '1' : '0'), \
  ((byte) & 0x04 ? '1' : '0'), \
  ((byte) & 0x02 ? '1' : '0'), \
  ((byte) & 0x01 ? '1' : '0') 

int main(){
   printf("Generating a test vector for encoder module. M=32, b=5\n");

   unsigned char datastream[32];
   memset(datastream, 33, sizeof(datastream));

   for(int i=0; i<32; i++){
      unsigned int index = rand()%32;
      while(33 != datastream[index]){
         index++;
         if(32 <= index) index = 0;
      }
      datastream[index] = i;
   }

   for(int i=0; i<32;i++){
      printf("index %d: %d\n", i, datastream[i]);
      if(datastream[i] == 33){
         printf("FAILED TO BUILD DATA ARRAY!\n");
         return -2;
      }
   }

   FILE *fp = fopen("./encoder.vec", "w");
   if(NULL == fp){
      printf("Failed to open file!\n");
      return -1;
   }
   fprintf(fp, "//Test Vectors for Encoder Module\n//Hayden Martz\n//5 bit data values, MSb to LSb:\n");
   for(int i=0; i<32; i++){
      fprintf(fp, BYTE_TO_BINARY_PATTERN, BYTE_TO_BINARY(datastream[i]));
      fprintf(fp, "\n");
   }
   fclose(fp);

   return 0;
}
