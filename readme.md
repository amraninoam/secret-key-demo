## Details
This script is meant to demonstrate why it's a bad idea to *revert* a bad commit, when dealing with sensitive information. Especially a **secret** key...

The script
- Creates an empty git repo in a randomaly generated folder
- Creates 'dummy' commits in that repo (till total_commits) by writing random files in that folder.
- During the process:
    - It randomly selects a place in the commit chain
    - It generates a **private** key and add it to the git repo
    - It removes the key from the git repo using "revert" approach
- Eventually, it displays the **hidden** private key using `git log -S "PRIVATE"`

## Implementation
Run the script `./create-repo.sh` in your `~/temp` folder.