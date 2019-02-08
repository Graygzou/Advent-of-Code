//all the #includes:
#include <iostream>
#include <fstream>
#include <string.h>
#include <cmath>
using namespace std;

int main() {
  int res = 0;

  std::string line;
  ifstream myfile ("input.txt");
  if (myfile.is_open())
  {
    while ( getline (myfile, line) )
    {
      cout << line << '\n';
      int index = 0;
      int maxLimit = 0;
      cout << line.substr(index, 1) << endl;
      std::string lastNumFound = "";
      cout << "Debut" << endl;
      do
      {
        cout << "index = " << index << '\n';

        std::string currentNumFound = line.substr(index, 1);
        if (currentNumFound != lastNumFound)
        {
          //cout << "uno " << index+1 << endl;
          maxLimit = index+1 == line.length() ? 0 : index+1;
          //cout << "dos " << maxLimit << endl;
          if (stoi(currentNumFound) == stoi(line.substr(maxLimit, 1)))
          {
            //cout << "+" << stoi(currentNumFound) << endl;
            res += stoi(currentNumFound);
            index++;
            lastNumFound = currentNumFound;
          }
        }
        index++;
        index = index % line.length();
      } while(index != 0);
      cout << "Result" << res << endl;
    }
    myfile.close();
  }
  cout << "Result : " << res << endl;
}
