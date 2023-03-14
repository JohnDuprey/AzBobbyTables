﻿using PipeHow.AzBobbyTables.Validation;
using System.Collections;
using System.Management.Automation;

namespace PipeHow.AzBobbyTables.Cmdlets;

/// <summary>
/// <para type="synopsis">Update one or more entities in an Azure Table.</para>
/// </summary>
[Cmdlet(VerbsData.Update, "AzDataTableEntity")]
public class UpdateAzDataTableEntity : AzDataTableOperationCommand
{
    /// <summary>
    /// <para type="description">The entities to update in the table.</para>
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = "TableOperation", ValueFromPipeline = true)]
    [ValidateEntity()]
    public Hashtable[] Entity { get; set; }

    /// <summary>
    /// The process step of the pipeline.
    /// </summary>
    protected override void ProcessRecord() => tableService.UpdateEntitiesInTable(Entity);
}
