using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GenericFormSubmittedUpsertInputModel : InputModelBase
    {
        public GenericFormSubmittedUpsertInputModel() : base(InputTypeGuidConstants.GenericFormSubmittedUpsertInputModel)
        {
        }

        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public string FormJson { get; set; }

        public string OldFormJson { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? PublicFormId { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? IsFinalSubmit { get; set; }
        public bool? IsApproved { get; set; }
        public string UniqueNumber { get; set; }
        public bool? IsNewRecord { get; set; }
        public string Status { get; set; }
        public string Stage { get; set; }
        public Guid? SubmittedUserId { get; set; }
        public Guid? SubmittedCompanyId { get; set; }
        public bool SubmittedByFormDrill { get; set; }
        public string RecordAccessibleUsers { get; set; }
        public string WorkflowMessage { get; set; }
        public string WorkflowSubject { get; set; }
        public List<ScenarioModel> StagesScenarios { get; set; }
        public string NotificationMessage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GenericFormSubmittedId = " + GenericFormSubmittedId);
            stringBuilder.Append(", CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }

    public class HistoryOutputModel
    {
        public string Field { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
    }
}
