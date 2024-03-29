this_makefile := ${lastword ${MAKEFILE_LIST}}
SHELL = /opt/local/bin/bash -o pipefail -o errexit -o nounset
.SECONDARY:
.DEFAULT_GOAL = help

PACKAGE_TARNAME = wrtools-git
prefix = /Users/wr
abs_srcdir = /Users/wr/r/me/git-tools.git
abs_builddir = /Users/wr/r/me/git-tools.git

MKDIR_P = /opt/local/libexec/gnubin/mkdir -p
SED = /usr/bin/sed
git = /opt/local/bin/git
zip = /usr/bin/zip

#HELP:Build a zip file containing this package and all dependencies
#HELP:Usage:
#HELP:    $ make -f zip.mk zip

dist_name_default := ${PACKAGE_TARNAME}-${shell ${git} -C ${abs_srcdir} describe --always --tags}
dist_name = ${dist_name_default}

#HELP:targets:

.PHONY: zip #   Create a zip archive
zip:
	${RM} -r ${abs_builddir}/build/zip
	${git} -C ${abs_srcdir} submodule foreach 'PATH="${abs_builddir}/build/zip/${dist_name}/bin:$$PATH" ${MAKE} -C ${abs_builddir} -f zip.mk zip-package dist_name=${dist_name} zip_package_source=$$PWD zip_package_build=${abs_builddir}/build/zip/$$path zip_package_prefix=${abs_builddir}/build/zip/${dist_name}'
	PATH="${abs_builddir}/build/zip/${dist_name}:$$PATH" ${MAKE}
	PATH="${abs_builddir}/build/zip/${dist_name}:$$PATH" ${MAKE} install prefix=${abs_builddir}/build/zip/${dist_name}
	${RM} -f ${abs_builddir}/build/zip/${dist_name}.zip
	( cd ${abs_builddir}/build/zip && ${zip} -9 -r ${dist_name}.zip ${dist_name} )
	@ printf 'Zip file is %s\n' ${abs_builddir}/build/zip/${dist_name}.zip

# Build and stage a submodule as its own package
.PHONY: zip-package
zip-package:
	${RM} -r ${zip_package_build}
	${MKDIR_P} ${zip_package_build}
	cd ${zip_package_build} && ${zip_package_source}/configure --prefix=${zip_package_prefix}
	${MAKE} -C ${zip_package_build}
	${MAKE} -C ${zip_package_build} install

.PHONY: clean #  Remove build products
clean:
	${MAKE} clean
	${RM} -r ${abs_builddir}/build/zip

#############################################################################
# make help: this must be the last target

.PHONY: help #   Print this help
help:
	@ ${SED} -e '/^\.PHONY:/s/^\.PHONY: *\([^ #]*\) *\#\( *\)\([^ ].*\)/\2\1: \3/p;/^[^#]*#HELP:/s/[^#]*#HELP:\(.*\)/\1/p;d' ${this_makefile}

# don't put anything after this
