using System;
using System.Text;

namespace Btrak.Models.ProjectType
{
    public class ProjectTypeApiReturnModel
    {
        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public string ArchivedOn { get; set; }
        public int ProjectsCount { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectTypeId = " + ProjectTypeId);
            stringBuilder.Append(", ProjectTypeName = " + ProjectTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ArchivedOn = " + ArchivedOn);
            stringBuilder.Append(", ProjectsCount = " + ProjectsCount);
            return stringBuilder.ToString();
        }
    }
}
