using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportingConfigurationUpsertInputModel : InputModelBase
    {
        public StatusReportingConfigurationUpsertInputModel() : base(InputTypeGuidConstants.StatusReportingConfigurationUpsertInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public string ConfigurationName { get; set; }
        public Guid GenericFormId { get; set; }
        public string EmployeeIds { get; set; }
        public string StatusConfigurationOptions { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", EmployeeIds = " + EmployeeIds);
            stringBuilder.Append(", StatusConfigurationOptions = " + StatusConfigurationOptions);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
