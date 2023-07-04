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
		projects=$(jq -r ' .[] | "\(.key) \(.name)"' <<< "$p")
		echo "$projects"
		echo $(wc -l <<< "$projects") projects
	else
	        i=$(curl -Ss -u $USER:$TOKEN --request GET \
	                -H 'Accept: application/json' \
			"$URL/rest/api/2/search?jql=project=$project")
		issues=$(jq -r ' .issues[] | "\(.key) \(.fields.issuetype.name) [\(.fields.status.name)] \(.fields.summary)" ' <<< "$i")
		echo "$issues"
		echo $(wc -l <<< "$issues") issues
	fi
fi

#		"$URL/rest/api/2/search?jql=")
