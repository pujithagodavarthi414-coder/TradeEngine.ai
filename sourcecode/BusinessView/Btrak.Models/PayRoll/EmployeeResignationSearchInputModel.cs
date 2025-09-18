using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeResignationSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeResignationSearchInputModel() : base(InputTypeGuidConstants.PayRollResignationStatusGuid)
        {
        }
        public Guid? EmployeeResignationId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ResignationApprovedById { get; set; }
        public Guid? ResignationStatusId { get; set; }
        public DateTimeOffset? ResignationDate { get; set; }
        public DateTime? LastDate { get; set; }
        public DateTimeOffset? ApprovedDate { get; set; }
        public string CommentByEmployee { get; set; }
        public string CommentByEmployer { get; set; }
        public bool? IsApproved { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ResignationStatusId= " + ResignationStatusId);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            stringBuilder.Append(", IsApproved= " + IsApproved);
            stringBuilder.Append(", TimeStamp= " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
