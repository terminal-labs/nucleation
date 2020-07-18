if  [ ! -f "bootstrap.sh" ]; then
    echo "Updating system and installing curl"
    apt update
    apt install curl -y

    echo "Downloading Salt Bootstrap"
    curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
fi

echo "Installing Salt with master and Python 3"
bash bootstrap-salt.sh -M -x python3

echo "Accepting the local minion's key"
salt-key -A -y


# Is Salt ready yet? Proceed once it is.
salt \* test.ping --force-color
while [ $? -ne 0 ]
do
    echo "Waiting for Salt to be up. Testing again."
    salt \* test.ping --force-color
done


echo "Running highstate. Waiting..."
salt \* state.highstate --force-color
