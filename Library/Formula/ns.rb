require 'formula'

class Ns <Formula
  url 'http://downloads.sourceforge.net/project/nsnam/ns-2/2.34/ns-2.34.tar.gz'
  homepage 'http://www.isi.edu/nsnam/ns/'
  md5 '5dbc3e0a5c240fe9a1c11bef9dd19ef7'

  depends_on 'otcl'
  depends_on 'tclcl'

  def install
    IO.popen('patch -p1', 'w') do |p|
      p.puts %{diff -Naur ns-2.34/conf/configure.in.dynamic ns-2.34/conf/configure.in.dynamic
--- ns-2.34/conf/configure.in.dynamic	2009-06-14 17:35:45.000000000 +0000
+++ ns-2.34/conf/configure.in.dynamic	2010-09-08 15:24:38.000000000 +0000
@@ -95,8 +95,13 @@
 	DL_LD_FLAGS=""
 	DL_LD_SEARCH_FLAGS=""
 	;;
-    Darwin-5.*|Darwin-6.*|Darwin-7.*|Darwin-8.*)
-	LDFLAGS="${LDFLAGS} -Wl,-bind_at_load"	
+    Darwin-*)
+        SHLIB_CFLAGS="-fno-common -fPIC -pipe"
+        SHLIB_LD="cc -arch i386 -install_name /usr/local/lib/libns.dylib -dynamiclib -flat_namespace -undefined suppress"
+        SHLIB_SUFFIX=".dylib"
+        DL_LIBS=""
+	SHLD_FLAGS="-Wl,-bind_at_load -Wl,-multiply_defined -Wl,suppress"
+	LDFLAGS="${LDFLAGS} -arch i386 -Wl,-bind_at_load"
 	;;
     dgux*)
 	SHLIB_CFLAGS="-K PIC"
diff -Naur ns-2.34/conf/configure.in.tcl ns-2.34/conf/configure.in.tcl
--- ns-2.34/conf/configure.in.tcl	2009-06-14 17:35:45.000000000 +0000
+++ ns-2.34/conf/configure.in.tcl	2010-09-08 14:20:13.000000000 +0000
@@ -201,10 +201,14 @@
 
 
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
@@ -216,7 +220,7 @@
 	$V_LIBRARY_TCL/http2.1 \\
 	$V_LIBRARY_TCL/http2.0 \\
 	$V_LIBRARY_TCL/http1.0 \\
-	"
+	#{Dir.glob('/System/Library/Tcl/tclsoap*').first}"
 NS_CHECK_ANY_PATH(http.tcl,$tcl_http_places,"","",tcl_http_library_dir,tcl)
 AC_MSG_CHECKING(Tcl http.tcl library)
 if test -f $tcl_http_library_dir/http.tcl
diff -Naur ns-2.34/conf/configure.in.tk ns-2.34/conf/configure.in.tk
--- ns-2.34/conf/configure.in.tk	2009-06-14 17:35:45.000000000 +0000
+++ ns-2.34/conf/configure.in.tk	2010-09-08 14:20:13.000000000 +0000
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
+V_DEFINES="-DHAVE_TK_H $V_DEFINES"
+V_LIB_TK="/System/Library/Frameworks/Tk.framework/Versions/8.4/Tk"
+V_LIBS="$V_LIB_TK $V_LIBS"
+V_DEFINES="-DHAVE_LIB_TK $V_DEFINES"
 NS_CHECK_ANY_PATH(tk.tcl,$TK_TCL_PLACES,$d,$TK_TCL_PLACES_D,V_LIBRARY_TK,tk)
 NS_END_PACKAGE(tk,no)
 
diff -Naur ns-2.34/conf/configure.in.x11 ns-2.34/conf/configure.in.x11
--- ns-2.34/conf/configure.in.x11	2009-06-14 17:35:45.000000000 +0000
+++ ns-2.34/conf/configure.in.x11	2010-09-08 15:16:30.000000000 +0000
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
 			echo "warning: compiling without -lXext"}
    end
    ENV['CC'] = 'cc -arch i386'
    ENV['CXX'] = 'c++ -arch i386'
    system 'aclocal'
    system 'autoconf'
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make'
    Dir.mkdir "#{prefix}/bin"
    Dir.mkdir "#{prefix}/share"
    system 'make install'
    # ns does not honor --mandir
    mv "#{prefix}/man", man unless "#{prefix}/man" == man
    mv "#{prefix}/bin", bin unless "#{prefix}/bin" == bin
  end
end
