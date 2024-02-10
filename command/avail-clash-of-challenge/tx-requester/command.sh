# Path: command/avail-clash-of-challenge/tx-requester/command.sh

# Install nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

source ~/.bashrc

# Define available versions
versions=("v20.5.1" "v20.7.0" "20.11.0")

# Prompt user to select a version
echo "Please select Node Version You want to install:"
select version in "${versions[@]}"; do
    case $version in
        "v20.5.1")
            echo "You selected v20.5.1"
            # Add commands for v20.5.1
            nvm install v20.5.1
            ;;
        "v20.7.0")
            echo "You selected v20.7.0"
            # Add commands for v20.7.0
            nvm install v20.7.0        
            ;;
        "20.11.0")
            echo "You selected 20.11.0"
            # Add commands for 20.11.0
            nvm install 20.11.0
            ;;
        *) echo "Invalid option";;
    esac
    break
done

git clone https://github.com/karnotxyz/madara-get-started
cd madara-get-started
npm i

node scripts/declare.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json ./contracts/OpenZeppelinAccountCairoOne.casm.json

echo "you can use  `node scripts/deploy.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json 0x1` to deploy the Transaction"

echo "or did you want to create a new Transaction and cron those? (y/n)"

read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "You selected Yes"
    # Append '.js' extension to the filename
    filename="schedule.js"

    # Check if the file already exists
    if [ -e "schedule.js" ]; then
        echo "File 'schedule.js' already exists. Exiting."
        exit 1
    fi

    mkdir ~/tmp

# Create the .js file and fill it with content
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

echo "Created file: $filename with initial content."

echo "run Node schedule.js to start the cron job"
echo "log file will be created at ~/tmp/transaction.log"
echo "you can use `tail -f ~/tmp/transaction.log` to see the logs"
echo "wanna start the cron job now? (y/n)"

read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "You selected Yes"
    node schedule.js
else
    echo "You selected No"
fi


else
    echo "You selected No"
fi

echo "You selected No, all has ben seet up, you can now use `node scripts/deploy.js ./contracts/OpenZeppelinAccountCairoOne.sierra.json 0x1` to deploy the Transaction"
###