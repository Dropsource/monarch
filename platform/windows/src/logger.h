#pragma once
#include <string>

const std::wstring windows_app = L"windows_app: ";

enum class LogLevel: int
{
	ALL = 0,
	FINEST = 300,
	FINER = 400,
	FINE = 500,
	CONFIG = 700,
	INFO = 800,
	WARNING = 900,
	SEVERE = 1000,
	SHOUT = 1200,
	OFF = 2000
};

LogLevel logLevelFromString(const std::string& levelString);

std::wstring logLevelToString(const LogLevel& level);

extern LogLevel defaultLogLevel;

class Logger {
	LogLevel _level;

public:
	std::wstring name;

	LogLevel getLevel();
	void setLevel(LogLevel newLevel);

	Logger(const std::wstring& name);

	bool isLoggable(LogLevel value);

	void log(LogLevel logLevel, const std::string& message);
	void log(LogLevel logLevel, const std::wstring& message);

	void finest(const std::string& message);
	void finer(const std::string& message);
	void fine(const std::string& message);
	void config(const std::string& message);
	void info(const std::string& message);
	void warning(const std::string& message);
	void severe(const std::string& message);
	void shout(const std::string& message);

	void finest(const std::wstring& message);
	void finer(const std::wstring& message);
	void fine(const std::wstring& message);
	void config(const std::wstring& message);
	void info(const std::wstring& message);
	void warning(const std::wstring& message);
	void severe(const std::wstring& message);
	void shout(const std::wstring& message);
};