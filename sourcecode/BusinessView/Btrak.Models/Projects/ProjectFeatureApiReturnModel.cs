using System;

namespace Btrak.Models.Projects
{
    public class ProjectFeatureApiReturnModel
    {
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsDelete { get; set; }
        public byte[] TimeStamp { get; set; }

        public UserMiniModel ProjectFeatureResponsiblePerson { get; set; }

        public int TotalCount { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
    }
}
