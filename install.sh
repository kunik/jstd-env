#!/bin/sh

#_SBIN_DIR="/usr/local/sbin"
#_BIN_DIR="/usr/local/bin"
_SBIN_DIR="$HOME/local/sbin"
_BIN_DIR="$HOME/local/bin"

_JAR_URL="http://js-test-driver.googlecode.com/files/JsTestDriver-1.3.1.jar"

sbin_jstd_dir="${_SBIN_DIR}/jstd-env"

# Check if temp dir is set in env
tmp=$TMPDIR
if [ "x$tmp" = "x" ]; then
    tmp="/tmp"
fi

tmp="${tmp}/jstd.$$"

# Create empty dir
rm -rf "$tmp" || true
mkdir "$tmp"

if [ $? -ne 0 ]; then
    echo "Failed to mkdir $tmp" >&2
    exit 1
fi

# Preserve working directory path
current_dir=$PWD
cd ${tmp}

# Download sources
echo "Downloading sources"
curl -L http://github.com/kunik/jstd-env/tarball/master | tar xzvf -

ret=$?
if [ ${ret} -ne 0 ]; then
  echo "Faild to download jstd-env sources" >&2
  exit ${ret}
fi
cd *
pwd

# Download JsTestDriver.jar
echo "Downloading JsTestDriver.jar"
jar_path=${tmp}/JsTestDriver.jar
curl -L ${_JAR_URL} -o ${jar_path}

ret=$?
if [ ${ret} -ne 0 ]; then
  echo "Faild to download JsTestDriver.jar" >&2
  exit ${ret}
fi

# Download scripts and install
mkdir "${sbin_jstd_dir}" \
    && cp jstd.sh "${sbin_jstd_dir}" \
    && cp -r jstd_stuff "${sbin_jstd_dir}" \
    && cp ${jar_path} "${sbin_jstd_dir}/jstd_stuff" \
        && chmod a+r -R "${sbin_jstd_dir}" \
        && chmod a+rx "${sbin_jstd_dir}/jstd.sh" \
        && chmod a+rx "${sbin_jstd_dir}/jstd_stuff/scripts/run.sh" \
    && ln -s "${sbin_jstd_dir}/jstd.sh" "${_BIN_DIR}/jstd" \
    && ln -s "${sbin_jstd_dir}/jstd_stuff" "${_BIN_DIR}/jstd_stuff" \
&& cd "${current_dir}" \
&& rm -rf "${tmp}" \
&& echo "Done!"

ret=$?
if [ ${ret} -ne 0 ]; then
  echo "Faild" >&2
fi
exit ${ret}