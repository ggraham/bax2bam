// Author: Derek Barnett

#include <string>
#include <vector>

#include <pbbam/BamRecord.h>

#include <pbdata/SMRTSequence.hpp>

void RemoveFile(const std::string& filename);
void RemoveFiles(const std::vector<std::string>& filenames);

int RunBax2Bam(const std::vector<std::string>& baxFilenames,
               const std::string& outputType,
               const std::string& additionalArgs = std::string());
