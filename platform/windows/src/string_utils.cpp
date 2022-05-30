#include "string_utils.h"

#include <algorithm> 
#include <cctype>
#include <locale>

#include <Windows.h>

const std::wstring to_wstring(const std::string& narrowString)
{
  int bufferSize = MultiByteToWideChar(CP_UTF8, 0, narrowString.c_str(), (int)narrowString.size(), NULL, 0);
  std::wstring wideString;
  wideString.resize(bufferSize);
  MultiByteToWideChar(CP_UTF8, 0, narrowString.c_str(), (int)narrowString.size(), &wideString[0], bufferSize);
  return wideString;
}

/// Functions below copied from:
/// https://stackoverflow.com/questions/216823/how-to-trim-a-stdstring

// trim from start (in place)
void ltrim(std::string& s) {
  s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
    return !std::isspace(ch);
    }));
}

// trim from end (in place)
void rtrim(std::string& s) {
  s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) {
    return !std::isspace(ch) && ch != '\0';
    }).base(), s.end());
}

// trim from both ends (in place)
void trim(std::string& s) {
  ltrim(s);
  rtrim(s);
}

// trim from start (copying)
std::string ltrim_copy(std::string s) {
  ltrim(s);
  return s;
}

// trim from end (copying)
std::string rtrim_copy(std::string s) {
  rtrim(s);
  return s;
}

// trim from both ends (copying)
std::string trim_copy(std::string s) {
  trim(s);
  return s;
}