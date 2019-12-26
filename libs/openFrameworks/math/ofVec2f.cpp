#include "math/ofVec2f.h"
#include "math/ofVec3f.h"
#include "math/ofVec4f.h"

ofVec2f::ofVec2f( const ofVec3f& vec ) {
	x = vec.x;
	y = vec.y;
}

ofVec2f::ofVec2f( const ofVec4f& vec ) {
	x = vec.x;
	y = vec.y;
}
