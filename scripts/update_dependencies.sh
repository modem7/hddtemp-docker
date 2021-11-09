#!/bin/bash

JSON=$( cat dependencies.json )

for PACKAGE in $( echo $JSON | jq -r 'keys | .[]' ); do
	VERSION=$( apt-cache policy "$PACKAGE" | grep -oP '(?<=Candidate:\s)(.+)' )
	JSON=$( echo $JSON | jq '.[$package] = $version' --arg package $PACKAGE --arg version $VERSION )
done

echo $JSON | python -m json.tool > dependencies.json
