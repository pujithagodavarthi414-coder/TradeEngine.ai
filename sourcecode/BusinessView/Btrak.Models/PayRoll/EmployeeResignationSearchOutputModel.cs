using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeResignationSearchOutputModel
    {
        public Guid? EmployeeResignationId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ResignationApprovedById { get; set; }
        public Guid? ResignationStatusId { get; set; }
        public DateTimeOffset? ResignationDate { get; set; }
        public DateTimeOffset? LastDate { get; set; }
        public DateTimeOffset? ApprovedDate { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public string EmployeeFullName { get; set; }
        public string EmployeeNumber { get; set; }
        
        public string ResignationApprovedByFullName { get; set; }
        public string StatusName { get; set; }
        public string CommentByEmployee { get; set; }
        public string CommentByEmployer { get; set; }
        public string ResignationStatusColour { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsWaitingForApproval { get; set; }
        public bool? IsRejected { get; set; }
        public Guid? ResignationRejectedById { get; set; }
        public DateTimeOffset? RejectedDate { get; set; }
        public string ResignationRejectedByFullName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
    }
}
