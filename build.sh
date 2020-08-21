#!/bin/bash
BASE_DIR=`pwd`
LIBEVENT_PATH="$BASE_DIR/deps/libevent-2.1.12-stable"

DIR=`pwd`
cd "$LIBEVENT_PATH"
if [ ! -f Makefile ]; then
	./configure
	make
fi

if [ ! -f "$LIBEVENT_PATH/.libs/libevent.a" ]; then
	make
fi

cd "$DIR"
