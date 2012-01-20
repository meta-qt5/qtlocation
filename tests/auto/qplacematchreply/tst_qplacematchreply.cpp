/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the test suite of the Qt Toolkit.
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

#include <QtCore/QString>
#include <QtTest/QtTest>

#include <QtLocation/QPlaceMatchReply>

QT_USE_NAMESPACE

class TestMatchReply : public QPlaceMatchReply
{
    Q_OBJECT
public:
    TestMatchReply(QObject *parent) : QPlaceMatchReply(parent) {}
    TestMatchReply() {}

    void setPlaces(const QList<QPlace> &places) {
        QPlaceMatchReply::setPlaces(places);
    }

    void setRequest(const QPlaceMatchRequest &request) {
        QPlaceMatchReply::setRequest(request);
    }
};

class tst_QPlaceMatchReply : public QObject
{
    Q_OBJECT

public:
    tst_QPlaceMatchReply();

private Q_SLOTS:
    void constructorTest();
    void typeTest();
    void requestTest();
//    void resultsTest();
};

tst_QPlaceMatchReply::tst_QPlaceMatchReply()
{
}

void tst_QPlaceMatchReply::constructorTest()
{
    QPlaceMatchReply *reply = new TestMatchReply(this);
    QVERIFY(reply->parent() == this);
    delete reply;
}

void tst_QPlaceMatchReply::typeTest()
{
    TestMatchReply *reply = new TestMatchReply(this);
    QVERIFY(reply->type() == QPlaceReply::MatchReply);
    delete reply;
}

void tst_QPlaceMatchReply::requestTest()
{
    TestMatchReply *reply = new TestMatchReply(this);
    QPlaceMatchRequest request;

    QPlace place1;
    place1.setName(QLatin1String("place1"));

    QPlace place2;
    place2.setName(QLatin1String("place2"));

    QList<QPlace> places;
    places << place1 << place2;

    request.setPlaces(places);

    reply->setRequest(request);
    QCOMPARE(reply->request(), request);

    reply->setRequest(QPlaceMatchRequest());
    QCOMPARE(reply->request(), QPlaceMatchRequest());
    delete reply;
}


QTEST_APPLESS_MAIN(tst_QPlaceMatchReply)

#include "tst_qplacematchreply.moc"
