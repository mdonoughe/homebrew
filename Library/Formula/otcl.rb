require 'formula'

class Otcl <Formula
  url 'http://downloads.sourceforge.net/project/otcl-tclcl/OTcl/1.13/otcl-1.13.tar.gz'
  homepage 'http://otcl-tclcl.sourceforge.net/otcl/'
  md5 'f3e4864445429506397b720c7232e4c6'

  def install
    IO.popen('patch -p1', 'w') do |p|
      p.puts %{diff -Naur otcl-1.13/conf/configure.in.tcl otcl-1.13/conf/configure.in.tcl
--- otcl-1.13/conf/configure.in.tcl	2007-02-18 22:16:52.000000000 +0000
+++ otcl-1.13/conf/configure.in.tcl	2010-09-08 01:38:35.000000000 +0000
@@ -187,10 +187,14 @@
 
 
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
+V_LIBRARY_TCL="/System/Library/Tcl/8.4"
+#NS_CHECK_ANY_PATH(init.tcl,$TCL_TCL_PLACES,$d,$TCL_TCL_PLACES_D,V_LIBRARY_TCL,tcl)
 
 dnl find the pesky http library
 tcl_http_library_dir=/dev/null
@@ -202,7 +206,7 @@
 	$V_LIBRARY_TCL/http2.1 \\
 	$V_LIBRARY_TCL/http2.0 \\
 	$V_LIBRARY_TCL/http1.0 \\
-	"
+	#{Dir.glob('/System/Library/Tcl/tclsoap*').first}"
 NS_CHECK_ANY_PATH(http.tcl,$tcl_http_places,"","",tcl_http_library_dir,tcl)
 AC_MSG_CHECKING(Tcl http.tcl library)
 if test -f $tcl_http_library_dir/http.tcl
diff -Naur otcl-1.13/conf/configure.in.tk otcl-1.13/conf/configure.in.tk
--- otcl-1.13/conf/configure.in.tk	2007-02-18 22:16:52.000000000 +0000
+++ otcl-1.13/conf/configure.in.tk	2010-09-08 01:39:20.000000000 +0000
@@ -36,6 +36,7 @@
                 $d/lib \\
                 $d/library"
 TK_TCL_PLACES=" \\
+                /System/Library/Frameworks/Tk.framework/Versions/8.4/Resources/Scripts \\
 		../lib/tk$TK_HI_VERS \\
 		../lib/tk$TK_VERS \\
 		../lib/tk$TK_ALT_VERS \\
@@ -156,8 +157,12 @@
                 /usr/lib"
 
 NS_BEGIN_PACKAGE(tk)
-NS_CHECK_HEADER_PATH(tk.h,$TK_H_PLACES,$d,$TK_H_PLACES_D,V_INCLUDE_TK,tk)
-NS_CHECK_LIB_PATH(tk$TK_HI_VERS,$TK_LIB_PLACES,$d,$TK_LIB_PLACES_D,V_LIB_TK,tk)
+V_INCLUDE_TK="-I/System/Library/Frameworks/Tk.framework/Versions/8.4/Headers -I/System/Library/Frameworks/Tcl.framework/Versions/8.4/PrivateHeaders -I/System/Library/Frameworks/Tcl.framework/Versions/8.4/Headers"
+V_INCLUDES="$V_INCLUDE_TK $V_INCLUDES"
+V_DEFINES="-DHAVE_TK_H $V_DEFINES"
+V_LIB_TK="/System/Library/Frameworks/Tk.framework/Versions/8.4/Tk"
+V_LIBS="$V_LIB_TK $V_LIBS"
+V_DEFINES="-DHAVE_LIB_TK $V_DEFINES"
 NS_CHECK_ANY_PATH(tk.tcl,$TK_TCL_PLACES,$d,$TK_TCL_PLACES_D,V_LIBRARY_TK,tk)
 NS_END_PACKAGE(tk,no)
 
diff -Naur otcl-1.13/conf/configure.in.x11 otcl-1.13/conf/configure.in.x11
--- otcl-1.13/conf/configure.in.x11	2006-09-28 05:25:04.000000000 +0000
+++ otcl-1.13/conf/configure.in.x11	2010-09-08 00:49:56.000000000 +0000
@@ -58,7 +58,7 @@
 	AC_CHECK_LIB(X11, XOpenDisplay, x_libraries="", x_libraries=NONE)
 	if test "$x_libraries" = NONE ; then
 		for i in $xlibdirs ; do
-			if test -r $i/libX11.a -o -r $i/libX11.so; then
+			if test -r $i/libX11.a -o -r $i/libX11.dylib; then
 				x_libraries=$i
 				break
 			fi
@@ -70,7 +70,7 @@
 	fi
 fi
 
-V_LIB_X11=-lX11
+V_LIB_X11=-l/usr/X11/lib -lX11
 
 if test -n "$V_SHM" ; then
 	if test -z "$x_libraries" ; then
diff -Naur otcl-1.13/configure.in otcl-1.13/configure.in
--- otcl-1.13/configure.in	2007-02-04 01:41:50.000000000 +0000
+++ otcl-1.13/configure.in	2010-09-08 00:55:23.000000000 +0000
@@ -37,19 +37,12 @@
 fi
 
 case $system in
-    Darwin-5.*|Darwin-6.*)
+    Darwin-*) # Remove `-mcpu=7450' for G5 (PPC970) optimization:
 	SHLIB_CFLAGS="-fno-common -fPIC -pipe"
-	SHLIB_LD="cc -dynamiclib -flat_namespace -undefined suppress"
+	SHLIB_LD="cc -arch i386 -install_name /usr/local/lib/libotcl.dylib -dynamiclib -flat_namespace -undefined suppress /System/Library/Frameworks/Tcl.framework/Versions/8.4/Tcl"
 	SHLIB_SUFFIX=".dylib"
 	DL_LIBS=""
-	SHLD_FLAGS="-Wl,-bind_at_load -Wl,-multiply_defined -Wl,suppress"
-	;;
-    Darwin-7.*|Darwin-8.*) # Remove `-mcpu=7450' for G5 (PPC970) optimization:
-	SHLIB_CFLAGS="-fno-common -fPIC -pipe"
-	SHLIB_LD="cc -dynamiclib -flat_namespace -undefined suppress"
-	SHLIB_SUFFIX=".dylib"
-	DL_LIBS=""
-	SHLD_FLAGS="-Wl,-bind_at_load -Wl,-multiply_defined -Wl,suppress"
+	SHLD_FLAGS="-Wl,-bind_at_load -Wl,-multiply_defined -Wl,suppress /System/Library/Frameworks/Tcl.framework/Versions/8.4/Tcl"
 	;;
     HP-UX-*.08.*|HP-UX-*.09.*|HP-UX-*.10.*)
         SHLIB_CFLAGS="+z"}
    end
    ENV['CC'] = 'cc -arch i386'
    system 'aclocal'
    system 'autoconf'
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    # otcl cannot make and install in the same go
    system 'make'
    # otcl will not create these directories itself
    Dir.mkdir "#{prefix}/bin"
    Dir.mkdir "#{prefix}/include"
    Dir.mkdir "#{prefix}/lib"
    system 'make install'
    mv "#{prefix}/bin", bin unless "#{prefix}/bin" == bin
  end
end
