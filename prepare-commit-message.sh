#!/bin/sh
# If you name your branches after the ticket number you're working on,
# then this script can automatically append that number to your commits

ORIGINAL_COMMIT_MESSAGE_FILENAME="$1"
TEMP_FILENAME=`mktemp /tmp/git-XXXXX`

# Store the original commit message
ORIGINAL_COMMIT_MESSAGE=`cat ${ORIGINAL_COMMIT_MESSAGE_FILENAME}`

# The ticket id is assumed to be embedded as digits in the branch name
TICKET_ID=`git branch | grep '^\*' | sed 's/[^0-9]//g'`

# The ticket id message will be added to the original commit message
TICKET_ID_MSG="Ticket ID: $TICKET_ID"

# Insert 2 newlines (to leave room for a new title and commit message)
# followed by the ticket id message and then the original commit message

# But only if a ticket id was found
if [ "$TICKET_ID" != "" ];
then
    if ! `echo $ORIGINAL_COMMIT_MESSAGE | grep "$TICKET_ID_MSG" 1> /dev/null 2>&1`
    then
        echo "\n\n$TICKET_ID_MSG\n$ORIGINAL_COMMIT_MESSAGE" > "$TEMP_FILENAME"
        cat "$TEMP_FILENAME" > "$ORIGINAL_COMMIT_MESSAGE_FILENAME"
    fi
fi
