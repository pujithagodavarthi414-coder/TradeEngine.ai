using System;

namespace Btrak.Models.Projects
{
    public class ProjectModel
    {
        public Guid? ProjectId { get; set; }

        public string ProjectName { get; set; }

        public Guid? ProjectResponsiblePersonId { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }

        public bool IsArchived { get; set; }

        public string ProjectStatusColor { get; set; }

        public string UserName { get; set; }

        public string ProfileImage { get; set; }

        public string CreatedDateTime { get; set; }

        public string FullName { get; set; }

        public string RoleName { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}