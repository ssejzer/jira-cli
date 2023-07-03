# jira-cli
Bash script to list/create/delete Jira Cloud issues from the command line

# Usage


## create a .env file with your instance details and credentials

```ini
# Your Personal Access Token
# https://confluence.atlassian.com/enterprise/using-personal-access-tokens-1026032365.html
URL='https://mycompany.atlassian.net'
USER=user@company.com
TOKEN=hip-hip-env-files
```


### To create an issue
```bash
./jira.sh create projectID issueType summary [description]
```

Valid issue types: bug/epic/story/task

### To delete an issue
```bash
./jira.sh delete issueID
```

### To list all project
```bash
./jira.sh list
```

### To list all project issues
```bash
./jira.sh list projectID
```

