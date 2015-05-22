#!/bin/bash
PKG_NAME="snmp"
PKG_DESCRIPTION="The SNMP extension provides a very simple and easily usable toolset for managing remote devices via the Simple Network Management Protocol."

source vars.sh

#################################################

SOURCE_VERSION=`dpkg -l php-*-source-zend-server | grep '^ii' | tail -n1 | awk {'print $3'}`
PHP_VERSION_MAJOR=`echo $SOURCE_VERSION | cut -d'+' -f1 | cut -d '.' -f1-2`
PHP_VERSION_MINOR=`echo $SOURCE_VERSION | cut -d'+' -f1 | cut -d '.' -f3`
PHP_VERSION_REV=`echo $SOURCE_VERSION | cut -d'+' -f2`

PHP_VERSION="${PHP_VERSION_MAJOR}.${PHP_VERSION_MINOR}"

#################################################
echo "Cleanup old.."
rm *.deb

rm "usr/local/zend" -r

mkdir -p "usr/local/zend/lib/php_extensions"
mkdir -p "usr/local/zend/etc/conf.d"

echo "Compiling new"
cd /usr/local/zend/share/php-source/php-${PHP_VERSION}/ext/${PKG_NAME}/
/usr/local/zend/bin/phpize
./configure --with-php-config=/usr/local/zend/bin/php-config
make

echo "Preparing package"
cd -
cp /usr/local/zend/share/php-source/php-${PHP_VERSION}/ext/${PKG_NAME}/modules/${PKG_NAME}.so usr/local/zend/lib/php_extensions/
echo "extension=/usr/local/zend/lib/php_extensions/${PKG_NAME}.so" > "usr/local/zend/etc/conf.d/${PKG_NAME}.ini"

# Deal with conflicts and replaces
CONFLICTS=""
case "$PHP_VERSION" in
"5.3")
    CONFLICTS="5.4 5.5 5.6"
    ;;
"5.4")
    CONFLICTS="5.3 5.5 5.6"
    ;;
"5.5")
    CONFLICTS="5.3 5.4 5.6"
    ;;
"5.6")
    CONFLICTS="5.3 5.4 5.5"
    ;;
esac

# Deal with dependencies
PKG_DEP=""
for d in $CONFLICTS
do
   PKG_DEP+="--conflicts php-5.3-${d}-zend-server\n"
   PKG_DEP+="--replaces php-5.3-${d}-zend-server\n"
done


# Actually package it
fpm -s dir -t deb \
--description "${PKG_DESCRIPTION}" \
--maintainer "$PKG_MAINTAINER" \
--vendor "$PKG_VENDOR" \
--url "http://www.zend.com/en/products/server" \
$(echo -e $PKG_DEP) \
--replaces php5-${PKG_NAME} \
--conflicts php5-${PKG_NAME} \
--provides php5-${PKG_NAME} \
--depends php-${PHP_VERSION_MAJOR}-common-extensions-zend-server \
--version "${PHP_VERSION}" \
--iteration "${PHP_VERSION_REV}" \
--architecture amd64 \
--deb-priority optional \
--name php-${PHP_VERSION_MAJOR}-${PKG_NAME}-zend-server usr
