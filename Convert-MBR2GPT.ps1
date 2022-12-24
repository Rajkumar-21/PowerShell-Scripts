# Get the number of the disk that you want to convert
$diskNumber = (Get-Disk | Where-Object {$_.FriendlyName -eq "E:"}).Number

# Start the diskpart utility
diskpart

# Select the disk
echo "select disk $diskNumber" | diskpart

# Clean the disk
echo "clean" | diskpart

# Convert the disk to GPT
echo "convert gpt" | diskpart

# Exit the diskpart utility
echo "exit" | diskpart
