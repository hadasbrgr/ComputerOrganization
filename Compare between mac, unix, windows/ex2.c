//hadas berger

#include <stdio.h>
#include <string.h>

void mission1(FILE **sourceFile, FILE **newFileWriteTo, int swapFlag);
void tempMethodUnixMac(FILE **sourceFile, FILE **newFile, char *flagSource, int swapFlag);
void tempMethodWinTOmacOrUnix(FILE **sourceFile, FILE **newFile, char *newFileFlag, int swapFlag);
void tempUnixOrMacToWin(FILE** sourceFile, FILE** newFile,char* flagSource,int swapFlag);
void mission2(FILE **sourceFileToRead, FILE **newFileToWrite, char *flagSource, char *newFileFlag, int swapFlag);
void mission3(FILE **sourceFile, FILE **newFile, char *flagSource, char *newFileFlag, char *byteOrderFlag);

/**
 * The function compare between the char and return the significant place
 * @param buffer
 * @param flagToCompare
 * @return the important value
 */
int check(char buffer[2],char flagToCompare[2]) {
    if (buffer[0] == flagToCompare[0])
        return 0;
    else if(buffer[1] == flagToCompare[0])
        return 1;
}
/**
 * The function get File , and copy him to a new file.
 * If "swapFlag" is on- we need to swap all 2 byte.
 * @param sourceFile - the file source to read
 * @param newFileWriteTo - the file to write in
 * @param swapFlag 1- if we need to do swap. 0-otherwise
 */
void mission1(FILE **sourceFile, FILE **newFileWriteTo, int swapFlag) {
    char buffer[2] ,temp;
    while (0 != fread(buffer, sizeof(char) * 2, 1, *sourceFile) ){
        if(swapFlag==0)
            fwrite(buffer, sizeof(char) * 2, 1, *newFileWriteTo);
        else{ // swap case
            temp=buffer[1];
            buffer[1]=buffer[0];
            buffer[0]=temp;
            fwrite(buffer,sizeof(char)*2,1,*newFileWriteTo);
        }
    }
}
/**
 * The function compare the flags and send to the matching function.
 * @param sourceFile  -the file source to read
 * @param newFile - the file to write in
 * @param flagSource - the type to text
 * @param newFileFlag - the type to text to change to
 * @param swapFlag 1- if we need to do swap. 0-otherwise
 */
void mission2(FILE **sourceFileToRead, FILE **newFileToWrite, char *flagSource, char *newFileFlag, int swapFlag){
    //if we need to copy to file with the same type.
    if(strcmp(flagSource,newFileFlag)==0){
        mission1(sourceFileToRead, newFileToWrite, swapFlag);
        //if we need to copy from unix to mac to mac to unix.
    }else if((strcmp(flagSource,"-unix")==0&&strcmp(newFileFlag,"-mac")==0) ||
             (strcmp(newFileFlag,"-unix")==0&&strcmp(flagSource,"-mac")==0)){
        tempMethodUnixMac(sourceFileToRead, newFileToWrite, flagSource, swapFlag);
        //if we need to copy from win to mac or to unix
    }else if((strcmp(flagSource,"-win")==0&&strcmp(newFileFlag,"-mac")==0) ||
             (strcmp(flagSource,"-win")==0&&strcmp(newFileFlag,"-unix")==0)){
        tempMethodWinTOmacOrUnix(sourceFileToRead, newFileToWrite, newFileFlag, swapFlag);
        //if we need to copy from unix ro mac to win
    }else if((strcmp(flagSource,"-unix")==0&&strcmp(newFileFlag,"-win")==0) ||
             (strcmp(flagSource,"-mac")==0&&strcmp(newFileFlag,"-win")==0)){
        tempUnixOrMacToWin(sourceFileToRead,newFileToWrite,flagSource,swapFlag);
    }
}
/**
 * The function convert from unix/mac to the other type.
 * When we get to a "new line" we send to temp function that return if is
 * big/little endian and return the correct place of the tav.
 * @param sourceFile- the file of the input source to read
 * @param newFile- the file of the output file to write
 * @param flagSource - the type to text
 * @param swapFlag 1- if we need to do swap. 0-otherwise
 */
void tempMethodUnixMac(FILE **sourceFile, FILE **newFile, char *flagSource, int swapFlag) {
    int valueIndex = 0;
    char buffer[2], sourceSign[1], otherSign[1],temp;
    if (strcmp(flagSource, "-unix") == 0) {
        sourceSign[0] = '\n';
        otherSign[0] = '\r';
    } else if (strcmp(flagSource, "-mac") == 0) {
        sourceSign[0] = '\r';
        otherSign[0] = '\n';
    }
    while (0 != fread(buffer, (sizeof(char) * 2), 1, *sourceFile)) {
        if (buffer[0] == sourceSign[0] || buffer[1] == sourceSign[0]) {
            //replace the valueIndex to the otherSign.
            valueIndex = check(buffer,sourceSign);
            buffer[valueIndex] = otherSign[0];
        }
        if (swapFlag == 0) {
            fwrite(buffer, sizeof(char) * 2, 1, *newFile);
        } else { //swap case
            temp=buffer[1];
            buffer[1]=buffer[0];
            buffer[0]=temp;
            fwrite(buffer,sizeof(char)*2,1,*newFile);
        }
    }
}
/**
 *The function convert from win to mac or unix type.
 * We go over the file with two pointers-
 * prev and current. When prev equal to '\r' and current to '\n'
 * we know we need to convert this to the new input flag.
 * @param sourceFile- the file of the input source to read
 * @param newFile - the file of the output file to write
 * @param newFileFlag - the type to change for.
 * @param swapFlag 1- if we need to do swap. 0-otherwise
 */
void tempMethodWinTOmacOrUnix(FILE **sourceFile, FILE **newFile, char *newFileFlag, int swapFlag) {
    int valueIndex = 0, otherIndex = 0, flag = 0;
    char current[2], sourceSign[1], tempFlag[1], tempSwap;
    tempFlag[0]='\n';
    char *prev = NULL;
    if (strcmp(newFileFlag, "-unix") == 0) {
        sourceSign[0] = '\n';
    } else {
        sourceSign[0] = '\r';
    }
    //we use prev and current to know when we arrive to the "\n\r".
    while (0 != fread(current, sizeof(char) * 2, 1, *sourceFile)) {
        if (swapFlag == 0) {
            if (prev != NULL && ((current[0] == '\n')||(current[1] == '\n') )) {
                valueIndex = check(current,tempFlag);
                current[valueIndex] = sourceSign[0];
                fwrite(current, sizeof(current), 1, *newFile);
                flag = 1;
            }
            //we go over if the char is '\n'.
            if (flag == 1) {
                flag = 0;
            } else {
                if ((current[0] != '\r')&&(current[1] != '\r'))
                    fwrite(current, sizeof(current), 1, *newFile);
            }
        } else { //swap case
            if (prev != NULL && ((current[0] == '\n')||(current[1] == '\n') )) {
                valueIndex = check(current,tempFlag);
                otherIndex=!check(current,tempFlag);
                //swap the byte
                current[otherIndex] = sourceSign[0];
                current[valueIndex] = '\000';
                fwrite(current, sizeof(current), 1, *newFile);
                flag = 1;
            }
            if (flag == 1) {
                flag = 0;
            } else {
                if ((current[0] != '\r')&&(current[1] != '\r')) {
                    tempSwap=current[1];
                    current[1]=current[0];
                    current[0]=tempSwap;
                    fwrite(current,sizeof(char)*2,1,*newFile);
                }
            }
        }
        prev = current;
    }
}
/**
 *The function convert from unix or mac to win. When we read '\n' or '\r' we write '\r\n'
 * and do the opposite if we need to do swap.
 * @param sourceFile - the file of the input source to read
 * @param newFile - the file of the output file to write
 * @param flagSource - the type to text
 * @param swapFlag 1- if we need to do swap. 0-otherwise
 */
void tempUnixOrMacToWin(FILE** sourceFile, FILE** newFile,char* flagSource,int swapFlag) {
    int valueIndex = 0, otherIndex = 0;
    char buffer[2], sourceSign[1];
    if (strcmp(flagSource, "-unix") == 0)
        sourceSign[0] = '\n';
    else
        sourceSign[0] = '\r';
    while (0 != fread(buffer, sizeof(char) * 2, 1, *sourceFile)) {
        //check big/little endian.
        if (swapFlag == 0) {
            if (buffer[0] == sourceSign[0] || buffer[1] == sourceSign[0]) { // big or little
                if (buffer[1] == sourceSign[0]) {
                    char one[2], two[2];
                    one[1] = '\r';
                    one[0] = '\000';
                    two[1] = '\n';
                    two[0] = '\000';
                    fwrite(one, sizeof(char) * 2, 1, *newFile);
                    fwrite(two, sizeof(char) * 2, 1, *newFile);
                } else {
                    fwrite("\r", sizeof(char) * 2, 1, *newFile);
                    fwrite("\n", sizeof(char) * 2, 1, *newFile);
                }
            } else {
                fwrite(buffer, sizeof(char) * 2, 1, *newFile);
            }
        } else { //swap case
            char first[1], second[1];
            if (buffer[0] == sourceSign[0] || buffer[1] == sourceSign[0]) {
                char one[2], two[2];
                valueIndex = check(buffer,sourceSign);
                otherIndex=!check(buffer,sourceSign);
                one[otherIndex] = '\r';
                one[valueIndex] = '\000';
                two[otherIndex] = '\n';
                two[valueIndex] = '\000';
                fwrite(one, sizeof(char) * 2, 1, *newFile);
                fwrite(two, sizeof(char) * 2, 1, *newFile);
            } else {
                //replace place
                first[0] = buffer[0];
                second[0] = buffer[1];
                fwrite(second, 1, 1, *newFile);
                fwrite(first, 1, 1, *newFile);
            }
        }
    }
}
/**
 * The function check the "byteOrderFlag" and send with the matching flag to the matching function.
 * @param sourceFile - the name of the input source to read
 * @param newFile - the name of the output file to write
 * @param flagSource - the type to text
 * @param newFileFlag - the type to text to change to
 * @param byteOrderFlag - the flag "keep" or "swap"
 */
void mission3(FILE **sourceFile, FILE **newFile, char *flagSource, char *newFileFlag, char *byteOrderFlag) {
    //"keep"- do the same without changing.
    if (strcmp(byteOrderFlag, "-keep") == 0) {
        mission2(sourceFile, newFile, flagSource, newFileFlag, 0);
        //"swap"- swap the byte
    } else if (strcmp(byteOrderFlag, "-swap") == 0) {
        mission2(sourceFile, newFile, flagSource, newFileFlag, 1);
    }
}
/*
 * The function get argument and according to the input send to temp function.
 * In addition, the function check edge cases.
 */
int main(int arg, char **argv) {
    if(arg>2) {
        //if the user forget to send source/new file.
        if (!(strstr(argv[1], ".")&& strstr(argv[2], "."))|| arg==2 || arg==4) {
        } else {
            if ((arg > 4) && !(strcmp(argv[4], "-keep") != 0 && strcmp(argv[4], "-swap") != 0)) {
            } else {
                FILE *source = fopen(argv[1], "rb");
                if (!source) {
                    return 0;
                }
                FILE *newFile = fopen(argv[2], "wb");
                if (!newFile) {
                    fclose(source);
                    return 0;
                }
                if (arg == 3)
                    mission1(&source, &newFile, 0);
                else if (arg == 5) {
                    //if the user forget to send flag.
                        mission2(&source, &newFile, argv[3], argv[4], 0);
                } else if (arg == 6) {
                    mission3(&source, &newFile, argv[3], argv[4], argv[5]);
                }

                fclose(newFile);
                fclose(source);
            }
        }
    }
    return 0;
}
