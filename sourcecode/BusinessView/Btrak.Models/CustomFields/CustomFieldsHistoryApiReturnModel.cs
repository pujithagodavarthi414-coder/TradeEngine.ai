using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomFields
{
    public class CustomFieldsHistoryApiReturnModel
    {
        public Guid? CustomFieldHistoryId { get; set; }
        public Guid? CustomFieldId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
        public string FormJson { get; set; }
        public string FieldName { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
    }
}
