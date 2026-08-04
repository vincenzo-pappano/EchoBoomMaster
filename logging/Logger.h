#pragma once

#include <QFile>
#include <QMutex>
#include <QSet>
#include <QString>
#include <QTextStream>
#include <QtGlobal>

class Logger final
{
public:
    static Logger *self();

    bool isReady() const;
    QString fileName() const;

private:
    Logger();
    ~Logger();

    Q_DISABLE_COPY(Logger)

private:
    QFile m_file;
    QTextStream m_stream;
    QMutex m_mutex;
    QSet<QString> m_registeredCategories;

    bool m_isReady = false;
};