payload=$(mktemp $TMPDIR/script-request.XXXXXX)

cat > $payload <&0

shell=$(jq -r '.source.shell // "/bin/bash"' < $payload)
filename=$(jq -r '.source.filename // ""' < $payload)
body="$(jq -r '.source.body // ""' < $payload)"

if [ -z "$filename" ]
then
  echo >&2 "invalid payload (missing filename):"
  cat $payload >&2
  exit 1
fi
if [ -z "$body" ]
then
  echo >&2 "invalid payload (missing body):"
  cat $payload >&2
  exit 1
fi

calc_reference() {
  cat <<SCRIPT | sha1sum | cut -f1 -d' '
#!$shell
$body
SCRIPT
}

