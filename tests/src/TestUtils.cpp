// Author: Derek Barnett

#include "TestData.h"
#include "TestUtils.h"

#include <gtest/gtest.h>
#include <cstdio>
#include <cstdlib>

using namespace PacBio;
using namespace PacBio::BAM;

void RemoveFiles(const std::vector<std::string>& filenames)
{
    for (auto fn : filenames)
        remove(fn.c_str());
}

void RemoveFile(const std::string& filename)
{
    std::vector<std::string> filenames;
    filenames.push_back(filename);
    RemoveFiles(filenames);
}

int RunBax2Bam(const std::vector<std::string>& baxFilenames,
               const std::string& outputType,
               const std::string& additionalArgs)
{
    std::string convertArgs;
    convertArgs += outputType;
    if (!additionalArgs.empty()) {
        convertArgs += std::string(" ");
        convertArgs += additionalArgs;
    }
    for (auto fn : baxFilenames) {
        convertArgs += std::string(" ");
        convertArgs += fn;
    }

    const std::string& convertCommandLine = tests::Bax2Bam_Exe + std::string(" ") + convertArgs;
    return system(convertCommandLine.c_str());
}
