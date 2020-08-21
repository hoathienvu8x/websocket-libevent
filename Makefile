$(shell sh build.sh 1>&2)
ver = debug


ALLBIN = chat_release chat_debug
OBJDIR = ./OBJS
DEMODIR = ./demo
LWS_INCLUDE = base64.h websocket.h frame.h connection.h tools.h
LWS_LIB = libwebsocket.a
LWS_LIB_OBJS = $(OBJDIR)/base64.o $(OBJDIR)/websocket.o $(OBJDIR)/frame.o $(OBJDIR)/connection.o
VPATH = $(OBJDIR):$(DEMODIR)
#vpath %.o $(OBJDIR)


ifeq ($(ver), debug)
ALL: chat_debug
CXXFLAGS = -c -g -Ddebug
OBJS = demo.o websocket.o base64.o connection.o user.o frame.o
BIN = chat_debug
else
ALL: chat_release
CXXFLAGS = -c -O3
OBJS = demo.ro websocket.ro base64.ro connection.ro user.ro frame.ro
BIN = chat_release
endif


INCLUDE = -I./deps/libevent-2.1.12-stable -I./deps/libevent-2.1.12-stable/include -I./deps/libevent-2.1.12-stable/compact
LIBRARY = ./deps/libevent-2.1.12-stable/.libs/libevent.a -lcrypto -lssl -lrt \
		  -Wl,-rpath /usr/local/lib


chat_debug: $(OBJS)
	make tmp ver=$(ver)

chat_release: $(OBJS)
	make tmp ver=$(ver)

%.o: %.cpp
	g++ $(CXXFLAGS) $< -o $(OBJDIR)/$@ $(INCLUDE)

%.ro: %.cpp
	g++ $(CXXFLAGS) $< -o $(OBJDIR)/$@ $(INCLUDE)


.PHONY: clean
clean:
	rm -f $(ALLBIN) $(OBJDIR)/*
	rm -f libwebsocket/include/* libwebsocket/lib/*

.PHONY: tmp
tmp: $(OBJS)
	g++ -o $(BIN) $^ $(LIBRARY)
	mkdir -p libwebsocket/include libwebsocket/lib
	cp -f $(LWS_INCLUDE) libwebsocket/include
	ar cr $(LWS_LIB) $(LWS_LIB_OBJS)
	mv -f $(LWS_LIB) libwebsocket/lib
