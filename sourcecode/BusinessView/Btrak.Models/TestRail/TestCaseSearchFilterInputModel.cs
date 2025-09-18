using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseSearchFilterInputModel : SearchCriteriaInputModelBase
    {
        public TestCaseSearchFilterInputModel() : base(InputTypeGuidConstants.TestCaseSearchFilterCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }
        public Guid? AutomationTypeId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? CreatedDateFrom { get; set; }
        public DateTime? CreatedDateTo { get; set; }
        public bool IsMatchAllEstimate { get; set; }
        public List<MatchModels> Estimate { get; set; }
        public string EstimateXml { get; set; }
        public Guid? PriorityId { get; set; }
        public bool IsMatchAllReferences { get; set; }
        public List<MatchModels> References { get; set; }
        public string ReferencesXml { get; set; }
        public Guid? SectionId { get; set; }
        public Guid? TemplateId { get; set; }
        public bool IsMatchAllTitle { get; set; }
        public List<MatchModels> Title { get; set; }
        public string TitleXml { get; set; }
        public Guid? TypeId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string UpdatedOn { get; set; }
        public DateTime? UpdatedDateFrom { get; set; }
        public DateTime? UpdatedDateTo { get; set; }
        public bool IsMatchAll { get; set; }
        public int? TestCaseIntId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? AssignToId { get; set; }
        public string Version { get; set; }
        public Guid? TestSuiteId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append(", AutomationTypeId = " + AutomationTypeId);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", CreatedDateFrom = " + CreatedDateFrom);
            stringBuilder.Append(", CreatedDateTo = " + CreatedDateTo);
            stringBuilder.Append(", IsMatchAllEstimate = " + IsMatchAllEstimate);
            stringBuilder.Append(", EstimateXml = " + EstimateXml);
            stringBuilder.Append(", PriorityId = " + PriorityId);
            stringBuilder.Append(", IsMatchAllReferences = " + IsMatchAllReferences);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", ReferencesXml = " + ReferencesXml);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", IsMatchAllTitle = " + IsMatchAllTitle);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", TitleXml = " + TitleXml);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedOn = " + UpdatedOn);
            stringBuilder.Append(", UpdatedDateFrom = " + UpdatedDateFrom);
            stringBuilder.Append(", UpdatedDateTo = " + UpdatedDateTo);
            stringBuilder.Append(", IsMatchAll = " + IsMatchAll);
            stringBuilder.Append(", TestCaseIntId = " + TestCaseIntId);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }


    public class MatchModels
    {
        public string FilterType { get; set; }

        public string MatchWord { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FilterType = " + FilterType);
            stringBuilder.Append(", MatchWord = " + MatchWord);
            return stringBuilder.ToString();
        }
    }
}
