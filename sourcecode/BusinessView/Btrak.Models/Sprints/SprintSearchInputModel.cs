using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Sprints
{
    public class SprintSearchInputModel : SearchCriteriaInputModelBase
    {
        public SprintSearchInputModel() : base(InputTypeGuidConstants.SprintSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? SprintId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public string UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
        public bool? IsParked { get; set; }
        public string UserStoryName { get; set; }
        public Guid? ProjectId { get; set; }

        public string ProjectIds { get; set; }
        public string OwnerUserIds { get; set; }
        public string SprintResponsiblePersonIds { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string SprintStatusIds { get; set; }
        public string SprintName { get; set; }
        public DateTime? DeadLineDateFrom { get; set; }
        public DateTime? DeadLineDateTo { get; set; }
        public string ProjectFeatureIds { get; set; }
        public string BugPriorityIds { get; set; }
        public string DependencyUserIds { get; set; }
        public string BugCausedUserIds { get; set; }
        public string UserStoryTypeIds { get; set; }
        public string VersionName { get; set; }
        public string WorkItemTags { get; set; }
        public bool? IncludeArchived { get; set; }
        public bool? IncludeParked { get; set; }
        public string IsArchivedSprint { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public DateTime? UpdatedDateFrom { get; set; }
        public DateTime? UpdatedDateTo { get; set; }
        public DateTime? CreatedDateFrom { get; set; }
        public DateTime? CreatedDateTo { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public DateTime? SprintEndDate { get; set; }
        public bool? IsActiveSprints { get; set; }
        public bool? IsBacklogSprints { get; set; }
        public bool? IsReplanSprints { get; set; }
        public bool? IsDeleteSprints { get; set; }
        public bool? IsCompletedSprints { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SprintId = " + SprintId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            return stringBuilder.ToString();
        }
    }
}
