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
****************************************************************************/

#ifndef QDECLARATIVEGEOMAPMOUSEEVENT_H
#define QDECLARATIVEGEOMAPMOUSEEVENT_H

#include "qdeclarativecoordinate_p.h"

#include <QtDeclarative/qdeclarative.h>

QT_BEGIN_NAMESPACE

class QDeclarativeGeoMapMouseEvent : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool accepted READ accepted WRITE setAccepted)
    Q_PROPERTY(int button READ button)
    Q_PROPERTY(int buttons READ buttons)
    Q_PROPERTY(int modifiers READ modifiers)
    Q_PROPERTY(bool wasHeld READ wasHeld)
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(QDeclarativeCoordinate* coordinate READ coordinate)

public:
    QDeclarativeGeoMapMouseEvent(QObject *parent = 0);
    ~QDeclarativeGeoMapMouseEvent();

    void setAccepted(bool accepted);
    bool accepted() const;

    void setButton(int button);
    int button() const;

    void setButtons(int buttons);
    int buttons() const;

    void setModifiers(int modifiers);
    int modifiers() const;

    void setWasHeld(bool wasHeld);
    bool wasHeld() const;

    void setX(int x);
    int x() const;

    void setY(int y);
    int y() const;

    void setCoordinate(QGeoCoordinate coordinate);
    QDeclarativeCoordinate* coordinate();

private:
    bool accepted_;
    int button_;
    int modifiers_;
    bool wasHeld_;
    int x_;
    int y_;
    int buttons_;
    QDeclarativeCoordinate coordinate_;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QT_PREPEND_NAMESPACE(QDeclarativeGeoMapMouseEvent));

#endif
