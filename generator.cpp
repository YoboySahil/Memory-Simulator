#include <cstdlib>
#include <iostream>
#include <fstream>
  
int main()
{
    // This program will create same sequence of
    // random numbers on every program run
    std::ofstream code("code.txt");
    int n = 100;
    code<<"{\n";
    for (int i = 0; i < n; i++)
        if(rand()%2==1){
            code<<"rd "<<rand()%4095<<"\n";
        }
        else{
            code<<"wr "<<rand()%4095<<" "<<rand()%100<<"\n";
        }
    code<<"}";
    return 0;
}