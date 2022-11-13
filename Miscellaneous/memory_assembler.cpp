#include <iostream>
#include <fstream>
#include <map>
#include <bitset>

int main()
{
    std::ifstream sourcecode("code.txt");//memory read/write source code
    std::ofstream bincode("code.bin");//destination file of assembled code in binary (machine language)
    
    //mapping of instruction to binary code 
    std::map<std::string,std::string> codemap = {{"rd","0001"},{"wr","1111"}};

    if(sourcecode.is_open()) 
    {  
        std::string line;
        do
        {
            sourcecode>>line;
        }while(line!="{");
        sourcecode>>line;
        while(line!="}")
        {
            std::string ic = codemap[line];
            if(codemap[line]=="0001") 
            {//Read (rd) instruction
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<12>(i).to_string());
                ic=ic+(std::bitset<32>(0).to_string());
            }
            else if(codemap[line]=="1111") 
            {//Write (wr) instuction
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<12>(i).to_string());
                sourcecode>>i;
                ic=ic+(std::bitset<32>(i).to_string());
            }
            bincode<<ic<<std::endl;
            sourcecode>>line;
        }
        bincode<<(std::bitset<48>(0).to_string());
        sourcecode.close();
        bincode.close();
    }
    else
    {//In case the source code file does not exist
        std::cout<<"Code File Not Found";
        return 1;
    }
    return 0;
}