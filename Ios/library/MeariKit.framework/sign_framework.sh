cd "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
code_sign() {
  # Use the current code_sign_identitiy
  echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
  echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements $1"
  /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
}
echo "Sign MeariKit Framework"

for file in $(find . -type f -perm +111); do
  # Skip non-dynamic libraries
  echo "file in $file"
  if ! [[ "$(file "$file")" == *"dynamically linked shared library"* ]]; then
    continue
  fi
  # Get architectures for current file
  if [ "${CODE_SIGNING_REQUIRED}" == "YES" ]; then
      echo "codesign file  -- $file"
      code_sign "${file}"
  fi
  
done
