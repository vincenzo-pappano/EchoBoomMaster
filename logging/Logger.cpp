#include "Logger.h"
#include "LoggerConfig.h"

#include <QLoggingCategory>

Q_LOGGING_CATEGORY(loggerLog, "eb.logger")

Logger::Logger()
    : m_stream(&m_file)
{
}

Logger::~Logger() = default;

Logger *Logger::self()
{
    static Logger instance;
    return &instance;
}

bool Logger::isReady() const
{
    return m_isReady;
}

QString Logger::fileName() const
{
    return m_file.fileName();
}