using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomFields
{
   public class CustomFieldApiReturnModel
    {
        public Guid? CustomFieldId { get; set; }
        public Guid? CustomDataFormFieldId { get; set; }
        public int? ModuleTypeId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string FieldName { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public string FormKeys { get; set; }
        public string FormDataJson { get; set; }
        public string CreatedUserName { get; set; }
        public string ProfileImage { get; set; }
        public string CreatedByUserId { get; set; }
        public Guid? SubmittedByUserId { get; set; }
        public string SubmittedByUser { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public byte[] CustomFieldTimeStamp { get; set; }
        public DateTime? FormCreatedDateTime { get; set; }
    }
}
