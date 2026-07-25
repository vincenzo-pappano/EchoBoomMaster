#include "FixedAspectRatioWindow.h"

#include <QMargins>
#include <QtMath>

#ifdef Q_OS_WIN
#include <windows.h>
#endif

FixedAspectRatioWindow::FixedAspectRatioWindow(QWindow *parent)
    : QQuickWindow(parent)
{
}

qreal FixedAspectRatioWindow::aspectRatio() const
{
    return m_aspectRatio;
}

void FixedAspectRatioWindow::setAspectRatio(qreal ratio)
{
    if (ratio <= 0.0 || qFuzzyCompare(m_aspectRatio, ratio))
        return;

    m_aspectRatio = ratio;
    emit aspectRatioChanged();
}

bool FixedAspectRatioWindow::nativeEvent(const QByteArray &eventType,
                                    void *message,
                                    long *result)
{
#ifdef Q_OS_WIN

    MSG *msg = static_cast<MSG *>(message);

    if (msg->message == WM_SIZING) {
        RECT *rect = reinterpret_cast<RECT *>(msg->lParam);

        /*
         * WM_SIZING provides the complete window size, including the
         * title bar and borders. QML width/height represent the client area.
         */
        const QMargins margins = frameMargins();

        const int frameWidth =
            margins.left() + margins.right();

        const int frameHeight =
            margins.top() + margins.bottom();

        int clientWidth =
            rect->right - rect->left - frameWidth;

        int clientHeight =
            rect->bottom - rect->top - frameHeight;

        clientWidth = qMax(clientWidth, 1);
        clientHeight = qMax(clientHeight, 1);

        bool widthControlsSize = true;

        switch (msg->wParam) {
        case WMSZ_LEFT:
        case WMSZ_RIGHT:
            // Horizontal edge dragged: width controls height.
            widthControlsSize = true;
            break;

        case WMSZ_TOP:
        case WMSZ_BOTTOM:
            // Vertical edge dragged: height controls width.
            widthControlsSize = false;
            break;

        default:
            /*
             * A corner is being dragged. Determine which dimension
             * changed the most and use that as the controlling dimension.
             */
            const qreal widthChange =
                qAbs(clientWidth - width()) /
                qreal(qMax(width(), 1));

            const qreal heightChange =
                qAbs(clientHeight - height()) /
                qreal(qMax(height(), 1));

            widthControlsSize = widthChange >= heightChange;
            break;
        }

        if (widthControlsSize) {
            clientHeight =
                qRound(clientWidth / m_aspectRatio);
        } else {
            clientWidth =
                qRound(clientHeight * m_aspectRatio);
        }

        const int targetWidth =
            clientWidth + frameWidth;

        const int targetHeight =
            clientHeight + frameHeight;

        switch (msg->wParam) {
        case WMSZ_LEFT:
        case WMSZ_RIGHT: {
            // Keep the window vertically centered.
            const int centerY =
                (rect->top + rect->bottom) / 2;

            rect->top = centerY - targetHeight / 2;
            rect->bottom = rect->top + targetHeight;
            break;
        }

        case WMSZ_TOP:
        case WMSZ_BOTTOM: {
            // Keep the window horizontally centered.
            const int centerX =
                (rect->left + rect->right) / 2;

            rect->left = centerX - targetWidth / 2;
            rect->right = rect->left + targetWidth;
            break;
        }

        case WMSZ_TOPLEFT:
            rect->left = rect->right - targetWidth;
            rect->top = rect->bottom - targetHeight;
            break;

        case WMSZ_TOPRIGHT:
            rect->right = rect->left + targetWidth;
            rect->top = rect->bottom - targetHeight;
            break;

        case WMSZ_BOTTOMLEFT:
            rect->left = rect->right - targetWidth;
            rect->bottom = rect->top + targetHeight;
            break;

        case WMSZ_BOTTOMRIGHT:
            rect->right = rect->left + targetWidth;
            rect->bottom = rect->top + targetHeight;
            break;
        }

        *result = TRUE;
        return true;
    }

#endif

    return QQuickWindow::nativeEvent(
        eventType,
        message,
        result);
}