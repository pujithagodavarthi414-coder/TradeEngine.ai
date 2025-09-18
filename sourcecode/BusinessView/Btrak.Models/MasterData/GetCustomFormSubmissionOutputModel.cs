using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class GetCustomFormSubmissionOutputModel
    {
        public Guid? FormSubmissionId { get; set; }
        public Guid? GenericFormId { get; set; }
        public Guid? AssignedToUserId { get; set; }
        public string AssignedToUserName { get; set; }
        public string AssignedToUserImage { get; set; }
        public Guid? AssignedByUserId { get; set; }
        public string AssignedByUserName { get; set; }
        public string AssignedByUserImage { get; set; }
        public string FormData { get; set; }
        public string FormJson { get; set; }
        public string FormName { get; set; }
        public string FormTypeName { get; set; }
        public string Status { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? LastestModificationOn { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormSubmissionId = " + FormSubmissionId);
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", AssignedToUserId = " + AssignedToUserId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", AssignedToUserName = " + AssignedToUserName);
            stringBuilder.Append(", AssignedByUserId = " + AssignedByUserId);
            stringBuilder.Append(", AssignedByUserName = " + AssignedByUserName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
