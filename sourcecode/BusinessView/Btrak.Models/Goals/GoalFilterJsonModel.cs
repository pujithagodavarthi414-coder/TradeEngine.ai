using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
   public class GoalFilterJsonModel
    {
        public string GoalStatusIds { get; set; }
        public string ProjectIds { get; set; }
        public string GoalResponsiblePersonIds { get; set; }
        public string OwnerUserIds { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string DeadlineDateFrom { get; set; }
        public string DeadlineDateTo { get; set; }
        public string GoalName { get; set; }
        public bool? IsIncludeArchived { get; set; }
        public bool? IsIncludeParked { get; set; }
        public bool? IsTrackedGoals { get; set; }
        public bool? IsProductiveGoals { get; set; }
        public bool? isNotOnTrack { get; set; }
        public bool? isOnTrack { get; set; }
        public string GoalTags { get; set; }
        public string WorkItemTags { get; set; }
        public string UserStoryTypeIds { get; set; }
        public string BugCausedUserIds { get; set; }
        public string DependencyUserIds { get; set; }
        public string BugPriorityIds { get; set; }
        public string ProjectFeatureIds { get; set; }
        public string UserStoryName { get; set; }
        public string VersionName { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public DateTime? CreatedDateFrom { get; set; }
        public DateTime? CreatedDateTo { get; set; }
        public DateTime? UpdatedDateFrom { get; set; }
        public DateTime? UpdatedDateTo { get; set; }
        public string SortBy { get; set; }
        public string SprintName { get; set; }
        public string SprintStatusIds { get; set; }
        public string SprintResponsiblePersonIds { get; set; }
        public string SprintStartDate { get; set; }
        public string SprintEndDate { get; set; }
    }
}
