using System;

namespace Btrak.Models.ProjectType
{
    public class ProjectTypeSpReturnModel
    {
        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public int ProjectsCount { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
