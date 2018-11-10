# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=(python2_7)

inherit eutils user git-2 python-single-r1

EGIT_REPO_URI="https://github.com/DobyTang/LazyLibrarian.git"

DESCRIPTION="LazyLibrarian is an automated book downloader for SABnzbd."
HOMEPAGE="http://github.com/DobyTang/LazyLibrarian"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	# Create download group
	enewgroup download
	# Create download user, put in download group
	enewuser download -1 -1 -1 download
}

src_install() {
	dodoc README.md

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# AuthorCache patch no longer required 
	#epatch "${FILESDIR}/path.patch" || die
	# Location of log and data files
	keepdir /var/${PN}
	fowners -R download:download /var/${PN}

	keepdir /var/{${PN}/{cache,download},log/${PN}}
	fowners -R download:download /var/{${PN}/{cache,download},log/${PN}}

	insinto /etc/${PN}
	insopts -m0660 -o download -g download
	doins "${FILESDIR}/${PN}.ini"

	# Rotation of log files
	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# wierd stuff ;-)
	last_commit=$(git rev-parse HEAD)
	echo ${last_commit} > version.txt

	insinto /usr/share/${PN}
	doins -r cherrypy data lazylibrarian lib mako LazyLibrarian.py version.txt
	fowners download:download /usr/share/${PN}/version.txt
}

pkg_postinst() {

	# we need to remove .git which old ebuild installed
	if [[ -d "/usr/share/${PN}/.git" ]] ; then
	   ewarn "stale files from previous ebuild detected"
	   ewarn "/usr/share/${PN}/.git removed."
	   ewarn "To ensure proper operation, you should unmerge package and remove directory /usr/share/${PN} and then emerge package again"
	   ewarn "Sorry for the inconvenience"
	   rm -Rf "/usr/share/${PN}/.git"
	fi

	elog "LazyLibrarian has been installed with data directories in /var/${PN}"
	elog
	elog "New user/group download/download has been created"
	elog
	elog "Config file is located in /etc/${PN}/${PN}.ini"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting as daemon!"
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog "Visit http://<host ip>:8181 to configure LazyLibrarian"
	elog "Default web username/password : download/secret"
	elog
}

