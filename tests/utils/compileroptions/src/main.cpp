#include "ofMain.h"
#include "ofxUnitTests.h"
#include "ofAppNoWindow.h"



class ofApp: public ofxUnitTestsApp{
public:
    void run(){
        ofLogNotice() << "testing #5520";
        #if __cplusplus >= 201703L
            ofxTest(true,"compiled in C++17 mode");
        #else
            ofxTest(false,"C++17 not available");
        #endif
        ofLogNotice() << "end testing #5520";
    }
};

//========================================================================
int main( ){
    ofInit();
    auto window = make_shared<ofAppNoWindow>();
    auto app = make_shared<ofApp>();
    // this kicks off the running of my app
    // can be OF_WINDOW or OF_FULLSCREEN
    // pass in width and height too:
    ofRunApp(window, app);
    return ofRunMainLoop();


}

