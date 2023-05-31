# Get the list of alert rules
$alertRules = az monitor alert list --query "[*]"

# Create an empty array to store the alert rule and cost information
$alertRuleCosts = @()

# Loop through each alert rule
foreach ($alertRule in $alertRules) {

    # Get the resource ID of the alert rule
    $resourceId = $alertRule.resourceId

    # Get the estimated cost for the alert rule
    $cost = az monitor cost-management query `
        --query "sum(totals)" `
        --ids $resourceId `
        --start-date "last month" `
        --end-date "now" `
        --aggregation-type "totalCost"
        
    # Store the alert rule name and estimated cost in the array
    $alertRuleCosts += [pscustomobject]@{
        Name = $alertRule.name
        EstimatedCost = $cost.value
    }
}

# Output the alert rule and cost information in a table format
$alertRuleCosts | Format-Table -AutoSize
