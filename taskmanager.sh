#!/bin/sh

# Build and runs taskmanager. 

# You have to build sbcl Core Image befor runing taskmanager. To do
# that run: `./taskmanager.sh build'
#
# IMPORTANT: You have to rebuild the Core Image each time you add new
# method. 
# 

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin

. /usr/local/www/hunchentoot/htoot.conf

export SBCL_HOME=${SBCL_HOME:-'/usr/local/lib/sbcl'}
export LC_ALL="en_US.UTF-8"

HOME=$(dirname $0)
SBCL=${SBCL:-'/usr/local/bin/sbcl'}

case "$1" in
    # build)
    #     [ -e "${HOME}/sbcl.core" ] && rm "${HOME}/sbcl.core"
    #     ${SBCL} --script "${HT_HOME}/core.lisp"
    #     ;;
    run)
	${SBCL} --core "${HT_CORE}" --script "${HOME}/taskmanager/taskmanager.lisp"
	;;
    *)
	echo "usage: $(basename $0) {build|run}" >&2
	exit 1
	;;
esac

exit 0


# Local Variables:
# mode: sh
# indent-tabs-mode: nil
# End:
