using System;

namespace Btrak.Models.ConfigurationType
{
    public class ConfigurationTypeSpReturnModel
    {
        public Guid? ConfigurationTypeId { get; set; }
        public string ConfigurationTypeName { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public Guid? FieldId { get; set; }
        public string FieldName { get; set; }
        public bool IsMandatory { get; set; }
    }
}
