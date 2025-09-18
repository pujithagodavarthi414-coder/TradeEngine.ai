using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class JobCategoriesUpsertModel : InputModelBase
    {
        public JobCategoriesUpsertModel() : base(InputTypeGuidConstants.JobCategoriesInputCommandTypeGuid)
        {
        }

        public Guid? JobCategoryId { get; set; }
        public string JobCategoryName { get; set; }
        public bool? IsArchived { get; set; }
        public int? NoticePeriodInMonths { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", JobCategoryName = " + JobCategoryName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}