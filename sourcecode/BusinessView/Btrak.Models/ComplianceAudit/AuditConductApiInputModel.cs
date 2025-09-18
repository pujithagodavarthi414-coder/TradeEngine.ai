using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;


namespace Btrak.Models.ComplianceAudit
{
    public class AuditConductApiInputModel : InputModelBase
    {
        public AuditConductApiInputModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
        {
        }

        public Guid? ConductId { get; set; }
        public Guid? ParentConductId { get; set; }
        public string AuditConductName { get; set; }
        public bool? IsArchived { get; set; }
        public bool IsCompleted { get; set; }
        public bool IsIncludeAllQuestions { get; set; }
        public List<SelectedQuestionModel> SelectedQuestions { get; set; }
        public List<Guid?> SelectedCategories { get; set; }
        public Guid? AuditId { get; set; }
        public string AuditConductDescription { get; set; }
        public string SearchText { get; set; }
        public string SelectedQuestionsXml { get; set; }
        public string SelectedCategoriesXml { get; set; }
        public DateTime? DeadlineDate { get; set; }
        public DateTime? CronStartDate { get; set; }
        public DateTime? CronEndDate { get; set; }
        public string CronExpression { get; set; }
        public string periodValue { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? DateFrom { get; set; }
        public Guid? UserId { get; set; }
        public string PeriodValue { get; set; }
        public string StatusFilter { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public Guid? AuditRatingId { get; set; }
        public List<Guid?> BusinessUnitIds { get; set; }
        public string BusinessUnitIdsList { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConductId = " + ConductId);
            stringBuilder.Append("AuditRatingId = " + AuditRatingId);
            stringBuilder.Append(", AuditConductName = " + AuditConductName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsIncludeAllQuestions = " + IsIncludeAllQuestions);
            stringBuilder.Append(", AuditId = " + AuditId);
            stringBuilder.Append(", AuditConductDescription = " + AuditConductDescription);
            stringBuilder.Append(", SelectedQuestions = " + SelectedQuestions);
            stringBuilder.Append(", SelectedCategories = " + SelectedCategories);
            stringBuilder.Append(", SelectedQuestionsXml = " + SelectedQuestionsXml);
            stringBuilder.Append(", SelectedCategoriesXml = " + SelectedCategoriesXml);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", PeriodValue = " + PeriodValue);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", StatusFilter = " + StatusFilter);
            return stringBuilder.ToString();
        }
    }
}

