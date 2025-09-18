using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class SearchTestCaseInputModel : SearchCriteriaInputModelBase
    {
        public SearchTestCaseInputModel() : base(InputTypeGuidConstants.TestCaseSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }
        public string Title { get; set; }
        public Guid? SectionId { get; set; }
        public Guid? TemplateId { get; set; }
        public Guid? TypeId { get; set; }
        public int Estimate { get; set; }
        public Guid? PriorityId { get; set; }
        public Guid? AutomationTypeId { get; set; }
        public int? TestCaseIdentity { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? AssignToId { get; set; }
        public string Version { get; set; }
        public Guid? TestSuiteId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? TestRunId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string CreatedOn { get; set; }
        public string UpdatedOn { get; set; }
        public List<Guid?> PriorityFilter { get; set; }
        public List<Guid?> TemplateFilter { get; set; }
        public List<Guid?> UpdatedByFilter { get; set; }
        public List<Guid?> CreatedByFilter { get; set; }
        public List<Guid?> AutomationTypeFilter { get; set; }
        public List<Guid?> EstimateFilter { get; set; }
        public List<Guid?> TypeFilter { get; set; }
        public List<Guid?> StatusFilter { get; set; }
        public List<Guid?> MultipleTestCaseIds { get; set; }
        public string PriorityFilterXml { get; set; }
        public string TestCaseIdsXml { get; set; }
        public string TemplateFilterXml { get; set; }
        public string UpdatedByFilterXml { get; set; }
        public string CreatedByFilterXml { get; set; }
        public string AutomationTypeFilterXml { get; set; }
        public string EstimateFilterXml { get; set; }
        public string TypeFilterXml { get; set; }
        public string StatusFilterXml { get; set; }
        public string MultipleSectionIds { get; set; }
        public bool? IsTestRunSelectedCases { get; set; }
        public bool? IsFiltersRequired { get; set; }
        public bool? IsHierarchical { get; set; }
        public bool? ClearFilter { get; set; }
        public bool IsForRuns { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", AutomationTypeId = " + AutomationTypeId);
            stringBuilder.Append(", PriorityId = " + PriorityId);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", TestCaseIdentity = " + TestCaseIdentity);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", CreatedByUserId = "+ CreatedByUserId);
            stringBuilder.Append(", TestRunId = " + TestRunId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", UpdatedOn = " + UpdatedOn);
            stringBuilder.Append(", PriorityFilter = " + PriorityFilter);
            stringBuilder.Append(", TemplateFilter = " + TemplateFilter);
            stringBuilder.Append(", UpdatedByFilter = " + UpdatedByFilter);
            stringBuilder.Append(", CreatedByFilter = " + CreatedByFilter);
            stringBuilder.Append(", MultipleTestCaseIds = " + MultipleTestCaseIds);
            stringBuilder.Append(", AutomationTypeFilter = " + AutomationTypeFilter);
            stringBuilder.Append(", EstimateFilter = " + EstimateFilter);
            stringBuilder.Append(", TypeFilter = " + TypeFilter);
            stringBuilder.Append(", StatusFilter = " + StatusFilter);
            stringBuilder.Append(", MultipleSectionIds = " + MultipleSectionIds);
            stringBuilder.Append(", IsTestRunSelectedCases = " + IsTestRunSelectedCases);
            stringBuilder.Append(", IsFiltersRequired = " + IsFiltersRequired);
            stringBuilder.Append(", IsHierarchical = " + IsHierarchical);
            stringBuilder.Append(", ClearFilter = " + ClearFilter);
            stringBuilder.Append(", IsForRuns = " + IsForRuns);
            return stringBuilder.ToString();
        }
    }
}
