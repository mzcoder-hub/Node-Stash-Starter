#!/bin/bash

# Path: command/avail-clash-of-challenge/tx-requester/command.sh

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Source .bashrc to make nvm available in the current shell session
source ~/.bashrc

sudo apt-get update

# Install Node.js version 20.5.1 using nvm
nvm install v20.5.1

# Clone the repository
git clone https://github.com/karnotxyz/madara-get-started
cd madara-get-started

sudo apt-get update

# Install dependencies
npm install

# Run declare.js script
node scripts/declare.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json ./contracts/OpenZeppelinAccountCairoOne.casm.json

echo "You can use 'node scripts/deploy.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json 0x1' to deploy the transaction."

echo "Do you want to create a new transaction and cron it? (y/n)"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ; then
    echo "You selected Yes"

    # Create the schedule.js file and fill it with content
    filename="schedule.js"
    if [ -e "$filename" ]; then
        echo "File '$filename' already exists. Exiting."
        exit 1
    fi

    mkdir -p ~/tmp

    cd ~/madara-get-started

    cat <<EOF > "$filename"
const cron = require('node-cron');
const { exec } = require('child_process');

// Schedule the task to run every minute
cron.schedule('* * * * *', () => {
    // Execute the shell command
    exec('cd ~/madara-get-started && node scripts/deploy.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json 0x1 > ~/tmp/transaction.log', (error, stdout, stderr) => {
        if (error) {
            console.error(\`Error executing command: \${error}\`);
            return;
        }
        if (stderr) {
            console.error(\`Command stderr: \${stderr}\`);
            return;
        }
        console.log(\`Command stdout: \${stdout}\`);
    });
});
EOF

    npm install node-cron

    echo "Created file: $filename with initial content."
    echo "Run 'node schedule.js' to start the cron job"
    echo "Log file will be created at ~/tmp/transaction.log"
    echo "You can use 'tail -f ~/tmp/transaction.log' to see the logs"

    echo "Do you want to start the cron job now? (y/n)"

    read answer

    if [ "$answer" != "${answer#[Yy]}" ] ; then
        echo "You selected Yes"

        screen -S ScheduleTransaction -d -m

        node schedule.js

        echo "Ctrl + A, then press D to exit"

        echo "You can use 'screen -r ScheduleTransaction' to reattach the screen"

        echo "You can use 'screen -X -S ScheduleTransaction quit' to kill the screen"
    else
        echo "You selected No, you can run 'node schedule.js' to start the cron job."
    fi

else
    echo "You selected No, all has been set up. You can now use 'node scripts/deploy.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json 0x1' to deploy the transaction."
fi
