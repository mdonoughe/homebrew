require 'formula'

class Tclcl <Formula
  url 'http://downloads.sourceforge.net/project/otcl-tclcl/TclCL/1.19/tclcl-src-1.19.tar.gz'
  homepage 'http://otcl-tclcl.sourceforge.net/tclcl/'
  md5 '023aefbd2e6d99ad96eb2cbe8acdbf4a'

  def install
    IO.popen('patch -p1', 'w') do |p|
      p.puts %{diff -Naur tclcl-1.19/conf/configure.in.tcl tclcl-1.19/conf/configure.in.tcl
--- tclcl-1.19/conf/configure.in.tcl	2007-02-18 22:16:52.000000000 +0000
+++ tclcl-1.19/conf/configure.in.tcl	2010-09-08 01:38:35.000000000 +0000
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
diff -Naur tclcl-1.19/conf/configure.in.tk tclcl-1.19/conf/configure.in.tk
--- tclcl-1.19/conf/configure.in.tk	2007-02-18 22:16:52.000000000 +0000
+++ tclcl-1.19/conf/configure.in.tk	2010-09-08 01:39:20.000000000 +0000
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
 
diff -Naur tclcl-1.19/conf/configure.in.x11 tclcl-1.19/conf/configure.in.x11
--- tclcl-1.19/conf/configure.in.x11	2006-09-28 05:25:04.000000000 +0000
+++ tclcl-1.19/conf/configure.in.x11	2010-09-08 00:49:56.000000000 +0000
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
diff -Naur tclcl-1.19/Makefile.in tclcl-1.19/Makefile.in
--- tclcl-1.19/Makefile.in	2007-03-10 23:18:00.000000000 +0000
+++ tclcl-1.19/Makefile.in	2010-09-08 03:15:23.000000000 +0000
@@ -88,12 +88,8 @@
 LIBRARY_TCL = @V_LIBRARY_TCL@
 
 
-TCL_76_LIBRARY_FILES = \\
-	$(LIBRARY_TCL)/init.tcl
-TCL_BASE_LIBRARY_FILES= \\
-	$(LIBRARY_TCL)/init.tcl \\
-	$(LIBRARY_TCL)/history.tcl \\
-	$(LIBRARY_TCL)/word.tcl
+TCL_76_LIBRARY_FILES = 
+TCL_BASE_LIBRARY_FILES= 
 TCL_80_LIBRARY_FILES = \\
 	$(TCL_BASE_LIBRARY_FILES) \\
 	$(LIBRARY_TCL)/http2.0/http.tcl}
    end
    ENV['CC'] = 'cc -arch i386'
    ENV['CXX'] = 'c++ -arch i386'
    system 'aclocal'
    system 'autoconf'
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make'
    Dir.mkdir("#{prefix}/bin")
    Dir.mkdir("#{prefix}/include")
    Dir.mkdir("#{prefix}/lib")
    system 'make install'
    mv "#{prefix}/bin", bin unless "#{prefix}/bin" == bin
  end
end
