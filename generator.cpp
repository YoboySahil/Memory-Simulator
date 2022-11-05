#include <cstdlib>
#include <iostream>
using namespace std;
  
int main()
{
    // This program will create same sequence of
    // random numbers on every program run
    for (int i = 0; i < 101; i++)
        if(rand()%2==1){
            cout<<"rd "<<rand()%4095<<endl;
        }
        else{
            cout<<"wr "<<rand()%4095<<" "<<rand()%1000<<endl;
        }
  
    return 0;
}