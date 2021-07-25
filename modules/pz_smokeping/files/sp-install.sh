#!/bin/bash
#
# Install SmokePing from binary distribution
#
#
# I don't really like the Debian package depending upon Apache2

# Note -- issues with slow build of IO::tty -- patch thirdparty/Makefile to do `cpanm --verbose` instead of `cpanm -q`

set -e -u -o pipefail

HASH=430fd58030a494068a897f772c052fc0979ebdd38d1859a03820e098628d36b4
ROOT=/opt/smokeping
TMPDIR=$(mktemp -d)

# patch Makefile for thirdparty -- IO::Tty fails to build on Pi Zero due to 60s timeout on build. --verbose disables timeout
read -r -d '' PATCH <<'EOF'
-- smokeping-2.7.3/thirdparty/Makefile.in	2018-12-20 10:22:43.000000000 +0000
+++ ../smokeping-2.7.3/thirdparty/Makefile.in	2021-07-25 10:45:15.486704819 +0100
@@ -407,14 +407,14 @@
 all-local: touch
 
 touch: CPAN/touch ../config.status ../PERL_MODULES
-	$(AM_V_GEN)cat ../PERL_MODULES  | grep -v '#' | PERL_CPANM_HOME=$(THIRDPARTY_DIR) xargs $(PERL) $(THIRDPARTY_DIR)/bin/cpanm -q --notest --local-lib-contained $(THIRDPARTY_DIR)  --mirror file://$(THIRDPARTY_DIR)/CPAN --mirror-only
+	$(AM_V_GEN)cat ../PERL_MODULES  | grep -v '#' | PERL_CPANM_HOME=$(THIRDPARTY_DIR) xargs $(PERL) $(THIRDPARTY_DIR)/bin/cpanm --verbose --notest --local-lib-contained $(THIRDPARTY_DIR)  --mirror file://$(THIRDPARTY_DIR)/CPAN --mirror-only
 	$(AM_V_GEN)touch touch
 
 CPAN/touch: ../PERL_MODULES
 	echo "POPULATING OUR LOCAL micro CPAN"
-	$(AM_V_GEN)$(URL_CAT) https://cpanmin.us | PERL_CPANM_HOME=$(THIRDPARTY_DIR) $(PERL) - -q --notest --local-lib $(THIRDPARTY_DIR) --save-dists $(THIRDPARTY_DIR)/CPAN --force App::cpanminus
-	$(AM_V_GEN)PERL_CPANM_HOME=$(THIRDPARTY_DIR)/Ore $(THIRDPARTY_DIR)/bin/cpanm -q --notest  --local-lib $(THIRDPARTY_DIR)/Ore File::Which OrePAN
-	$(AM_V_GEN)cat ../PERL_MODULES | grep -v '#' | PERL_CPANM_HOME=$(THIRDPARTY_DIR) xargs $(PERL) $(THIRDPARTY_DIR)/bin/cpanm -q --self-contained --notest --local-lib-contained $(THIRDPARTY_DIR) --save-dists $(THIRDPARTY_DIR)/CPAN
+	$(AM_V_GEN)$(URL_CAT) https://cpanmin.us | PERL_CPANM_HOME=$(THIRDPARTY_DIR) $(PERL) - --verbose --notest --local-lib $(THIRDPARTY_DIR) --save-dists $(THIRDPARTY_DIR)/CPAN --force App::cpanminus
+	$(AM_V_GEN)PERL_CPANM_HOME=$(THIRDPARTY_DIR)/Ore $(THIRDPARTY_DIR)/bin/cpanm --verbose --notest  --local-lib $(THIRDPARTY_DIR)/Ore File::Which OrePAN
+	$(AM_V_GEN)cat ../PERL_MODULES | grep -v '#' | PERL_CPANM_HOME=$(THIRDPARTY_DIR) xargs $(PERL) $(THIRDPARTY_DIR)/bin/cpanm --verbose --self-contained --notest --local-lib-contained $(THIRDPARTY_DIR) --save-dists $(THIRDPARTY_DIR)/CPAN
 	- $(AM_V_GEN)PERL5LIB=$(THIRDPARTY_DIR)/Ore/lib/perl5 $(THIRDPARTY_DIR)/Ore/bin/orepan_index.pl --repository $(THIRDPARTY_DIR)/CPAN 2>&1 | egrep -v 'INFO.*Ore|uninitialized|Useless'
 # Ore fails to extract the version form DBI
 	$(AM_V_GEN)gunzip -c CPAN/modules/02packages.details.txt.gz | perl -pe 's{^(DBI\s+)undef(\s+\S+/DBI-)(\d+\.\d+)(\.tar)}{$$1$$3$$2$$3$$4}' |  gzip | cat > x.gz && mv x.gz CPAN/modules/02packages.details.txt.gz
EOF

cd $TMPDIR

curl --fail-early 'https://oss.oetiker.ch/smokeping/pub/smokeping-2.7.3.tar.gz' -o smokeping.tar.gz

if [ "$(shasum -a 256 smokeping.tar.gz | awk '{print $1}')" != "$HASH" ]; then
    logger "failed hash validation on smokeping.tar.gz"
    exit 1
fi

tar xzf smokeping.tar.gz

rsync -r smokeping-2.7.3/ $ROOT/

cd $ROOT/

./configure

# patch Makefile for thirdparty -- IO::Tty fails to build on Pi Zero due to 60s timeout on build. --verbose disables timeout
echo $PATCH | patch -u thirdparty/Makefile.in

make

cd $ROOT
rm -rf -- $TMPDIR

touch $ROOT/.sp-install-complete
