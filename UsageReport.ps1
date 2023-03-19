#########
$startDate = Get-Date "2023-02-01"
$endDate = Get-Date "2023-02-28"
$resourceGroup = 
$instanceName = 
$usageDetails = Get-AzConsumptionUsageDetail -StartDate $startDate -EndDate $endDate -ResourceGroup $resourceGroup -InstanceName $instanceName -Expand MeterDetails
$dailyUsage = $usageDetails | Group-Object -Property @{Expression = {$_.UsageEnd.ToShortDateString() + " " + $_.MeterName}}
$meterUsage = $usageDetails | Group-Object -Property MeterName, ResourceName
$dailyUsage | Select-Object Name, Count, @{Name="Usage"; Expression={($_.Group | Measure-Object -Property UsageQuantity -Sum).Sum}}, @{Name="Cost"; Expression={($_.Group | Measure-Object -Property PretaxCost -Sum).Sum}} | Export-Csv -Path "daily_usage.csv" -NoTypeInformation
$meterUsage | Select-Object Name, Count, @{Name="Usage"; Expression={($_.Group | Measure-Object -Property UsageQuantity -Sum).Sum}}, @{Name="Cost"; Expression={($_.Group | Measure-Object -Property PretaxCost -Sum).Sum}} | Export-Csv -Path "meter_usage.csv" -NoTypeInformation
$usageDetails | Where-Object { $_.MeterName -eq "Standard Data Transfer Out" } | Measure-Object -Property UsageQuantity -Sum | Select-Object -ExpandProperty Sum
$usageDetails | Where-Object { $_.MeterName -eq "Standard Data Transfer Out" } | Measure-Object -Property PretaxCost -Sum | Select-Object -ExpandProperty Sum
$dailyUsage | Select-Object  -ExpandProperty Group

##########

$startDate = Get-Date "2023-02-01"
$endDate = Get-Date "2023-02-28"
$resourceGroup = 
$instanceName = 
$usageDetails = Get-AzConsumptionUsageDetail -StartDate $startDate -EndDate $endDate -ResourceGroup $resourceGroup -InstanceName $instanceName -Expand MeterDetails
$usageDetails | Select-Object UsageStart, UsageEnd, BillingPeriodName, InstanceName, UsageQuantity, BillableQuantity, PretaxCost, MeterId, @{Name="UnitOfMeasure"; Expression={$_.MeterDetails.Unit}} | Export-Csv -Path "usage_details.csv" -NoTypeInformation


$startDate = Get-Date "2023-02-01"
$endDate = $startDate.AddDays(1).AddSeconds(-1)
$resourceGroup = 
$instanceName = 

$usageDetails = Get-AzConsumptionUsageDetail -StartDate $startDate -EndDate $endDate -ResourceGroup $resourceGroup -InstanceName $instanceName -Expand MeterDetails -IncludeMeterDetails -IncludeAdditionalProperties
$meterUsage = $usageDetails | Group-Object -Property MeterName, ResourceName

$meterUsage | Select-Object Name, Count, @{Name="Usage"; Expression={("{0:n2} {1}" -f $_.Group[0].UsageQuantity, $_.Group[0].UnitOfMeasure)}}, @{Name="Cost"; Expression={("{0:n2} {1}" -f $_.Group[0].PretaxCost, $_.Group[0].Currency)}} | Export-Csv -Path "meter_usage.csv" -NoTypeInformation


########

$startDate = Get-Date "2023-02-01"
$endDate = Get-Date "2023-02-01"
$resourceGroup = 
$instanceName = 

$usageDetails = Get-AzConsumptionUsageDetail -StartDate $startDate -EndDate $endDate -ResourceGroup $resourceGroup -InstanceName $instanceName -Expand MeterDetails
$usageDetails | Export-Csv -Path "C:\temp\usagereport_1.csv" -NoTypeInformation -Verbose
$usageDetails
$usageDetails | Sort-Object UsageQuantity -Descending | Format-Table MeterId,UsageStart,UsageEnd,UsageQuantity,InstanceName,BillableQuantity,Currency,PretaxCost,Product -AutoSize
$usageDetails | Select-Object MeterId,UsageStart,UsageEnd,UsageQuantity,InstanceName,BillableQuantity,Currency,PretaxCost,Product | Export-Csv -Path "C:\temp\usagereport_2.csv" -NoTypeInformation -Verbose
