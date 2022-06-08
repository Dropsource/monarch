#include "logger.h"
#include <iostream>

using namespace std::literals::string_literals;


LogLevel defaultLogLevel = LogLevel::ALL;

LogLevel logLevelFromString(const std::string& levelString) {
    if (levelString == "ALL") {
        return LogLevel::ALL;
    }
    if (levelString == "FINEST") {
        return LogLevel::FINEST;
    }
    if (levelString == "FINER") {
        return LogLevel::FINER;
    }
    if (levelString == "FINE") {
        return LogLevel::FINE;
    }
    if (levelString == "CONFIG") {
        return LogLevel::CONFIG;
    }
    if (levelString == "INFO") {
        return LogLevel::INFO;
    }
    if (levelString == "WARNING") {
        return LogLevel::WARNING;
    }
    if (levelString == "SEVERE") {
        return LogLevel::SEVERE;
    }
    if (levelString == "SHOUT") {
        return LogLevel::SHOUT;
    }
    if (levelString == "OFF") {
        return LogLevel::OFF;
    }
    return LogLevel::ALL;
}

std::wstring logLevelToString(const LogLevel& level) {
    switch (level)
    {
    case LogLevel::ALL: {
        return L"ALL";
    }
    case LogLevel::FINEST: {
        return L"FINEST";
    }
    case LogLevel::FINER: {
        return L"FINER";
    }
    case LogLevel::FINE: {
        return L"FINE";
    }
    case LogLevel::CONFIG: {
        return L"CONFIG";
    }
    case LogLevel::INFO: {
        return L"INFO";
    }
    case LogLevel::WARNING: {
        return L"WARNING";
    }
    case LogLevel::SEVERE: {
        return L"SEVERE";
    }
    case LogLevel::SHOUT: {
        return L"SHOUT";
    }
    case LogLevel::OFF: {
        return L"OFF";
    }
    default:
        return L"UNKNOWN";
    }
}

LogLevel Logger::getLevel() {
    return Logger::_level;
}

void Logger::setLevel(LogLevel newLevel) {
    Logger::_level = newLevel;
}

Logger::Logger(const std::wstring& name) {
    Logger::name = name;
}

bool Logger::isLoggable(LogLevel value) {
    return value >= Logger::_level;
}

void Logger::log(LogLevel logLevel, const std::string& message) {
    Logger::log(logLevel, std::wstring(message.begin(), message.end()));
}

void Logger::log(LogLevel logLevel, const std::wstring& message) {
    if (Logger::isLoggable(logLevel)) {
        std::wstring levelString(logLevelToString(logLevel));
        std::wcout << windows_app << levelString << L" [" << Logger::name << L"] " << message << std::endl;
    }
}


void Logger::finest(const std::string& message) {
    Logger::log(LogLevel::FINEST, message);
}
void Logger::finer(const std::string& message) {
    Logger::log(LogLevel::FINER, message);
}
void Logger::fine(const std::string& message) {
    Logger::log(LogLevel::FINE, message);
}
void Logger::config(const std::string& message) {
    Logger::log(LogLevel::CONFIG, message);
}
void Logger::info(const std::string& message) {
    Logger::log(LogLevel::INFO, message);
}
void Logger::warning(const std::string& message) {
    Logger::log(LogLevel::WARNING, message);
}
void Logger::severe(const std::string& message) {
    Logger::log(LogLevel::SEVERE, message);
}
void Logger::shout(const std::string& message) {
    Logger::log(LogLevel::SHOUT, message);
}


void Logger::finest(const std::wstring& message) {
    Logger::log(LogLevel::FINEST, message);
}
void Logger::finer(const std::wstring& message) {
    Logger::log(LogLevel::FINER, message);
}
void Logger::fine(const std::wstring& message) {
    Logger::log(LogLevel::FINE, message);
}
void Logger::config(const std::wstring& message) {
    Logger::log(LogLevel::CONFIG, message);
}
void Logger::info(const std::wstring& message) {
    Logger::log(LogLevel::INFO, message);
}
void Logger::warning(const std::wstring& message) {
    Logger::log(LogLevel::WARNING, message);
}
void Logger::severe(const std::wstring& message) {
    Logger::log(LogLevel::SEVERE, message);
}
void Logger::shout(const std::wstring& message) {
    Logger::log(LogLevel::SHOUT, message);
}
