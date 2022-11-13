#include <cstdlib>
#include <iostream>
using namespace std;
const int N = 1e4+10;
  
int main()
{
    // This program will create same sequence of
    // random numbers on every program run
    for (int i = 0; i < N; i++)
        if(rand()%2==1){
            cout<<"rd "<<rand()%4095<<endl;
        }
        else{
            cout<<"wr "<<rand()%4095<<" "<<rand()%1000<<endl;
        }
  
    return 0;
}