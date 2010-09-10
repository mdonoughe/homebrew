require 'formula'

class Nam <Formula
  url 'http://downloads.sourceforge.net/project/nsnam/nam-1/1.14/nam-1.14.tar.gz'
  homepage 'http://www.isi.edu/nsnam/nam/'
  md5 '627a22187a44891a4cbc1b0f9c5b53e4'

  depends_on 'ns'

  def install
    require 'fileutils'
    IO.popen('patch -p1', 'w') do |p|
      p.puts %{diff -Naur nam-1.14/bbox.h nam-1.14/bbox.h
--- nam-1.14/bbox.h	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/bbox.h	2010-09-08 18:12:51.000000000 +0000
@@ -36,7 +36,7 @@
 #ifndef nam_bbox_h
 #define nam_bbox_h
 
-#include <X11/Xlib.h>
+#include <Tk.h>
 #include <float.h>
 
 struct BBox \{
diff -Naur nam-1.14/conf/configure.in.dynamic nam-1.14/conf/configure.in.dynamic
--- nam-1.14/conf/configure.in.dynamic	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/conf/configure.in.dynamic	2010-09-08 16:12:01.000000000 +0000
@@ -95,8 +95,13 @@
 	DL_LD_FLAGS=""
 	DL_LD_SEARCH_FLAGS=""
 	;;
-    Darwin-5.*|Darwin-6.*|Darwin-7.*|Darwin-8.*)
-	LDFLAGS="$\{LDFLAGS\} -Wl,-bind_at_load"	
+    Darwin-*)
+        SHLIB_CFLAGS="-fno-common -fPIC -pipe"
+        SHLIB_LD="cc -arch i386 -install_name /usr/local/lib/libns.dylib -dynamiclib -flat_namespace -undefined suppress"
+        SHLIB_SUFFIX=".dylib"
+        DL_LIBS=""
+	SHLD_FLAGS="-Wl,-bind_at_load -Wl,-multiply_defined -Wl,suppress"
+	LDFLAGS="$\{LDFLAGS\} -arch i386 -Wl,-bind_at_load"
 	;;
     dgux*)
 	SHLIB_CFLAGS="-K PIC"
diff -Naur nam-1.14/conf/configure.in.tcl nam-1.14/conf/configure.in.tcl
--- nam-1.14/conf/configure.in.tcl	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/conf/configure.in.tcl	2010-09-10 17:24:28.000000000 +0000
@@ -201,10 +201,13 @@
 
 
 NS_BEGIN_PACKAGE(tcl)
-NS_CHECK_HEADER_PATH(tcl.h,$TCL_H_PLACES,$d,$TCL_H_PLACES_D,V_INCLUDE_TCL,tcl)
-NS_CHECK_HEADER_PATH(tclInt.h,$TCL_H_PLACES,$d,$TCL_H_PLACES_D,V_INCLUDE_TCL,tcl)
-NS_CHECK_LIB_PATH(tcl$TCL_HI_VERS,$TCL_LIB_PLACES,$d,$TCL_LIB_PLACES_D,V_LIB_TCL,tcl)
-NS_CHECK_ANY_PATH(init.tcl,$TCL_TCL_PLACES,$d,$TCL_TCL_PLACES_D,V_LIBRARY_TCL,tcl)
+V_INCLUDE_TCL="-I/System/Library/Frameworks/Tcl.framework/Versions/8.4/PrivateHeaders -I/System/Library/Frameworks/Tcl.framework/Versions/8.4/Headers"
+V_INCLUDES="$V_INCLUDE_TCL $V_INCLUDES"
+V_DEFINES="-DHAVE_TCL_H -DHAVE_TCLINT_H $V_DEFINES"
+V_LIB_TCL="/System/Library/Frameworks/Tcl.framework/Versions/8.4/Tcl"
+V_LIBS="$V_LIB_TCL $V_LIBS"
+V_DEFINES="-DHAVE_LIB_TCL $V_DEFINES"
+V_LIBRARY_TCL="/System/Library/Frameworks/Tcl.framework/Versions/8.4/Resources/Scripts"
 
 dnl find the pesky http library
 tcl_http_library_dir=/dev/null
diff -Naur nam-1.14/conf/configure.in.tk nam-1.14/conf/configure.in.tk
--- nam-1.14/conf/configure.in.tk	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/conf/configure.in.tk	2010-09-10 17:25:37.000000000 +0000
@@ -39,6 +39,7 @@
                 $d/lib \\
                 $d/library"
 TK_TCL_PLACES=" \\
+                /System/Library/Frameworks/Tk.framework/Versions/8.4/Resources/Scripts \\
 		../lib/tk$TK_HI_VERS \\
 		../lib/tk$TK_VERS \\
 		../lib/tk$TK_ALT_VERS \\
@@ -164,8 +165,12 @@
                 /usr/lib"
 
 NS_BEGIN_PACKAGE(tk)
-NS_CHECK_HEADER_PATH(tk.h,$TK_H_PLACES,$d,$TK_H_PLACES_D,V_INCLUDE_TK,tk)
-NS_CHECK_LIB_PATH(tk$TK_HI_VERS,$TK_LIB_PLACES,$d,$TK_LIB_PLACES_D,V_LIB_TK,tk)
+V_INCLUDE_TK="-I/System/Library/Frameworks/Tk.framework/Versions/8.4/Headers -I/System/Library/Frameworks/Tcl.framework/Versions/8.4/PrivateHeaders -I/System/Library/Frameworks/Tcl.framework/Versions/8.4/Headers"
+V_INCLUDES="$V_INCLUDE_TK $V_INCLUDES"
+V_DEFINES="-DMAC_OSX_TK -DHAVE_TK_H $V_DEFINES"
+V_LIB_TK="/System/Library/Frameworks/Tk.framework/Versions/8.4/Tk"
+V_LIBS="$V_LIB_TK $V_LIBS"
+V_DEFINES="-DHAVE_LIB_TK $V_DEFINES"
 NS_CHECK_ANY_PATH(tk.tcl,$TK_TCL_PLACES,$d,$TK_TCL_PLACES_D,V_LIBRARY_TK,tk)
 NS_END_PACKAGE(tk,no)
 
diff -Naur nam-1.14/conf/configure.in.x11 nam-1.14/conf/configure.in.x11
--- nam-1.14/conf/configure.in.x11	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/conf/configure.in.x11	2010-09-08 16:04:05.000000000 +0000
@@ -56,10 +56,10 @@
 
 echo "checking for X11 library archive"
 if test "$x_libraries" = NONE ; then
-	AC_CHECK_LIB(X11, XOpenDisplay, x_libraries="", x_libraries=NONE)
+	#AC_CHECK_LIB(X11, XOpenDisplay, x_libraries="", x_libraries=NONE)
 	if test "$x_libraries" = NONE ; then
 		for i in $xlibdirs ; do
-			if test -r $i/libX11.a -o -r $i/libX11.so -o -r $i/libX11.dll.a; then
+			if test -r $i/libX11.a -o -r $i/libX11.dylib -o -r $i/libX11.dll.a; then
 				x_libraries=$i
 				break
 			fi
@@ -71,14 +71,14 @@
 	fi
 fi
 
-V_LIB_X11=-lX11
+V_LIB_X11="-L/usr/X11/lib -lX11"
 
 if test -n "$V_SHM" ; then
 	if test -z "$x_libraries" ; then
 		AC_CHECK_LIB(Xext, XShmAttach, V_Xext="-lXext", V_Xext=NONE, -lX11)
 	else
 		echo "checking for libXext.a"
-		if test -f $x_libraries/libXext.a -o -f $x_libraries/libXext.so; then
+		if test -f $x_libraries/libXext.a -o -f $x_libraries/libXext.dylib; then
 			V_Xext="-lXext"
 		else
 			echo "warning: compiling without -lXext"
diff -Naur nam-1.14/main.cc nam-1.14/main.cc
--- nam-1.14/main.cc	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/main.cc	2010-09-10 17:34:07.000000000 +0000
@@ -330,7 +330,7 @@
 #endif
 
 	Tcl_Interp *interp = Tcl_CreateInterp();
-#if 0
+#if 1
 	if (Tcl_Init(interp) == TCL_ERROR) \{
 		printf("%s\\n", interp->result);
 		abort();
@@ -341,8 +341,8 @@
         Tcl_SetVar(interp, "tcl_library", "./lib/tcl7.6", TCL_GLOBAL_ONLY);
         Tcl_SetVar(interp, "tk_library", "./lib/tk4.2", TCL_GLOBAL_ONLY);
 #else
-        Tcl_SetVar(interp, "tcl_library", "", TCL_GLOBAL_ONLY);
-        Tcl_SetVar(interp, "tk_library", "", TCL_GLOBAL_ONLY);
+        //Tcl_SetVar(interp, "tcl_library", "/System/Library/Frameworks/Tcl.framework/Versions/8.4/Resources/Scripts", TCL_GLOBAL_ONLY);
+        //Tcl_SetVar(interp, "tk_library", "/System/Library/Frameworks/Tk.framework/Versions/8.4/Resources/Scripts", TCL_GLOBAL_ONLY);
                                                                                 
         // this seems just a hack, should NOT have hard-coded library path!
         // why there's no problem with old  TCL/TK?
@@ -501,7 +501,7 @@
 			strcat(args, "z 1 ");
 			break;
 
-#ifndef WIN32
+#if 0
 		case 'S':
 			XSynchronize(Tk_Display(tk), True);
 			break;
diff -Naur nam-1.14/tcl/test/test-template nam-1.14/tcl/test/test-template
--- nam-1.14/tcl/test/test-template	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/tcl/test/test-template	2010-09-08 18:25:10.000000000 +0000
@@ -98,7 +98,7 @@
 fi
 
 # sucess can be true, false, or unknown
-if "$success" = true; then
+if [ "$success" = true ]; then
 		echo test output agrees with reference output.
 		exit 0
 else
diff -Naur nam-1.14/tkUnixInit.c nam-1.14/tkUnixInit.c
--- nam-1.14/tkUnixInit.c	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/tkUnixInit.c	2010-09-08 18:14:21.000000000 +0000
@@ -13,7 +13,7 @@
 TkpInit(Tcl_Interp *interp)
 #endif
 \{
-#ifndef WIN32
+#if 0
 	\{
 		extern void TkCreateXEventSource(void);
 		TkCreateXEventSource();
diff -Naur nam-1.14/view.cc nam-1.14/view.cc
--- nam-1.14/view.cc	2009-06-18 00:11:06.000000000 +0000
+++ nam-1.14/view.cc	2010-09-10 17:58:53.000000000 +0000
@@ -319,7 +319,7 @@
 	clip_.xmax = (float)width_;
 	clip_.ymax = (float)height_;
 	b.xrect(rect);
-#ifndef WIN32
+#if 0
 	for (int i = 0; i < paint->num_gc(); i++) \{
 		XSetClipRectangles(Tk_Display(tk_), paint->paint_to_gc(i),
 				   0, 0, &rect, 1, Unsorted);
@@ -330,7 +330,7 @@
 void View::clearClipRect()
 \{
 	Paint* paint = Paint::instance();
-#ifndef WIN32
+#if 0
 	for (int i = 0; i < paint->num_gc(); i++) \{
 		// XXX Or should I set it to the whole window???
 		XSetClipRectangles(Tk_Display(tk_), paint->paint_to_gc(i),}
    end
    ENV['CC'] = 'cc -arch i386'
    ENV['CXX'] = 'c++ -arch i386'
    system 'aclocal'
    system 'autoconf'
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make'
    Dir.mkdir "#{prefix}/bin"
    system 'make install'
    mv "#{prefix}/bin", "#{bin}" unless "#{prefix}/bin" == "#{bin}"
  end
end
