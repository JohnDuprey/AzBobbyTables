---
external help file: AzBobbyTables.PS.dll-Help.xml
Module Name: AzBobbyTables
online version:
schema: 2.0.0
---

# Update-AzDataTableEntity

## SYNOPSIS
Update one or more entities in an Azure Table.

## SYNTAX

### TableOperation
```
Update-AzDataTableEntity -Entity <Hashtable[]> -Context <AzDataTableContext> [-CreateTableIfNotExists]
 [<CommonParameters>]
```

### Count
```
Update-AzDataTableEntity -Context <AzDataTableContext> [-CreateTableIfNotExists] [<CommonParameters>]
```

## DESCRIPTION
Update one or more entities already existing in an Azure Table.
For adding and overwriting, also see the command Add-AzDataTableEntity.

The PartitionKey and RowKey cannot be updated.

## EXAMPLES

### Example 1
```powershell
PS C:\> $UserEntity = Get-AzDataTableEntity -Filter "FirstName eq 'Bobby'" -TableName $TableName -ConnectionString $ConnectionString
PS C:\> $UserEntity['LastName'] = 'Tables'
PS C:\> Update-AzDataTableEntity -Entity $UserEntity -TableName $TableName -ConnectionString $ConnectionString
```

Update the last name of the user "Bobby" to "Tables" using a connection string.

## PARAMETERS

### -Entity
The entities to update in the table.

```yaml
Type: Hashtable[]
Parameter Sets: TableOperation
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CreateTableIfNotExists
If the table should be created if it does not exist.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
{{ Fill Context Description }}

```yaml
Type: AzDataTableContext
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable[]

## OUTPUTS

## NOTES

## RELATED LINKS
