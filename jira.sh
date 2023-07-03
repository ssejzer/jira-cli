#!/bin/bash

action=$1

source .env

if [ -z "$action" ] ; then
	echo "Usage"
	echo "$0 list [projectID]"
	echo "$0 create projectID issueType summary [description]"
	echo "$0 delete issueID"
	echo
	echo "Valid issue types: Bug/Epic/Story/Task"
	echo
#curl -D- -u username:password -X POST --data '{"fields":{"project":{"key": "PROJECTKEY"},"summary": "REST ye merry gentlemen.","description": "Creating of an issue using project keys and issue type names using the REST API","issuetype": {"name": "Bug"}}}' -H "Content-Type: application/json" https://mycompanyname.atlassian.net/rest/api/2/issue/

#        curl -Ss -u $USER:$TOKEN --request GET \
#                -H 'Accept: application/json' \
#                -H 'Content-Type: application/json;charset=iso-8859-1' \
#                "$URL/rest/api/2/project" | jq

elif [ "$action" == "create" ] ; then
	project="$2"
	if [ -z "$project" ] ; then
		echo "Create Issue Usage"
		echo "$0 create projectID issueType summary [description]"
		echo
	else
		issueType="$3"
		summary="$4"
		description="$5"
		data="{\"fields\":{\"project\":{\"key\": \"$project\"},\"summary\": \"$summary\",\"description\": \"$description\",\"issuetype\": {\"name\": \"$issueType\"}}}"
		i=$(curl -Ss -u $USER:$TOKEN --request POST --data "$data" \
	                -H 'Accept: application/json' \
	                -H 'Content-Type: application/json;charset=iso-8859-1' \
			"$URL/rest/api/2/issue")
		key=$(jq -r .key <<< $i)
		if [ "$key" == "null" ] ; then
			echo "$i"
		else
			echo "Created $key"
		fi
	fi
elif [ "$action" == "delete" ] ; then
	issue=$2
        curl -Ss -u $USER:$TOKEN --request DELETE \
                -H 'Accept: application/json' \
                "$URL/rest/api/2/issue/$issue"
elif [ "$action" == "list" ] ; then
	project="$2"
	if [ -z "$project" ] ; then
	        p=$(curl -Ss -u $USER:$TOKEN --request GET \
	                -H 'Accept: application/json' \
			"$URL/rest/api/2/project")
		echo "$p" | jq -r ' .[] | "\(.key) \(.name)"' 
	else
	        i=$(curl -Ss -u $USER:$TOKEN --request GET \
	                -H 'Accept: application/json' \
			"$URL/rest/api/2/search?jql=project=$project")
#		echo "$i"
		echo "$i" | jq -r ' .issues[] | "\(.key) \(.fields.issuetype.name) [\(.fields.status.name)] \(.fields.summary)" '
			#echo "$i" | jq -r ' .issues[] | [ .key .fields.issuetype.name ] '
	fi
fi

#		"$URL/rest/api/2/search?jql=")
