using System;

namespace Btrak.Models.Projects
{
    public class ProjectFeatureSpReturnModel
    {
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsDelete { get; set; }
        public bool IsArchived { get; set; }

        public Guid? ProjectFeatureResponsiblePersonId { get; set; }
        public string ProjectFeatureResponsiblePersonName { get; set; }
        public string ProfileImage { get; set; }

        public int TotalCount { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
