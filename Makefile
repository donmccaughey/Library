CONFIGURATION ?= Release
TMP ?= $(abspath tmp)
XCODEBUILD_FLAGS ?= -quiet
XCODEBUILD_TEST_FLAGS ?= -quiet
XCRUN_FLAGS ?=

SYMROOT ?= $(TMP)/build

arch := $(shell uname -m)


.SECONDEXPANSION :


.PHONY : all
all : library_mac


.PHONY : check
check : library_kit_tests


.PHONY : clean
clean :
	rm -rf $(TMP)


.PHONY : library_kit
library_kit : $(SYMROOT)/$(CONFIGURATION)/LibraryKit.framework/Versions/A/LibraryKit


.PHONY : library_kit_tests
library_kit_tests : $(TMP)/library_kit_tests.stamp.txt


.PHONY : library_mac
library_mac : $(SYMROOT)/$(CONFIGURATION)/Library/Contents/MacOS/Library


library_kit_sources := \
	LibraryKit/Book.h \
	LibraryKit/Book.m \
	LibraryKit/ElapsedTime.h \
	LibraryKit/ElapsedTime.m \
	LibraryKit/Errors.h \
	LibraryKit/Errors.m \
	LibraryKit/Format.h \
	LibraryKit/Format.m \
	LibraryKit/Library.h \
	LibraryKit/Library.m \
	LibraryKit/LibraryKit.h \
	LibraryKit/Stopwatch.h \
	LibraryKit/Stopwatch.m \
	LibraryKit/File/EPUB.h \
	LibraryKit/File/EPUB.m \
	LibraryKit/File/EPUBContainer.h \
	LibraryKit/File/EPUBContainer.m \
	LibraryKit/File/EPUBRootfile.h \
	LibraryKit/File/EPUBRootfile.m \
	LibraryKit/File/File.h \
	LibraryKit/File/OPFIdentifier.h \
	LibraryKit/File/OPFIdentifier.m \
	LibraryKit/File/OPFPackage.h \
	LibraryKit/File/OPFPackage.m \
	LibraryKit/File/PDF.h \
	LibraryKit/File/PDF.m \
	LibraryKit/File/XML.h \
	LibraryKit/File/XML.m \
	LibraryKit/File/XMLNamespaceMap.h \
	LibraryKit/File/XMLNamespaceMap.m \
	LibraryKit/File/ZIP.h \
	LibraryKit/File/ZIP.m

library_kit_test_sources := \
	LibraryKit/BookTests.m \
	LibraryKit/File/EPUBContainerTests.m \
	LibraryKit/File/OPFPackageTests.m \
	LibraryKit/File/XMLNamespaceMapTESTS.m


$(SYMROOT)/$(CONFIGURATION)/LibraryKit.framework/Versions/A/LibraryKit : \
		$(library_kit_sources) | $(SYMROOT)
	xcrun $(XCRUN_FLAGS) xcodebuild \
			-target LibraryKit \
			-configuration "$(CONFIGURATION)" \
			SYMROOT="$(SYMROOT)" \
			$(XCODEBUILD_FLAGS)


$(TMP)/library_kit_tests.stamp.txt : \
		$(SYMROOT)/$(CONFIGURATION)/LibraryKit.framework/Versions/A/LibraryKit \
		$(library_kit_test_sources)
	xcrun $(XCRUN_FLAGS) xcodebuild \
		-scheme LibraryKitTests \
		-sdk macosx \
		-destination "platform=macOS,arch=$(arch)" \
		$(XCODEBUILD_TEST_FLAGS) \
		test
	date > $@


library_mac_sources := \
	LibraryMac/AppDelegate.h \
	LibraryMac/AppDelegate.m \
	LibraryMac/BookListViewController.h \
	LibraryMac/BookListViewController.m \
	LibraryMac/InfoView.h \
	LibraryMac/InfoView.m \
	LibraryMac/Info.plist \
	LibraryMac/LibraryMac.entitlements \
	LibraryMac/Logger.h \
	LibraryMac/Logger.m \
	LibraryMac/main.m \
	LibraryMac/Notifications.h \
	LibraryMac/Notifications.m \
	LibraryMac/Base.lproj/MainMenu.xib \


$(SYMROOT)/$(CONFIGURATION)/Library/Contents/MacOS/Library : \
		$(library_kit_sources) $(library_mac_sources) | $(SYMROOT)
	xcrun $(XCRUN_FLAGS) xcodebuild \
			-target LibraryMac \
			-configuration "$(CONFIGURATION)" \
			SYMROOT="$(SYMROOT)" \
			$(XCODEBUILD_FLAGS)


$(TMP) \
$(SYMROOT) :
	mkdir -p $@
