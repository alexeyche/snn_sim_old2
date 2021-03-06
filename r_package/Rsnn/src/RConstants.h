#ifndef RCONSTANTS_H
#define RCONSTANTS_H

#include <snnlib/config/constants.h>

#define STRICT_R_HEADERS
#include <Rcpp.h>


//using namespace std;

class RConstants : public Constants {
public:
    RConstants(std::string _const_json) : Constants(_const_json, Constants::FromString) { 
    }
    void print() {
        cout << *this;
    }
};

#endif
