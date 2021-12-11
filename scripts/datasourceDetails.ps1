#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Identify the workspace containing the datasets and the export file
$WSName = "Sales Analytics Dev"
$DataSourceFile = "C:\Users\Hchalla\Desktop\WSDataSources.csv"

#3. Retrieve the workspace ID
$WSID = (Get-PowerBIWorkspace -Scope Organization -Name $WSName).Id

#4. Retrieve datasets within workspaces
$WSDatasets = Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID | Select-Object *, @{Name="Workspace";Expression={$WSName}}

#5. Loop over datasets within the workspace to retrieve data sources
$WSDataSources = ForEach($DS in $WSDatasets)
    {
        $DSID = $DS.Id
        $DSName = $DS.Name
        $WSName = $DS.Workspace
        Get-PowerBIDatasource -Scope Organization -DatasetId $DSID | `
        Select-Object *,@{Name="Dataset";Expression={$DSName}},@{Name="Workspace";Expression={$WSName}},@{Name="DateRetrieved";Expression={Get-Date}}
    }

#6. Export data sources of workspace datasets to CSV
$WSDataSources | Export-Csv $DataSourceFile







#2. Define the workspace name and export path file
$WSName = "Sales Analytics Dev"
$CSVFile = "C:\Users\hchalla\Desktop\WorkspaceUsers.csv"

#3. Retrieve the workspace, expand the users property and export to a CSV file
$WS = Get-PowerBIWorkspace -Scope Organization -Name $WSName

#4. Export the users property to a CSV file (AccessRight,UserPrincipalName,Identifier,PrincipalType)
$WS | Select-Object Users -ExpandProperty Users | Export-Csv $CSVFile
