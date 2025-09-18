using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ProjectsSpEntity
    {
        public Guid ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public string CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public Guid CompanyId { get; set; }
        public string ProjectStatusColor { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public string RoleName { get; set; }
        public string FullName { get; set; }
    }
}
