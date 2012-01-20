/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the QtLocation module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
***************************************************************************/

#ifndef QDECLARATIVEGEOBOUNDINGBOX_P_H
#define QDECLARATIVEGEOBOUNDINGBOX_P_H

#include "qdeclarativegeoboundingarea_p.h"
#include "qdeclarativecoordinate_p.h"
#include <qgeoboundingbox.h>

#include <QtCore>
#include <QtDeclarative/qdeclarative.h>

QT_BEGIN_NAMESPACE

class QDeclarativeGeoBoundingBox : public QDeclarativeGeoBoundingArea
{
    Q_OBJECT

    Q_PROPERTY(QGeoBoundingBox box READ box WRITE setBox)
    Q_PROPERTY(QDeclarativeCoordinate* bottomLeft READ bottomLeft WRITE setBottomLeft NOTIFY bottomLeftChanged)
    Q_PROPERTY(QDeclarativeCoordinate* bottomRight READ bottomRight WRITE setBottomRight NOTIFY bottomRightChanged)
    Q_PROPERTY(QDeclarativeCoordinate* topLeft READ topLeft WRITE setTopLeft NOTIFY topLeftChanged)
    Q_PROPERTY(QDeclarativeCoordinate* topRight READ topRight WRITE setTopRight NOTIFY topRightChanged)
    Q_PROPERTY(QDeclarativeCoordinate* center READ center WRITE setCenter NOTIFY centerChanged)
    Q_PROPERTY(double height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(double width READ width WRITE setWidth NOTIFY widthChanged)

public:
    explicit QDeclarativeGeoBoundingBox(QObject* parent = 0);
    explicit QDeclarativeGeoBoundingBox(const QGeoBoundingBox &box, QObject *parent = 0);
    void setBox(const QGeoBoundingBox& box);
    QGeoBoundingBox box();
    virtual QGeoBoundingArea *area() const;

    Q_INVOKABLE bool contains(QDeclarativeCoordinate* coordinate);
    QDeclarativeCoordinate* bottomLeft();
    void setBottomLeft(QDeclarativeCoordinate* coordinate);
    QDeclarativeCoordinate* bottomRight();
    void setBottomRight(QDeclarativeCoordinate* coordinate);
    QDeclarativeCoordinate* topLeft();
    void setTopLeft(QDeclarativeCoordinate* coordinate);
    QDeclarativeCoordinate* topRight();
    void setTopRight(QDeclarativeCoordinate* coordinate);
    QDeclarativeCoordinate* center();
    void setCenter(QDeclarativeCoordinate* coordinate);
    double height();
    void setHeight(double height);
    double width();
    void setWidth(double width);

signals:
    void bottomLeftChanged();
    void bottomRightChanged();
    void topLeftChanged();
    void topRightChanged();
    void centerChanged();
    void heightChanged();
    void widthChanged();

private slots:
    void coordinateChanged();

private:
    enum SkipProp {
        SkipNone,
        SkipBottomLeft,
        SkipBottomRight,
        SkipTopLeft,
        SkipTopRight,
        SkipCenter
    };
    void synchronizeDeclarative(const QGeoBoundingBox &old, SkipProp skip);

private:
    QDeclarativeCoordinate *m_bottomLeft;
    QDeclarativeCoordinate *m_bottomRight;
    QDeclarativeCoordinate *m_topLeft;
    QDeclarativeCoordinate *m_topRight;
    QDeclarativeCoordinate *m_center;
    QGeoBoundingBox m_box;
    double m_width;
    double m_height;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QDeclarativeGeoBoundingBox)

#endif // QDECLARATIVEGEOBOUNDINGBOX_P_H
