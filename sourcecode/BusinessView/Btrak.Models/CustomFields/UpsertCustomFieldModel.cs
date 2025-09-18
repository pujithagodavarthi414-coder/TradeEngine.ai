using System;

namespace Btrak.Models.CustomFields
{
   public class UpsertCustomFieldModel
    {
        public Guid? CustomFieldId { get; set; }
        public Guid? CustomDataFormFieldId { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public string FormDataJson { get; set; }
        public string FormKeys { get; set; }
        public int? ModuleTypeId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string TimeZone { get; set; }
       
    }
}
