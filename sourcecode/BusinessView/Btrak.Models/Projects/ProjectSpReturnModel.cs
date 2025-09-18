using System;

namespace Btrak.Models.Projects
{
    public class ProjectSpReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public string ProjectStatusColor { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public string CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public string FullName { get; set; }
        public Guid CompanyId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid RoleId { get; set; }
        public bool IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public Guid TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public string RoleName { get; set; }
        public string ProjectTypeName { get; set; }
        public int ActiveGoalCount { get; set; }
        public int NumberOfReds { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
