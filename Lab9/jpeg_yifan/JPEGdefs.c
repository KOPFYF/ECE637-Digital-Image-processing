#include "JPEGdefs.h"
#include "Htables.h"

int BitSize(int value) {
	int bitsize = 0;

	if (value < 0) {
		value *= -1;
	}
	while (value > 0) {
		bitsize++;
		value >>= 1;
	}

	return bitsize;
}

void VLI_encode(int bitsize, int value, char *block_code) {
	// VLC + VLI
	char VLI[13] = {0};

	if (value < 0) {
		value--; // 8-bit 2's complement 
	}

	for (int i = bitsize - 1; i >= 0; i--) {		
		if (value & 1){  
    		VLI[i] = '1';  
    	}
		else  {
    		VLI[i] = '0';  
		}
		// printf("%d\n",value);
		// printf("%s\n", VLI);
		value >>= 1;
	}
	strcat(block_code, VLI);
}

void ZigZag(int ** img, int y, int x, int *zigline) {
	for (int i = 0; i < 8; i++) {
		for (int j = 0; j < 8; j++) {
			zigline[Zig[i][j]] = img[y+i][x+j];
		}
	}
}

void DC_encode(int dc_value, int prev_value, char *block_code) {
	int diff_value = dc_value - prev_value;
	// printf("diff_value = %d\n", diff_value);
	int size = BitSize(diff_value);
	strcat(block_code, dcHuffman.code[size]);
	VLI_encode(size, diff_value, block_code);
}

void AC_encode(int *zigzag, char *block_code) {
	int idx = 1;
	int zerocnt = 0;
	int bitsize;

	while (idx < 64) {
		if (zigzag[idx] == 0) {
			zerocnt++;
		} 
		else {
			for (; zerocnt > 15; zerocnt -= 16){
				strcat(block_code, acHuffman.code[15][0]);
			}

			bitsize = BitSize(zigzag[idx]);
			strcat(block_code, acHuffman.code[zerocnt][bitsize]);
			VLI_encode(bitsize, zigzag[idx], block_code);
			zerocnt = 0;
			// fprintf(stdout, "debug in AC_encode()\n");
		}
		idx++;
	}
	if (zerocnt) {
		strcat(block_code, acHuffman.code[0][0]);
	}
}

void Block_encode(int prev_value, int *zigzag, char *block_code) {
	
	DC_encode(zigzag[0], prev_value, block_code);
	AC_encode(zigzag, block_code);
}

int Convert_encode(char *block_code, unsigned char *byte_code) {
	int len = strlen(block_code);
	int bytes = len / 8;
	int idx = 0;

	for (int i = 0; i < bytes; i++) {
		for (int j = 0; j < 8; j++) {
			byte_code[idx] <<= 1;

			if (block_code[i*8 + j] == '1') {
				byte_code[idx]++;
			}
		}

		if (byte_code[idx] == 0xff) {
			byte_code[++idx] = 0x00;
			bytes++;
		}
		idx++;
	}
	strcpy(block_code, block_code + len / 8 * 8);

	return bytes;
}

unsigned char Zero_pad(char *block_code) {
	unsigned char byte_code;
	int len = strlen(block_code);

	for (int i = 0; i < len; i++) {
		byte_code <<= 1;

		if (block_code[i] == '1') {
			byte_code++;
		}
	}
	byte_code <<= (8 - len);

	return byte_code;
}