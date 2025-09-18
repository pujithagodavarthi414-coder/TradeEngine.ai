using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class CustomFormSubmissionSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CustomFormSubmissionSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetCustomFormSubmissions)
        {
        }
        public Guid? FormSubmissionId { get; set; }
        public bool? AssignedByYou { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormSubmissionId = " + FormSubmissionId);
            stringBuilder.Append(" AssignedByYou = " + AssignedByYou);
            return stringBuilder.ToString();
        }
    }
}
