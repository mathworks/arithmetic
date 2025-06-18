#include "mex.hpp"
#include "mexAdapter.hpp"

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function {
public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {
        TypedArray<double> doubleArray = std::move(inputs[0]);
        for (auto& elem : doubleArray) {
            elem = 1/elem;
        }
        outputs[0] = doubleArray;
    }
};
