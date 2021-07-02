#/bin/bash

set -e

# -----------------------------------------
function echoSyntax() {
# -----------------------------------------
  echo ""
  echo "Syntax:"
  echo "    $0 [--noinstall]"
  echo "    $0 [-h|--help]"
  echo ""
  echo "--noinstall: do not call 'install.sh' on each submodule"
  echo ""
}

PARAM="$1"
if [ "$PARAM" = "-h" -o "$PARAM" = "--help" ] ; then
  echoSyntax
  exit 0
fi
if [ "$PARAM" != "" -a "$PARAM" != "--noinstall" ] ; then
  echo "ERROR"
  echoSyntax
  exit 1
fi

if [ ! -f "./Version" ]; then
  echo "ERROR: Cannot find file './Version"
  exit 1
fi

INSTALL=1
[ "$PARAM" = "--noinstall" ] && INSTALL=0

# ====================================
# Build all components 
# ====================================
ROOT_DIR="$PWD"
echo ""
echo "****************************"
echo "Build QbForm-js"
echo "****************************"
cd "$ROOT_DIR/QbForm-js"
echo ""
if [ "$INSTALL" -ne 0 ] ; then
  echo "---------------------------"
  echo "QbForm-js - Install"
  echo "---------------------------"
  vc-scripts/./install.sh
fi
echo ""
echo "-----------------------------"
echo "QbForm-js - Build"
echo "-----------------------------"
vc-scripts/./build.sh

echo ""
echo "****************************"
echo "Build QbForm-js-table"
echo "****************************"
cd "$ROOT_DIR/QbForm-js-table"
echo ""
if [ "$INSTALL" -ne 0 ] ; then
  echo "---------------------------"
  echo "QbForm-js-table - Install"
  echo "---------------------------"
  vc-scripts/./install.sh
fi
echo ""
echo "-----------------------------"
echo "QbForm-js-table - Build"
echo "-----------------------------"
vc-scripts/./build.sh

echo ""
echo "****************************"
echo "Build QbForm-reactjs"
echo "****************************"
cd "$ROOT_DIR/QbForm-reactjs"
echo ""
if [ "$INSTALL" -ne 0 ] ; then
  echo "---------------------------"
  echo "QbForm-reactjs - Install"
  echo "---------------------------"
  vc-scripts/./install.sh
fi
echo ""
echo "-----------------------------"
echo "QbForm-reactjs - Build"
echo "-----------------------------"
vc-scripts/./build.sh

echo ""
echo "****************************"
echo "Build QbForm-vuejs"
echo "****************************"
cd "$ROOT_DIR/QbForm-vuejs"
echo ""
if [ "$INSTALL" -ne 0 ] ; then
  echo "---------------------------"
  echo "QbForm-vuejs - Install"
  echo "---------------------------"
  vc-scripts/./install.sh
fi
echo ""
echo "-----------------------------"
echo "QbForm-vuejs - Build"
echo "-----------------------------"
vc-scripts/./build.sh

cd "$ROOT_DIR"

# ====================================
# Generate ZIP file
# ====================================
VERSION=$( cat "./Version" | head -n1 )
TMP_DIR="/tmp/QbForm-all-$VERSION"
rm -Rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
mkdir "$TMP_DIR/QbForm-$VERSION"
mkdir "$TMP_DIR/QbForm-reactjs-$VERSION"
mkdir "$TMP_DIR/QbForm-vuejs-$VERSION"
cp QbForm-js/dist/* "$TMP_DIR/QbForm-$VERSION/"
cp QbForm-js-table/dist/* "$TMP_DIR/QbForm-$VERSION/"
cp QbForm-reactjs/dist/* "$TMP_DIR/QbForm-reactjs-$VERSION/"
cp QbForm-vuejs/dist/* "$TMP_DIR/QbForm-vuejs-$VERSION/"
rm -f "$TMP_DIR/QbForm-vuejs-$VERSION/demo.html"
OLD_PWD="$PWD"
cd /tmp
zip -r QbForm-all-$VERSION.zip QbForm-all-$VERSION
cd "$OLD_PWD"
mv /tmp/QbForm-all-$VERSION.zip .
rm -Rf "$TMP_DIR"
echo ""
echo ""
echo "Zip file generated : QbForm-all-$VERSION.zip"
echo ""
