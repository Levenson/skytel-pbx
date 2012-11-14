PORTNAME=       skytelport
PORTVERSION=    1.0
CATEGORIES=     misc

MASTER_SITES=
DISTFILES=

MAINTAINER=Aleksey Abramov

RUN_DEPENDS=spandsp-devel:${PORTSDIR}/comms/spandsp-devel \
	    libxml2:${PORTSDIR}/textproc/libxml2 \
	    sqlite3p:${PORTSDIR}/databases/sqlite3 \
	    lame:${PORTSDIR}/audio/lame \
	    zsh:${PORTSDIR}/shells/zsh \
	    mc:${PORTSDIR}/misc/mc \
	    portaudit:${PORTSDIR}/ports-mgmt/portaudit \
	    portupgrade:${PORTSDIR}/ports-mgmt/portupgrade \
	    zoneinfo:${PORTSDIR}/misc/zoneinfo \
	    git:${PORTSDIR}/devel/git

NO_WRKSUBDIR=   YES
NO_BUILD=       YES

do-install:

.include <bsd.port.mk>
