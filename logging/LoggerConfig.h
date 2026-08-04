#pragma once

// Output destinations
#define EB_LOG_WRITE_TO_FILE              1
#define EB_LOG_WRITE_TO_CONSOLE           0

// Entry fields
#define EB_LOG_INCLUDE_TIMESTAMP          1
#define EB_LOG_INCLUDE_CATEGORY           1
#define EB_LOG_INCLUDE_PROCESS_ID         1
#define EB_LOG_INCLUDE_THREAD_ID          1
#define EB_LOG_INCLUDE_SOURCE_LOCATION    1
#define EB_LOG_INCLUDE_FUNCTION_NAME      1

// Behavior
#define EB_LOG_FLUSH_EVERY_MESSAGE        1
#define EB_LOG_REGISTER_CATEGORIES        1
#define EB_LOG_INDENT_MULTILINE_MESSAGES  1

// Optional verbose-debug category
#define EB_LOG_ENABLE_HEAVY_DEBUG         0