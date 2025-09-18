using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectOverViewApiReturnModel
    {
        public int ActiveGoalsCount { get; set; }
        public int BackLogGoalsCount { get; set; }
        public int UnderReplanGoalsCount { get; set; }
        public int ReportingMembersWork { get; set; }
        public int ProjectMemberCount { get; set; }
        public int ArchivedGoalsCount { get; set; }
        public int ParkedGoalsCount { get; set; }
        public int ProjectFeatureCount { get; set; }
        public int ActiveSprintsCount { get; set; }
        public int ReplanSprintsCount { get; set; }
        public int CompletedSprintsCount { get; set; }
        public int TemplatesCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ActiveGoalsCount = " + ActiveGoalsCount);
            stringBuilder.Append(", BackLogGoalsCount = " + BackLogGoalsCount);
            stringBuilder.Append(", UnderReplanGoalsCount = " + UnderReplanGoalsCount);
            stringBuilder.Append(", ReportingMembersWork = " + ReportingMembersWork);
            stringBuilder.Append(", ProjectMemberCount = " + ProjectMemberCount);
            stringBuilder.Append(", ArchivedGoalsCount = " + ArchivedGoalsCount);
            stringBuilder.Append(", ParkedGoalsCount = " + ParkedGoalsCount);
            stringBuilder.Append(", ProjectFeatureCount = " + ProjectFeatureCount);
            stringBuilder.Append(", ReplanSprintsCount = " + ReplanSprintsCount);
            return stringBuilder.ToString();
        }
    }
}
