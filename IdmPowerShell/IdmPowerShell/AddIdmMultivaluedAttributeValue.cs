using System;
using System.Management.Automation;
using IdmNet;

// ReSharper disable InconsistentNaming

namespace IdmPowerShell
{
    [Cmdlet(VerbsCommon.Add, "IdmMultivaluedAttributeValue")]
    public class AddIdmMultivaluedAttributeValue : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, ValueFromPipeline = true, Position = 0, HelpMessage = "Object ID of the resource to modify.")]
        public string ObjectID { get; set; }

        [Parameter(Position = 1, HelpMessage = "Name of the Attribute to modify", Mandatory = true, ValueFromPipelineByPropertyName = true)]
        public string Attribute { get; set; }

        [Parameter(Position = 2, HelpMessage = "New value to add to the attribute", Mandatory = true, ValueFromPipelineByPropertyName = true)]
        public string NewValue { get; set; }

        private IdmNetClient _idmNet;
        protected override void BeginProcessing()
        {
            base.BeginProcessing();
            _idmNet = IdmNetClientFactory.BuildClient();
        }

        protected override async void ProcessRecord()
        {
            base.ProcessRecord();
            WriteVerbose(String.Format("Adding value [{0}] to Attribute [{1}] of Resource ID [{2}]", NewValue, Attribute, ObjectID));
            await _idmNet.AddValueAsync(ObjectID, Attribute, NewValue);
            WriteObject(NewValue);
        }
    }
}
