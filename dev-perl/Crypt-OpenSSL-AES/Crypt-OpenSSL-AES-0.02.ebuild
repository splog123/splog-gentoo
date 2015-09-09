# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.280.0.ebuild,v 1.1 2011/08/30 18:32:44 tove Exp $

EAPI=5

MODULE_AUTHOR=TTAR
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Crypt::OpenSSL::AES module for perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 amd64-linux x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=" dev-libs/openssl
	dev-lang/perl"
DEPEND="${RDEPEND}"

SRC_TEST="do"

