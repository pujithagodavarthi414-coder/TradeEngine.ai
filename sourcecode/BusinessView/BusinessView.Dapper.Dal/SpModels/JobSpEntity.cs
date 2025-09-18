using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class JobSpEntity
    {
        public Guid Id { get; set; }
        public Guid DesignationId { get; set; }
        public Guid EmployeeId { get; set; }
        public Guid EmploymentStatusId { get; set; }
        public Guid JobCategoryId { get; set; }
        public DateTime JoinedDate { get; set; }
        public Guid DepartmentId { get; set; }
        public Guid LocationId { get; set; }
        public DateTime? ContrcatStartDate { get; set; }
        public DateTime? ContrcatEndDate { get; set; }
        public string ContractDetails { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public Guid FileId { get; set; }
        public string FileName { get; set; }
        public DateTime TerminatedDate { get; set; }
        public Guid TerminationReasonId { get; set; }
    }
}