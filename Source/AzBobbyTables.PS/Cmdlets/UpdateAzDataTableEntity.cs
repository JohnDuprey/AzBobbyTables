﻿using PipeHow.AzBobbyTables.Validation;
using System.Collections;
using System.Management.Automation;

namespace PipeHow.AzBobbyTables.Cmdlets
{
    /// <summary>
    /// <para type="synopsis">Update one or more entities in an Azure Table.</para>
    /// </summary>
    [Cmdlet(VerbsData.Update, "AzDataTableEntity")]
    [Alias("Update-AzDataTableRow")]
    public class UpdateAzDataTableEntity : AzDataTableCommandBase
    {
        /// <summary>
        /// <para type="description">The entities to update in the table.</para>
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = "ConnectionString", ValueFromPipeline = true, Position = 1)]
        [Parameter(Mandatory = true, ParameterSetName = "SAS", ValueFromPipeline = true, Position = 1)]
        [Parameter(Mandatory = true, ParameterSetName = "Key", ValueFromPipeline = true, Position = 1)]
        [Parameter(Mandatory = true, ParameterSetName = "Token", ValueFromPipeline = true, Position = 1)]
        [ValidateEntity()]
        [Alias("Row", "Entry", "Property")]
        public Hashtable[] Entity { get; set; }

        /// <summary>
        /// The process step of the pipeline.
        /// </summary>
        protected override void ProcessRecord()
        {
            tableService.UpdateEntitiesInTable(Entity);
        }
    }
}
